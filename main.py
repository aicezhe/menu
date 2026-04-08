"""
Gallo d'Oro — FastAPI Backend
Запуск: uvicorn main:app --reload
Сайт: http://127.0.0.1:8000
"""
from dotenv import load_dotenv
load_dotenv()
from fastapi import FastAPI, Depends, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_, select
import os

from database import get_db
from models import Dish, DishTranslation, Allergen, DishAllergen, Wine, WinePairing

app = FastAPI(title="Gallo d'Oro API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ═══════════════════════════════════════
# МАППИНГ аллергенов (вопрос → БД)
# ═══════════════════════════════════════
ALLERGEN_MAP = {
    "Glutine":              ["glutine"],
    "Lattosio":             ["latte"],
    "Pesce/Frutti di mare": ["pesce", "molluschi"],
    "Frutta a guscio":      ["frutta a guscio"],
    "Uova":                 ["uova"],
}

SUPPORTED_LANGS = ["it", "en", "ru", "de", "fr", "es", "uk", "zh", "ja"]


# ═══════════════════════════════════════
# СХЕМЫ ЗАПРОСА / ОТВЕТА
# ═══════════════════════════════════════

class FilterRequest(BaseModel):
    allergens:  List[str] = []   # ["Glutine", "Lattosio", ...]
    diet:       str = ""         # "Vegetariano" / "Pescetariano" / "Vegano" / ""
    menu_type:  str = ""         # "tradizione" / "gourmet" / ""
    categories: List[str] = []   # ["antipasti", "primi", "secondi"]
    lang:       str = "it"


class DishOut(BaseModel):
    id:          int
    name_it:     str
    name:        str
    description: Optional[str]
    adapt_note:  Optional[str]
    price:       float
    category:    str
    menu_type:   str
    allergens:   List[str]

    class Config:
        from_attributes = True


class FilterResponse(BaseModel):
    antipasti: List[DishOut] = []
    primi:     List[DishOut] = []
    secondi:   List[DishOut] = []
    total:     int = 0


# ═══════════════════════════════════════
# ЛОГИКА ФИЛЬТРАЦИИ
# ═══════════════════════════════════════

def build_query(db: Session, request: FilterRequest):
    """
    Строит SQL запрос на основе ответов пользователя.
    Каждый ответ отсекает неподходящие блюда.
    """
    query = db.query(Dish).filter(Dish.is_active == True)

    # Фильтр по категориям (Q4)
    if request.categories:
        query = query.filter(Dish.category.in_(request.categories))

    # Фильтр по типу меню (Q3)
    if request.menu_type and request.menu_type.lower() != "indifferente":
        query = query.filter(Dish.menu_type == request.menu_type.lower())

    # Фильтр по диете (Q2)
    if request.diet == "Vegano":
        query = query.filter(Dish.is_vegan == True)
    elif request.diet == "Vegetariano":
        query = query.filter(
            and_(Dish.is_meat == False, Dish.is_fish == False)
        )
    elif request.diet == "Pescetariano":
        query = query.filter(Dish.is_meat == False)

    # Фильтр по аллергенам (Q1)
    # Убираем блюда с аллергеном,
    # НО оставляем если can_adapt == аллерген (можно приготовить без него)
    allergen_keys = []
    for selected in request.allergens:
        if selected == "Nessuna":
            continue
        allergen_keys.extend(ALLERGEN_MAP.get(selected, []))

    for key in allergen_keys:
        has_allergen_subq = (
            select(DishAllergen.dish_id)
            .join(Allergen, DishAllergen.allergen_id == Allergen.id)
            .where(Allergen.name == key)
            .scalar_subquery()
        )
        # Исключаем блюда с аллергеном, кроме тех где can_adapt == key
        query = query.filter(
            ~(
                Dish.id.in_(has_allergen_subq) &
                (Dish.can_adapt != key)
            )
        )

    return query


def dish_to_out(dish: Dish, lang: str) -> DishOut:
    """Конвертирует ORM объект → Pydantic с переводом на нужный язык"""
    translation = dish.get_translation(lang)
    return DishOut(
        id          = dish.id,
        name_it     = dish.name_it,
        name        = translation.name if translation else dish.name_it,
        description = translation.description if translation else None,
        adapt_note  = translation.adapt_note if translation else None,
        price       = float(dish.price),
        category    = dish.category,
        menu_type   = dish.menu_type,
        allergens   = [a.name for a in dish.allergens],
    )


# ═══════════════════════════════════════
# ENDPOINTS
# ═══════════════════════════════════════

@app.get("/")
def root():
    return FileResponse("index.html")

@app.get("/menu")
def menu_page():
    return FileResponse("menu.html")

@app.get("/helper")
def helper_page():
    return FileResponse("helper.html")

@app.get("/about")
def about_page():
    if os.path.exists("about.html"):
        return FileResponse("about.html")
    return FileResponse("index.html")


@app.post("/api/filter", response_model=FilterResponse)
def filter_dishes(request: FilterRequest, db: Session = Depends(get_db)):
    """
    Главный endpoint бота.
    Получает ответы на вопросы пользователя → возвращает отфильтрованные блюда.

    Пример запроса:
    {
        "allergens": ["Lattosio"],
        "diet": "Vegetariano",
        "menu_type": "tradizione",
        "categories": ["antipasti", "primi"],
        "lang": "ru"
    }

    Ответ:
    {
        "antipasti": [ {id, name, description, price, allergens, ...} ],
        "primi":     [ ... ],
        "secondi":   [],
        "total":     8
    }
    """
    lang = request.lang if request.lang in SUPPORTED_LANGS else "it"

    if not request.categories:
        request.categories = ["antipasti", "primi", "secondi"]

    dishes = build_query(db, request).all()

    response = FilterResponse()
    for dish in dishes:
        out = dish_to_out(dish, lang)
        if dish.category == "antipasti":
            response.antipasti.append(out)
        elif dish.category == "primi":
            response.primi.append(out)
        elif dish.category == "secondi":
            response.secondi.append(out)

    response.total = (
        len(response.antipasti) +
        len(response.primi) +
        len(response.secondi)
    )
    return response


@app.get("/api/dishes", response_model=List[DishOut])
def get_all_dishes(
    lang:      str = Query("it"),
    category:  Optional[str] = Query(None),
    menu_type: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    """Все активные блюда — можно фильтровать по category и menu_type"""
    lang = lang if lang in SUPPORTED_LANGS else "it"
    query = db.query(Dish).filter(Dish.is_active == True)
    if category:
        query = query.filter(Dish.category == category)
    if menu_type:
        query = query.filter(Dish.menu_type == menu_type)
    dishes = query.order_by(Dish.category, Dish.menu_type).all()
    return [dish_to_out(d, lang) for d in dishes]


@app.get("/api/dishes/{dish_id}", response_model=DishOut)
def get_dish(
    dish_id: int,
    lang: str = Query("it"),
    db: Session = Depends(get_db)
):
    """Одно блюдо по id"""
    lang = lang if lang in SUPPORTED_LANGS else "it"
    dish = db.query(Dish).filter(
        Dish.id == dish_id,
        Dish.is_active == True
    ).first()
    if not dish:
        raise HTTPException(status_code=404, detail="Dish not found")
    return dish_to_out(dish, lang)


@app.get("/api/allergens")
def get_allergens(db: Session = Depends(get_db)):
    """Все аллергены в базе"""
    return [a.name for a in db.query(Allergen).order_by(Allergen.name).all()]

SUPPORTED_LANGS_WINE = ["it", "en", "ru", "de", "fr", "es", "uk", "zh", "ja"]

class WineRequest(BaseModel):
    dish_type:   str = "any"      # meat / fish / vegetarian / vegan / any
    menu_type:   str = ""
    categories:  List[str] = []

    format:      str = "bottle"   # glass / house / bottle
    local_only:  bool = False     # только Parma/Emilia
    color:       str = ""
    style:       str = ""
    price_min:   float = 0
    price_max:   float = 9999

    lang:        str = "it"


class WineOut(BaseModel):
    id:           int
    name:         str
    producer:     Optional[str]
    region:       Optional[str]
    grape:        Optional[str]
    color:        str
    style:        str
    description:  Optional[str]
    price_bottle: Optional[float]
    price_glass:  Optional[float]
    price_quarter: Optional[float]
    price_half:   Optional[float]
    is_local:     bool
    score:        int = 0

    class Config:
        from_attributes = True


def get_wine_description(wine: "Wine", lang: str) -> Optional[str]:
    if lang == "ru" and wine.description_ru:
        return wine.description_ru
    if lang == "en" and wine.description_en:
        return wine.description_en
    return wine.description_it


def wine_to_out(wine: "Wine", lang: str, score: int = 0) -> WineOut:
    return WineOut(
        id            = wine.id,
        name          = wine.name,
        producer      = wine.producer,
        region        = wine.region,
        grape         = wine.grape,
        color         = wine.color,
        style         = wine.style,
        description   = get_wine_description(wine, lang),
        price_bottle  = float(wine.price_bottle) if wine.price_bottle else None,
        price_glass   = float(wine.price_glass) if wine.price_glass else None,
        price_quarter = float(wine.price_quarter) if wine.price_quarter else None,
        price_half    = float(wine.price_half) if wine.price_half else None,
        is_local      = wine.is_local,
        score         = score,
    )


@app.post("/api/wines", response_model=List[WineOut])
def recommend_wines(request: WineRequest, db: Session = Depends(get_db)):
    try:
        lang = request.lang if request.lang in SUPPORTED_LANGS_WINE else "it"
        limit = 3

        if request.format == "glass":
            query = db.query(Wine).filter(
                Wine.is_active == True,
                Wine.section == "mescita",
            )
            wines = _score_and_sort(query.all(), request, db, limit)
            return [wine_to_out(w, lang, s) for w, s in wines]

        query = db.query(Wine).filter(
            Wine.is_active == True,
            Wine.section == "bottle",
        )
        if request.local_only:
            query = query.filter(Wine.is_local == True)
        if request.color:
            query = query.filter(Wine.color == request.color)
        if request.style:
            query = query.filter(Wine.style == request.style)
        if request.price_min > 0:
            query = query.filter(Wine.price_bottle >= request.price_min)
        if request.price_max < 9999:
            query = query.filter(Wine.price_bottle <= request.price_max)

        wines = _score_and_sort(query.all(), request, db, limit)
        return [wine_to_out(w, lang, s) for w, s in wines]

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def _score_and_sort(wines, request: WineRequest, db: Session, limit: int):
    scored = []
    for wine in wines:
        total = wine.sort_order
        for p in wine.pairings:
            if p.dish_type == "any" or p.dish_type == request.dish_type:
                total += p.score
        scored.append((wine, total))
    scored.sort(key=lambda x: (-x[1], x[0].price_bottle or 0))
    return scored[:limit]


# ═══════════════════════════════════════
# AI WINE RECOMMENDATION
# ═══════════════════════════════════════

import httpx
import json

ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY", "")
class AIWineRequest(BaseModel):
    dishes:     List[str] = []   # названия блюд которые заказал гость
    format:     str = "bottle"   # glass / bottle
    local_only: bool = False
    price_min:  float = 0
    price_max:  float = 9999
    lang:       str = "it"

class AIWineOut(BaseModel):
    id:           int
    name:         str
    producer:     Optional[str]
    region:       Optional[str]
    grape:        Optional[str]
    color:        str
    style:        str
    price_bottle: Optional[float]
    price_glass:  Optional[float]
    price_quarter: Optional[float]
    price_half:   Optional[float]
    is_local:     bool
    ai_reason:    str = ""   # объяснение от AI почему это вино подходит

    class Config:
        from_attributes = True


@app.post("/api/wines/ai", response_model=List[AIWineOut])
async def recommend_wines_ai(request: AIWineRequest, db: Session = Depends(get_db)):
    try:
        lang = request.lang if request.lang in SUPPORTED_LANGS_WINE else "it"

        # Загружаем вина из БД с учётом фильтров
        section = "mescita" if request.format == "glass" else "bottle"
        query = db.query(Wine).filter(
            Wine.is_active == True,
            Wine.section == section,
        )
        if request.local_only:
            query = query.filter(Wine.is_local == True)
        # Фильтр по цене только для бутылок
        if request.format != "glass":
            if request.price_min > 0:
                query = query.filter(Wine.price_bottle >= request.price_min)
            if request.price_max < 9999:
                query = query.filter(Wine.price_bottle <= request.price_max)

        all_wines = query.all()
        if not all_wines:
            return []

        # Формируем список вин для промпта
        wines_list = []
        for w in all_wines:
            price = float(w.price_glass or 0) if request.format == "glass" else float(w.price_bottle or 0)
            wines_list.append({
                "id": w.id,
                "name": w.name,
                "producer": w.producer or "",
                "region": w.region or "",
                "grape": w.grape or "",
                "color": w.color,
                "style": w.style,
                "price": price,
                "is_local": w.is_local,
                "description": w.description_it or "",
            })

        # Промпт для AI
        lang_instruction = {
            "it": "Rispondi in italiano.",
            "en": "Reply in English.",
            "ru": "Отвечай на русском языке.",
            "de": "Antworte auf Deutsch.",
            "fr": "Répondez en français.",
            "es": "Responde en español.",
            "uk": "Відповідай українською.",
            "zh": "用中文回答。",
            "ja": "日本語で答えてください。",
        }.get(lang, "Reply in Italian.")

        prompt = f"""You are a professional sommelier at Ristorante Gallo d'Oro in Parma, Italy.

The guest has ordered: {', '.join(request.dishes) if request.dishes else 'a typical Parma meal'}

Available wines:
{json.dumps(wines_list, ensure_ascii=False, indent=2)}

Select the TOP 3 wines that best pair with the guest's dishes. Consider:
- Classic Italian food & wine pairing rules
- The specific dishes ordered (ingredients, cooking style, region)
- Wine characteristics (grape variety, region, style)

{lang_instruction}

Respond ONLY with a valid JSON array (no markdown, no extra text):
[
  {{
    "id": <exact wine id from the list above>,
    "name": "<exact wine name from the list above>",
    "reason": "<1-2 sentence explanation why this wine pairs well with the dishes>"
  }},
  ...
]

IMPORTANT: Use ONLY the exact id and name values from the wines list above. Do not invent new wines."""

        # Вызов Anthropic API
        async with httpx.AsyncClient(timeout=30) as client:
            response = await client.post(
                "https://api.anthropic.com/v1/messages",
                headers={
                    "x-api-key": ANTHROPIC_API_KEY,
                    "anthropic-version": "2023-06-01",
                    "content-type": "application/json",
                },
                json={
                    "model": "claude-haiku-4-5-20251001",
                    "max_tokens": 500,
                    "messages": [{"role": "user", "content": prompt}],
                }
            )

        if response.status_code != 200:
            raise HTTPException(status_code=500, detail=f"AI error: {response.text}")

        ai_response = response.json()
        ai_text = ai_response["content"][0]["text"].strip()
        # Убираем markdown если AI завернул в ```json
        if ai_text.startswith("```"):
            ai_text = ai_text.split("```")[1]
            if ai_text.startswith("json"):
                ai_text = ai_text[4:]
        ai_text = ai_text.strip()

        # Парсим JSON от AI
        recommendations = json.loads(ai_text)

        # Собираем финальный ответ
        wine_map_id   = {w.id: w for w in all_wines}
        wine_map_name = {w.name.lower(): w for w in all_wines}
        result = []
        used_ids = set()

        for rec in recommendations[:3]:
            wine = None
            # Сначала по ID
            wine_id = int(rec["id"]) if rec.get("id") else None
            if wine_id:
                wine = wine_map_id.get(wine_id)
            # Потом по имени
            if not wine and rec.get("name"):
                wine = wine_map_name.get(rec["name"].lower())
            # Fallback — первое неиспользованное
            if not wine:
                for w in all_wines:
                    if w.id not in used_ids:
                        wine = w
                        break

            if not wine or wine.id in used_ids:
                continue

            used_ids.add(wine.id)
            result.append(AIWineOut(
                id            = wine.id,
                name          = wine.name,
                producer      = wine.producer,
                region        = wine.region,
                grape         = wine.grape,
                color         = wine.color,
                style         = wine.style,
                price_bottle  = float(wine.price_bottle) if wine.price_bottle else None,
                price_glass   = float(wine.price_glass) if wine.price_glass else None,
                price_quarter = float(wine.price_quarter) if wine.price_quarter else None,
                price_half    = float(wine.price_half) if wine.price_half else None,
                is_local      = wine.is_local,
                ai_reason     = rec.get("reason", ""),
            ))

        return result

    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="AI returned invalid JSON")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
