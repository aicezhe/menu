"""
Gallo d'Oro — SQLAlchemy Models
"""

from sqlalchemy import (
    Column, Integer, String, Numeric, Boolean,
    Text, ForeignKey, DateTime, UniqueConstraint
)
from sqlalchemy.orm import relationship, declarative_base
from sqlalchemy.sql import func

Base = declarative_base()


class Allergen(Base):
    __tablename__ = "allergens"

    id   = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique=True)

    dishes = relationship("Dish", secondary="dish_allergens", back_populates="allergens")

    def __repr__(self):
        return f"<Allergen {self.name}>"


class DishAllergen(Base):
    __tablename__ = "dish_allergens"

    dish_id     = Column(Integer, ForeignKey("dishes.id", ondelete="CASCADE"), primary_key=True)
    allergen_id = Column(Integer, ForeignKey("allergens.id", ondelete="CASCADE"), primary_key=True)


class DishTranslation(Base):
    __tablename__ = "dish_translations"

    id          = Column(Integer, primary_key=True)
    dish_id     = Column(Integer, ForeignKey("dishes.id", ondelete="CASCADE"), nullable=False)
    lang        = Column(String(2), nullable=False)   # it/en/ru/de/fr/es/uk/zh/ja
    name        = Column(String(200), nullable=False)
    description = Column(Text)
    adapt_note  = Column(Text)

    dish = relationship("Dish", back_populates="translations")

    __table_args__ = (UniqueConstraint("dish_id", "lang"),)

    def __repr__(self):
        return f"<Translation {self.lang}: {self.name}>"


class Dish(Base):
    __tablename__ = "dishes"

    id             = Column(Integer, primary_key=True)
    name_it        = Column(String(200), nullable=False)   # оригинал всегда итальянский
    price          = Column(Numeric(6, 2), nullable=False)
    category       = Column(String(50), nullable=False)    # antipasti/primi/secondi/contorni/dolci/bevande
    menu_type      = Column(String(20), nullable=False)    # tradizione/gourmet/base
    is_vegetarian  = Column(Boolean, default=False)
    is_vegan       = Column(Boolean, default=False)
    is_pescetarian = Column(Boolean, default=False)
    is_meat        = Column(Boolean, default=False)
    is_fish        = Column(Boolean, default=False)
    is_soup        = Column(Boolean, default=False)
    pasta_tipo     = Column(String(50))                    # burro/ragu/brodo/pesce
    can_adapt      = Column(String(50))                    # аллерген который можно убрать
    is_active      = Column(Boolean, default=True)
    created_at     = Column(DateTime, server_default=func.now())

    translations = relationship("DishTranslation", back_populates="dish", cascade="all, delete-orphan")
    allergens    = relationship("Allergen", secondary="dish_allergens", back_populates="dishes")

    def get_translation(self, lang: str) -> DishTranslation | None:
        """Возвращает перевод на нужный язык, fallback на итальянский"""
        for t in self.translations:
            if t.lang == lang:
                return t
        for t in self.translations:
            if t.lang == "it":
                return t
        return None

    def __repr__(self):
        return f"<Dish {self.name_it} €{self.price}>"
    
   
class Wine(Base):
    __tablename__ = "wines"

    id              = Column(Integer, primary_key=True)
    name            = Column(String(200), nullable=False)
    producer        = Column(String(200))
    region          = Column(String(100))
    grape           = Column(String(200))
    color           = Column(String(20), nullable=False)   # rosso/bianco/rosato/spumante
    style           = Column(String(20), nullable=False)   # fermo/frizzante/spumante
    description_it  = Column(Text)
    description_en  = Column(Text)
    description_ru  = Column(Text)
    price_bottle    = Column(Numeric(8,2))
    price_glass     = Column(Numeric(6,2))
    price_quarter   = Column(Numeric(6,2))
    price_half      = Column(Numeric(6,2))
    is_local        = Column(Boolean, default=False)   # True = Parma/Emilia
    section         = Column(String(30), default='bottle')  # mescita / casa / bottle
    is_active       = Column(Boolean, default=True)
    sort_order      = Column(Integer, default=0)

    pairings = relationship("WinePairing", back_populates="wine", cascade="all, delete-orphan")


class WinePairing(Base):
    __tablename__ = "wine_pairings"

    id          = Column(Integer, primary_key=True)
    wine_id     = Column(Integer, ForeignKey("wines.id", ondelete="CASCADE"), nullable=False)
    dish_type   = Column(String(30), nullable=False)
    score       = Column(Integer, default=1)

    wine = relationship("Wine", back_populates="pairings")

