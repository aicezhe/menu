SET client_encoding = 'UTF8';
-- ═══════════════════════════════════════════════════════
-- GALLO D'ORO — Database Schema + Seed Data
-- PostgreSQL
-- ═══════════════════════════════════════════════════════

DROP TABLE IF EXISTS dish_allergens CASCADE;
DROP TABLE IF EXISTS dish_translations CASCADE;
DROP TABLE IF EXISTS allergens CASCADE;
DROP TABLE IF EXISTS dishes CASCADE;

-- ═══════════════════════════════════════════════════════
-- ТАБЛИЦА: dishes
-- ═══════════════════════════════════════════════════════
CREATE TABLE dishes (
    id              SERIAL PRIMARY KEY,
    name_it         VARCHAR(200) NOT NULL,  -- оригинальное название всегда итальянское
    price           NUMERIC(6,2) NOT NULL,
    category        VARCHAR(50) NOT NULL,   -- antipasti / primi / secondi / contorni / dolci / bevande
    menu_type       VARCHAR(20) NOT NULL,   -- tradizione / gourmet / base
    is_vegetarian   BOOLEAN DEFAULT FALSE,
    is_vegan        BOOLEAN DEFAULT FALSE,
    is_pescetarian  BOOLEAN DEFAULT FALSE,
    is_meat         BOOLEAN DEFAULT FALSE,
    is_fish         BOOLEAN DEFAULT FALSE,
    is_soup         BOOLEAN DEFAULT FALSE,
    pasta_tipo      VARCHAR(50),            -- burro / ragu / brodo / pesce
    can_adapt       VARCHAR(50),            -- аллерген который можно убрать
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- ═══════════════════════════════════════════════════════
-- ТАБЛИЦА: dish_translations
-- ═══════════════════════════════════════════════════════
CREATE TABLE dish_translations (
    id          SERIAL PRIMARY KEY,
    dish_id     INT NOT NULL REFERENCES dishes(id) ON DELETE CASCADE,
    lang        CHAR(2) NOT NULL,   -- it / en / ru / de / fr / es / uk / zh / ja
    name        VARCHAR(200) NOT NULL,
    description TEXT,
    adapt_note  TEXT,               -- текст про адаптацию под аллергию
    UNIQUE (dish_id, lang)
);

-- ═══════════════════════════════════════════════════════
-- ТАБЛИЦА: allergens
-- ═══════════════════════════════════════════════════════
CREATE TABLE allergens (
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(50) NOT NULL UNIQUE
);

-- ═══════════════════════════════════════════════════════
-- ТАБЛИЦА: dish_allergens
-- ═══════════════════════════════════════════════════════
CREATE TABLE dish_allergens (
    dish_id     INT REFERENCES dishes(id) ON DELETE CASCADE,
    allergen_id INT REFERENCES allergens(id) ON DELETE CASCADE,
    PRIMARY KEY (dish_id, allergen_id)
);

-- ═══════════════════════════════════════════════════════
-- SEED: allergens
-- ═══════════════════════════════════════════════════════
INSERT INTO allergens (name) VALUES
    ('glutine'), ('latte'), ('uova'), ('pesce'), ('molluschi'),
    ('soia'), ('senape'), ('sedano'), ('solfiti'), ('lupini'),
    ('sesamo'), ('frutta a guscio');

-- ═══════════════════════════════════════════════════════
-- HELPER: функция для вставки переводов
-- ═══════════════════════════════════════════════════════
-- Используем WITH чтобы получить id только что вставленного блюда

-- ═══════════════════════════════════════════════════════
-- SEED: ANTIPASTI TRADIZIONE
-- ═══════════════════════════════════════════════════════

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_vegan, is_pescetarian) VALUES ('Torta Fritta', 5.00, 'antipasti', 'tradizione', TRUE, TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Torta Fritta', 'Pasta di pane fritta nello strutto, croccante fuori e morbida dentro'),
((SELECT id FROM d), 'en', 'Torta Fritta', 'Bread dough fried in lard, crispy outside and soft inside'),
((SELECT id FROM d), 'ru', 'Торта Фритта', 'Жареное тесто на смальце, хрустящее снаружи и мягкое внутри'),
((SELECT id FROM d), 'de', 'Torta Fritta', 'In Schmalz frittierter Brotteig, außen knusprig und innen weich'),
((SELECT id FROM d), 'fr', 'Torta Fritta', 'Pâte de pain frite dans le saindoux, croustillante dehors et moelleuse dedans'),
((SELECT id FROM d), 'es', 'Torta Fritta', 'Masa de pan frita en manteca, crujiente por fuera y suave por dentro'),
((SELECT id FROM d), 'uk', 'Торта Фрітта', 'Смажене тісто на смальці, хрустке зовні та м''яке всередині'),
((SELECT id FROM d), 'zh', '炸面团', '用猪油炸的面团，外脆内软'),
((SELECT id FROM d), 'ja', 'トルタ・フリッタ', 'ラードで揚げたパン生地、外はカリッと中はふんわり');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_vegan, is_pescetarian) VALUES ('Parmigiano Reggiano di Vacca Bruna', 10.50, 'antipasti', 'tradizione', TRUE, FALSE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Parmigiano Reggiano di Vacca Bruna', 'Stagionato minimo 24 mesi, servito con Aceto Balsamico di Modena IGP'),
((SELECT id FROM d), 'en', 'Parmigiano Reggiano di Vacca Bruna', 'Aged minimum 24 months, served with Modena Balsamic Vinegar IGP'),
((SELECT id FROM d), 'ru', 'Пармиджано Реджано из молока коричневой коровы', 'Выдержан минимум 24 месяца, подаётся с бальзамическим уксусом из Модены IGP'),
((SELECT id FROM d), 'de', 'Parmigiano Reggiano di Vacca Bruna', 'Mindestens 24 Monate gereift, serviert mit Balsamico-Essig aus Modena IGP'),
((SELECT id FROM d), 'fr', 'Parmigiano Reggiano di Vacca Bruna', 'Affiné minimum 24 mois, servi avec Vinaigre Balsamique de Modène IGP'),
((SELECT id FROM d), 'es', 'Parmigiano Reggiano di Vacca Bruna', 'Madurado mínimo 24 meses, servido con Vinagre Balsámico de Módena IGP'),
((SELECT id FROM d), 'uk', 'Пармджано Реджано з молока коричневої корови', 'Витримка мінімум 24 місяці, подається з бальзамічним оцтом з Модени IGP'),
((SELECT id FROM d), 'zh', '帕尔马干酪', '最少熟成24个月，配摩德纳IGP香醋'),
((SELECT id FROM d), 'ja', 'パルミジャーノ・レッジャーノ', '最低24ヶ月熟成、モデナIGPバルサミコ酢を添えて');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_vegan, is_pescetarian) VALUES ('Giardiniera', 6.50, 'antipasti', 'tradizione', TRUE, TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Giardiniera', 'Verdure di stagione in agrodolce, preparate artigianalmente'),
((SELECT id FROM d), 'en', 'Giardiniera', 'Seasonal vegetables in sweet and sour, artisanally prepared'),
((SELECT id FROM d), 'ru', 'Джардиньера', 'Сезонные овощи в кисло-сладком маринаде, приготовленные вручную'),
((SELECT id FROM d), 'de', 'Giardiniera', 'Saisonales Gemüse süß-sauer, handwerklich zubereitet'),
((SELECT id FROM d), 'fr', 'Giardiniera', 'Légumes de saison en aigre-doux, préparés artisanalement'),
((SELECT id FROM d), 'es', 'Giardiniera', 'Verduras de temporada en agridulce, preparadas artesanalmente'),
((SELECT id FROM d), 'uk', 'Джардіньєра', 'Сезонні овочі в кисло-солодкому маринаді, приготовані вручну'),
((SELECT id FROM d), 'zh', '意式腌菜', '手工制作的季节性酸甜腌菜'),
((SELECT id FROM d), 'ja', 'ジャルディニエーラ', '手作りの季節の野菜の甘酢漬け');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_vegan, is_pescetarian) VALUES ('Gorgonzola', 9.00, 'antipasti', 'tradizione', TRUE, FALSE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Gorgonzola', 'Formaggio erborinato cremoso, servito con pane tostato'),
((SELECT id FROM d), 'en', 'Gorgonzola', 'Creamy blue cheese, served with toasted bread'),
((SELECT id FROM d), 'ru', 'Горгонзола', 'Сливочный сыр с плесенью, подаётся с поджаренным хлебом'),
((SELECT id FROM d), 'de', 'Gorgonzola', 'Cremiger Blauschimmelkäse, mit geröstetem Brot serviert'),
((SELECT id FROM d), 'fr', 'Gorgonzola', 'Fromage persillé crémeux, servi avec pain grillé'),
((SELECT id FROM d), 'es', 'Gorgonzola', 'Queso azul cremoso, servido con pan tostado'),
((SELECT id FROM d), 'uk', 'Горгонзола', 'Кремовий блакитний сир, подається з підсмаженим хлібом'),
((SELECT id FROM d), 'zh', '戈尔根朱勒奶酪', '奶油蓝纹奶酪，配烤面包'),
((SELECT id FROM d), 'ja', 'ゴルゴンゾーラ', 'クリーミーなブルーチーズ、トーストと一緒に');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Tagliere Goloso', 13.00, 'antipasti', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Tagliere Goloso', 'Spallaccio, Guanciale aromatizzato, Lardo'),
((SELECT id FROM d), 'en', 'Tagliere Goloso', 'Spallaccio, Seasoned Guanciale, Lardo'),
((SELECT id FROM d), 'ru', 'Тальере Голозо', 'Спаллаччо, ароматизированный гуанчале, лардо'),
((SELECT id FROM d), 'de', 'Tagliere Goloso', 'Spallaccio, Aromatisierter Guanciale, Lardo'),
((SELECT id FROM d), 'fr', 'Tagliere Goloso', 'Spallaccio, Guanciale aromatisé, Lardo'),
((SELECT id FROM d), 'es', 'Tagliere Goloso', 'Spallaccio, Guanciale aromatizado, Lardo'),
((SELECT id FROM d), 'uk', 'Тальєре Голозо', 'Спаллаччо, ароматизований гуанчале, лардо'),
((SELECT id FROM d), 'zh', '美味拼盘', 'Spallaccio、调味Guanciale、Lardo'),
((SELECT id FROM d), 'ja', 'タリエーレ・ゴローゾ', 'スパッラッチョ、アロマティック・グアンチャーレ、ラルド');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Tagliere dei Preziosi', 15.00, 'antipasti', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Tagliere dei Preziosi', 'Culatta, Prosciutto di Parma, Coppa, Strolghino, Salame di Felino'),
((SELECT id FROM d), 'en', 'Tagliere dei Preziosi', 'Culatta, Parma Ham, Coppa, Strolghino, Salame di Felino'),
((SELECT id FROM d), 'ru', 'Тальере деи Прецьози', 'Кулатта, пармская ветчина, коппа, стролгино, саламе ди Фелино'),
((SELECT id FROM d), 'de', 'Tagliere dei Preziosi', 'Culatta, Parmaschinken, Coppa, Strolghino, Salame di Felino'),
((SELECT id FROM d), 'fr', 'Tagliere dei Preziosi', 'Culatta, Jambon de Parme, Coppa, Strolghino, Salame di Felino'),
((SELECT id FROM d), 'es', 'Tagliere dei Preziosi', 'Culatta, Jamón de Parma, Coppa, Strolghino, Salame di Felino'),
((SELECT id FROM d), 'uk', 'Тальєре деі Прецьозі', 'Кулатта, пармська шинка, коппа, стролгіно, саламе ді Феліно'),
((SELECT id FROM d), 'zh', '珍品拼盘', 'Culatta、帕尔马火腿、Coppa、Strolghino、Salame di Felino'),
((SELECT id FROM d), 'ja', 'タリエーレ・デイ・プレツィオージ', 'クラッタ、パルマハム、コッパ、ストロルギーノ、サラメ・ディ・フェリーノ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Tagliere Salumi del Contadino', 13.00, 'antipasti', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Tagliere Salumi del Contadino', 'Salame di Felino, Cicciolata, Ciccioli, Pancetta, Spallacotta di San Secondo'),
((SELECT id FROM d), 'en', 'Tagliere Salumi del Contadino', 'Salame di Felino, Cicciolata, Ciccioli, Pancetta, Spallacotta di San Secondo'),
((SELECT id FROM d), 'ru', 'Тальере Салуми дель Контадино', 'Саламе ди Фелино, чиччолата, чиччоли, панчетта, спаллакотта ди Сан Секондо'),
((SELECT id FROM d), 'de', 'Tagliere Salumi del Contadino', 'Salame di Felino, Cicciolata, Ciccioli, Pancetta, Spallacotta di San Secondo'),
((SELECT id FROM d), 'fr', 'Tagliere Salumi del Contadino', 'Salame di Felino, Cicciolata, Ciccioli, Pancetta, Spallacotta di San Secondo'),
((SELECT id FROM d), 'es', 'Tagliere Salumi del Contadino', 'Salame di Felino, Cicciolata, Ciccioli, Pancetta, Spallacotta di San Secondo'),
((SELECT id FROM d), 'uk', 'Тальєре Салумі дель Контадіно', 'Саламе ді Феліно, чиччолата, чиччолі, панчетта, спаллакотта ді Сан Секондо'),
((SELECT id FROM d), 'zh', '农家拼盘', 'Salame di Felino、Cicciolata、Ciccioli、Pancetta、Spallacotta di San Secondo'),
((SELECT id FROM d), 'ja', 'タリエーレ・サルミ・デル・コンタディーノ', 'サラメ・ディ・フェリーノ、チッチョラータ、チッチョリ、パンチェッタ、スパッラコッタ・ディ・サン・セコンド');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian) VALUES ('Degustazione di Formaggi Misti', 18.00, 'antipasti', 'tradizione', TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Degustazione di Formaggi Misti', 'Selezione di formaggi di latte di bufala, vaccino e ovino con salse'),
((SELECT id FROM d), 'en', 'Mixed Cheese Tasting', 'Selection of buffalo, cow and sheep milk cheeses with sauces'),
((SELECT id FROM d), 'ru', 'Дегустация смешанных сыров', 'Подбор сыров из молока буйволицы, коровьего и овечьего с соусами'),
((SELECT id FROM d), 'de', 'Gemischte Käseverkostung', 'Auswahl an Käse aus Büffel-, Kuh- und Schafmilch mit Saucen'),
((SELECT id FROM d), 'fr', 'Dégustation de fromages mixtes', 'Sélection de fromages de lait de bufflonne, vache et brebis avec sauces'),
((SELECT id FROM d), 'es', 'Degustación de quesos mixtos', 'Selección de quesos de leche de búfala, vaca y oveja con salsas'),
((SELECT id FROM d), 'uk', 'Дегустація змішаних сирів', 'Підбір сирів з молока буйволиці, коров''ячого та овечого з соусами'),
((SELECT id FROM d), 'zh', '混合奶酪品鉴', '水牛奶、牛奶和羊奶奶酪精选配酱汁'),
((SELECT id FROM d), 'ja', 'ミックスチーズテイスティング', '水牛、牛、羊のチーズの盛り合わせとソース');

-- ═══════════════════════════════════════════════════════
-- SEED: ANTIPASTI GOURMET
-- ═══════════════════════════════════════════════════════

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Battuta di Capriolo', 17.00, 'antipasti', 'gourmet', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Battuta di Capriolo', 'Topinambur in tre consistenze, nocciole tostate e cipolla rossa'),
((SELECT id FROM d), 'en', 'Venison Tartare', 'Jerusalem artichoke in three textures, toasted hazelnuts and red onion'),
((SELECT id FROM d), 'ru', 'Тартар из косули', 'Топинамбур в трёх текстурах, жареный фундук и красный лук'),
((SELECT id FROM d), 'de', 'Rehrücken-Tatar', 'Topinambur in drei Konsistenzen, geröstete Haselnüsse und rote Zwiebel'),
((SELECT id FROM d), 'fr', 'Tartare de chevreuil', 'Topinambour en trois textures, noisettes grillées et oignon rouge'),
((SELECT id FROM d), 'es', 'Tatár de corzo', 'Topinambo en tres texturas, avellanas tostadas y cebolla roja'),
((SELECT id FROM d), 'uk', 'Тартар з косулі', 'Топінамбур у трьох текстурах, смажений фундук та червона цибуля'),
((SELECT id FROM d), 'zh', '鹿肉鞑靼', '三种质地的菊芋，烤榛子和红洋葱'),
((SELECT id FROM d), 'ja', 'ベニソン・タルタル', '三つの食感のキクイモ、ローストヘーゼルナッツと赤玉ねぎ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian) VALUES ('Uovo Fritto alla Scozzese', 16.00, 'antipasti', 'gourmet', TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Uovo Fritto alla Scozzese', 'Nido di salicornia e fonduta di parmigiano'),
((SELECT id FROM d), 'en', 'Scottish Fried Egg', 'Salicornia nest and parmesan fondue'),
((SELECT id FROM d), 'ru', 'Яйцо по-шотландски', 'Гнездо из салькорнии и фондю из пармезана'),
((SELECT id FROM d), 'de', 'Schottisches Spiegelei', 'Salicornia-Nest und Parmesanfondue'),
((SELECT id FROM d), 'fr', 'Oeuf frit à l''écossaise', 'Nid de salicorne et fondue de parmesan'),
((SELECT id FROM d), 'es', 'Huevo frito a la escocesa', 'Nido de salicornia y fondue de parmesano'),
((SELECT id FROM d), 'uk', 'Яйце по-шотландськи', 'Гніздо з салькорнії та фондю з пармезану'),
((SELECT id FROM d), 'zh', '苏格兰炸蛋', '海蓬子巢和帕尔马干酪火锅'),
((SELECT id FROM d), 'ja', 'スコッティッシュ・フライドエッグ', 'サリコルニアの巣とパルメザンフォンデュ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian) VALUES ('Melanzana Gallo D''Oro', 15.00, 'antipasti', 'gourmet', TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Melanzana Gallo D''Oro', 'Specialità della casa con melanzane, latte e frutta a guscio'),
((SELECT id FROM d), 'en', 'Gallo D''Oro Aubergine', 'House speciality with aubergine, milk and nuts'),
((SELECT id FROM d), 'ru', 'Баклажан Галло д''Оро', 'Фирменное блюдо с баклажанами, молоком и орехами'),
((SELECT id FROM d), 'de', 'Gallo D''Oro Aubergine', 'Hausspezialität mit Auberginen, Milch und Nüssen'),
((SELECT id FROM d), 'fr', 'Aubergine Gallo D''Oro', 'Spécialité maison aux aubergines, lait et fruits secs'),
((SELECT id FROM d), 'es', 'Berenjena Gallo D''Oro', 'Especialidad de la casa con berenjenas, leche y frutos secos'),
((SELECT id FROM d), 'uk', 'Баклажан Галло д''Оро', 'Фірмова страва з баклажанами, молоком та горіхами'),
((SELECT id FROM d), 'zh', '金鸡茄子', '茄子、牛奶和坚果的特色菜'),
((SELECT id FROM d), 'ja', 'ガッロ・ドーロ・メランザーナ', 'ナス、ミルク、ナッツを使った看板料理');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_pescetarian, is_fish) VALUES ('Cozze al Vapore', 17.00, 'antipasti', 'gourmet', TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Cozze al Vapore', 'Crema di fagioli cannellini, pomodorini confit e corallo al nero di seppia'),
((SELECT id FROM d), 'en', 'Steamed Mussels', 'Cannellini bean cream, confit cherry tomatoes and squid ink coral'),
((SELECT id FROM d), 'ru', 'Мидии на пару', 'Крем из бобов каннеллини, конфи из помидоров черри и корал из чернил каракатицы'),
((SELECT id FROM d), 'de', 'Gedämpfte Muscheln', 'Cannellini-Bohnencreme, konfierte Kirschtomaten und Tintenfischkoralle'),
((SELECT id FROM d), 'fr', 'Moules à la vapeur', 'Crème de haricots cannellini, tomates cerises confites et corail à l''encre de seiche'),
((SELECT id FROM d), 'es', 'Mejillones al vapor', 'Crema de alubias cannellini, tomates cherry confitados y coral de tinta de calamar'),
((SELECT id FROM d), 'uk', 'Мідії на парі', 'Крем із квасолі каннелліні, конфі з помідорів черрі та корал із чорнила каракатиці'),
((SELECT id FROM d), 'zh', '清蒸贻贝', '白芸豆奶油、糖渍樱桃番茄和墨鱼汁珊瑚'),
((SELECT id FROM d), 'ja', '蒸しムール貝', 'カネッリーニ豆のクリーム、セミドライトマト、イカ墨のコーラル');

-- ═══════════════════════════════════════════════════════
-- SEED: PRIMI TRADIZIONE
-- ═══════════════════════════════════════════════════════

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian, pasta_tipo, can_adapt) VALUES ('Tortelli di Erbetta', 11.50, 'primi', 'tradizione', TRUE, TRUE, 'burro', 'latte') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description, adapt_note) VALUES
((SELECT id FROM d), 'it', 'Tortelli di Erbetta', 'Con burro fuso e Parmigiano Reggiano', 'Può essere preparato senza latte su richiesta'),
((SELECT id FROM d), 'en', 'Tortelli di Erbetta', 'With melted butter and Parmigiano Reggiano', 'Can be prepared without milk on request'),
((SELECT id FROM d), 'ru', 'Тортелли с зеленью', 'С топлёным маслом и Пармиджано Реджано', 'Можно приготовить без молока по запросу'),
((SELECT id FROM d), 'de', 'Tortelli di Erbetta', 'Mit Butter und Parmigiano Reggiano', 'Kann auf Wunsch ohne Milch zubereitet werden'),
((SELECT id FROM d), 'fr', 'Tortelli di Erbetta', 'Au beurre fondu et Parmigiano Reggiano', 'Peut être préparé sans lait sur demande'),
((SELECT id FROM d), 'es', 'Tortelli di Erbetta', 'Con mantequilla derretida y Parmigiano Reggiano', 'Se puede preparar sin leche a petición'),
((SELECT id FROM d), 'uk', 'Тортеллі з зеленню', 'З топленим маслом та Пармджано Реджано', 'Можна приготувати без молока на прохання'),
((SELECT id FROM d), 'zh', '香草馅饺子', '配融化黄油和帕尔马干酪', '可应要求不加牛奶'),
((SELECT id FROM d), 'ja', 'トルテッリ・ディ・エルベッタ', '溶かしバターとパルミジャーノ・レッジャーノ', 'ご要望によりミルクなしで調理可能');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian, pasta_tipo, can_adapt) VALUES ('Tortelli di Zucca', 11.50, 'primi', 'tradizione', TRUE, TRUE, 'burro', 'latte') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description, adapt_note) VALUES
((SELECT id FROM d), 'it', 'Tortelli di Zucca', 'Con burro fuso e Parmigiano Reggiano', 'Può essere preparato senza latte su richiesta'),
((SELECT id FROM d), 'en', 'Tortelli di Zucca', 'With melted butter and Parmigiano Reggiano', 'Can be prepared without milk on request'),
((SELECT id FROM d), 'ru', 'Тортелли с тыквой', 'С топлёным маслом и Пармиджано Реджано', 'Можно приготовить без молока по запросу'),
((SELECT id FROM d), 'de', 'Tortelli di Zucca', 'Mit Butter und Parmigiano Reggiano', 'Kann auf Wunsch ohne Milch zubereitet werden'),
((SELECT id FROM d), 'fr', 'Tortelli di Zucca', 'Au beurre fondu et Parmigiano Reggiano', 'Peut être préparé sans lait sur demande'),
((SELECT id FROM d), 'es', 'Tortelli di Zucca', 'Con mantequilla derretida y Parmigiano Reggiano', 'Se puede preparar sin leche a petición'),
((SELECT id FROM d), 'uk', 'Тортеллі з гарбузом', 'З топленим маслом та Пармджано Реджано', 'Можна приготувати без молока на прохання'),
((SELECT id FROM d), 'zh', '南瓜馅饺子', '配融化黄油和帕尔马干酪', '可应要求不加牛奶'),
((SELECT id FROM d), 'ja', 'トルテッリ・ディ・ズッカ', '溶かしバターとパルミジャーノ・レッジャーノ', 'ご要望によりミルクなしで調理可能');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian, pasta_tipo, can_adapt) VALUES ('Tortelli di Patate', 11.50, 'primi', 'tradizione', TRUE, TRUE, 'burro', 'latte') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description, adapt_note) VALUES
((SELECT id FROM d), 'it', 'Tortelli di Patate', 'Con burro fuso e Parmigiano Reggiano', 'Può essere preparato senza latte su richiesta'),
((SELECT id FROM d), 'en', 'Tortelli di Patate', 'With melted butter and Parmigiano Reggiano', 'Can be prepared without milk on request'),
((SELECT id FROM d), 'ru', 'Тортелли с картофелем', 'С топлёным маслом и Пармиджано Реджано', 'Можно приготовить без молока по запросу'),
((SELECT id FROM d), 'de', 'Tortelli di Patate', 'Mit Butter und Parmigiano Reggiano', 'Kann auf Wunsch ohne Milch zubereitet werden'),
((SELECT id FROM d), 'fr', 'Tortelli di Patate', 'Au beurre fondu et Parmigiano Reggiano', 'Peut être préparé sans lait sur demande'),
((SELECT id FROM d), 'es', 'Tortelli di Patate', 'Con mantequilla derretida y Parmigiano Reggiano', 'Se puede preparar sin leche a petición'),
((SELECT id FROM d), 'uk', 'Тортеллі з картоплею', 'З топленим маслом та Пармджано Реджано', 'Можна приготувати без молока на прохання'),
((SELECT id FROM d), 'zh', '土豆馅饺子', '配融化黄油和帕尔马干酪', '可应要求不加牛奶'),
((SELECT id FROM d), 'ja', 'トルテッリ・ディ・パタテ', '溶かしバターとパルミジャーノ・レッジャーノ', 'ご要望によりミルクなしで調理可能');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian, pasta_tipo, can_adapt) VALUES ('Tris di Tortelli', 13.50, 'primi', 'tradizione', TRUE, TRUE, 'burro', 'latte') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description, adapt_note) VALUES
((SELECT id FROM d), 'it', 'Tris di Tortelli', 'Erbetta, Zucca e Patate con burro fuso e Parmigiano Reggiano', 'Può essere preparato senza latte su richiesta'),
((SELECT id FROM d), 'en', 'Tris di Tortelli', 'Erbetta, Zucca and Patate with melted butter and Parmigiano Reggiano', 'Can be prepared without milk on request'),
((SELECT id FROM d), 'ru', 'Трис ди Тортелли', 'Ербетта, тыква и картофель с топлёным маслом и Пармиджано Реджано', 'Можно приготовить без молока по запросу'),
((SELECT id FROM d), 'de', 'Tris di Tortelli', 'Erbetta, Zucca und Patate mit Butter und Parmigiano Reggiano', 'Kann auf Wunsch ohne Milch zubereitet werden'),
((SELECT id FROM d), 'fr', 'Tris di Tortelli', 'Erbetta, Zucca et Patate au beurre fondu et Parmigiano Reggiano', 'Peut être préparé sans lait sur demande'),
((SELECT id FROM d), 'es', 'Tris di Tortelli', 'Erbetta, Zucca y Patate con mantequilla derretida y Parmigiano Reggiano', 'Se puede preparar sin leche a petición'),
((SELECT id FROM d), 'uk', 'Тріс ді Тортеллі', 'Ербетта, гарбуз і картопля з топленим маслом та Пармджано Реджано', 'Можна приготувати без молока на прохання'),
((SELECT id FROM d), 'zh', '三味饺子', '香草、南瓜和土豆馅，配融化黄油和帕尔马干酪', '可应要求不加牛奶'),
((SELECT id FROM d), 'ja', 'トリス・ディ・トルテッリ', 'エルベッタ、ズッカ、パタテ、溶かしバターとパルミジャーノ・レッジャーノ', 'ご要望によりミルクなしで調理可能');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat, pasta_tipo) VALUES ('Cappelletti al Ragù di Strolghino', 14.50, 'primi', 'tradizione', TRUE, 'ragu') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Cappelletti al Ragù di Strolghino', 'Pasta fresca ripiena con ragù di strolghino tipico parmense'),
((SELECT id FROM d), 'en', 'Cappelletti with Strolghino Ragù', 'Fresh pasta stuffed with typical Parma strolghino ragù'),
((SELECT id FROM d), 'ru', 'Каппеллетти с рагу из стролгино', 'Свежая паста с рагу из стролгино'),
((SELECT id FROM d), 'de', 'Cappelletti mit Strolghino-Ragù', 'Frische gefüllte Pasta mit typischem Parmenser Strolghino-Ragù'),
((SELECT id FROM d), 'fr', 'Cappelletti au ragù de strolghino', 'Pâtes fraîches farcies au ragù de strolghino typique parmesane'),
((SELECT id FROM d), 'es', 'Cappelletti al ragù de strolghino', 'Pasta fresca rellena con ragù de strolghino típico parmesano'),
((SELECT id FROM d), 'uk', 'Каппелетті з рагу зі стролгіно', 'Свіжа паста з рагу зі стролгіно'),
((SELECT id FROM d), 'zh', '肉酱帽子饺', '新鲜意大利饺子配典型帕尔马Strolghino肉酱'),
((SELECT id FROM d), 'ja', 'カッペッレッティ・アル・ラグー・ディ・ストロルギーノ', '典型的なパルマのストロルギーノのラグーを詰めた新鮮なパスタ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat, pasta_tipo, is_soup) VALUES ('Cappelletti in Brodo', 13.50, 'primi', 'tradizione', TRUE, 'brodo', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Cappelletti in Brodo', 'In brodo di cappone, manzo e gallina'),
((SELECT id FROM d), 'en', 'Cappelletti in Broth', 'In capon, beef and hen broth'),
((SELECT id FROM d), 'ru', 'Каппеллетти в бульоне', 'В бульоне из каплуна, говядины и курицы'),
((SELECT id FROM d), 'de', 'Cappelletti in Brühe', 'In Kapaun-, Rind- und Hühnerbrühe'),
((SELECT id FROM d), 'fr', 'Cappelletti en bouillon', 'Dans bouillon de chapon, bœuf et poule'),
((SELECT id FROM d), 'es', 'Cappelletti en caldo', 'En caldo de capón, ternera y gallina'),
((SELECT id FROM d), 'uk', 'Каппелетті в бульйоні', 'У бульйоні з каплуна, яловичини та курки'),
((SELECT id FROM d), 'zh', '肉汤帽子饺', '阉鸡、牛肉和母鸡高汤'),
((SELECT id FROM d), 'ja', 'カッペッレッティ・イン・ブロード', '去勢鶏、牛肉、雌鶏のブロードで');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat, pasta_tipo) VALUES ('Pappardelle al Ragù di Strolghino', 12.50, 'primi', 'tradizione', TRUE, 'ragu') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Pappardelle al Ragù di Strolghino', 'Pasta larga all''uovo con ragù di strolghino'),
((SELECT id FROM d), 'en', 'Pappardelle with Strolghino Ragù', 'Wide egg pasta with strolghino ragù'),
((SELECT id FROM d), 'ru', 'Паппарделле с рагу из стролгино', 'Широкая яичная паста с рагу из стролгино'),
((SELECT id FROM d), 'de', 'Pappardelle mit Strolghino-Ragù', 'Breite Eierpasta mit Strolghino-Ragù'),
((SELECT id FROM d), 'fr', 'Pappardelle au ragù de strolghino', 'Large pâte aux œufs avec ragù de strolghino'),
((SELECT id FROM d), 'es', 'Pappardelle al ragù de strolghino', 'Pasta ancha al huevo con ragù de strolghino'),
((SELECT id FROM d), 'uk', 'Паппарделле з рагу зі стролгіно', 'Широка яєчна паста з рагу зі стролгіно'),
((SELECT id FROM d), 'zh', '宽面配肉酱', '宽鸡蛋面配Strolghino肉酱'),
((SELECT id FROM d), 'ja', 'パッパルデッレ・アル・ラグー・ディ・ストロルギーノ', 'ストロルギーノのラグーと幅広卵パスタ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat, pasta_tipo) VALUES ('Gnocchi al Ragù di Salumi', 12.00, 'primi', 'tradizione', TRUE, 'ragu') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Gnocchi al Ragù di Salumi', 'Gnocchi di patate con ragù di salumi tipici parmigiani'),
((SELECT id FROM d), 'en', 'Gnocchi with Cured Meat Ragù', 'Potato gnocchi with typical Parma cured meat ragù'),
((SELECT id FROM d), 'ru', 'Ньокки с рагу из деликатесов', 'Картофельные ньокки с рагу из пармских деликатесов'),
((SELECT id FROM d), 'de', 'Gnocchi mit Salami-Ragù', 'Kartoffelgnocchi mit Ragù aus typischen Parmenser Wurstwaren'),
((SELECT id FROM d), 'fr', 'Gnocchi au ragù de charcuteries', 'Gnocchis de pomme de terre avec ragù de charcuteries typiques parmesanes'),
((SELECT id FROM d), 'es', 'Gnocchi al ragù de embutidos', 'Ñoquis de patata con ragù de embutidos típicos parmesanos'),
((SELECT id FROM d), 'uk', 'Ньокі з рагу з делікатесів', 'Картопляні ньокі з рагу з пармських м''ясних делікатесів'),
((SELECT id FROM d), 'zh', '土豆疙瘩配肉酱', '土豆面疙瘩配典型帕尔马腌制肉类肉酱'),
((SELECT id FROM d), 'ja', 'ニョッキ・アル・ラグー・ディ・サルミ', '典型的なパルマのサルミのラグーとジャガイモニョッキ');

-- ═══════════════════════════════════════════════════════
-- SEED: PRIMI GOURMET
-- ═══════════════════════════════════════════════════════

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat, pasta_tipo) VALUES ('Risotto alla Malvasia Monte delle Vigne', 19.00, 'primi', 'gourmet', TRUE, 'ragu') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Risotto alla Malvasia Monte delle Vigne', '"Riso Acquerello", culatta e tartufo nero'),
((SELECT id FROM d), 'en', 'Risotto with Malvasia', '"Acquerello Rice", culatta and black truffle'),
((SELECT id FROM d), 'ru', 'Ризотто с Мальвазией', '"Рис Акварелло", кулатта и чёрный трюфель'),
((SELECT id FROM d), 'de', 'Risotto mit Malvasia', '"Acquerello-Reis", Culatta und schwarzer Trüffel'),
((SELECT id FROM d), 'fr', 'Risotto à la Malvasia', '"Riz Acquerello", culatta et truffe noire'),
((SELECT id FROM d), 'es', 'Risotto con Malvasia', '"Arroz Acquerello", culatta y trufa negra'),
((SELECT id FROM d), 'uk', 'Різотто з Мальвазією', '"Рис Акварелло", кулатта і чорний трюфель'),
((SELECT id FROM d), 'zh', '马尔维萨烩饭', '"阿夸雷洛大米"、Culatta和黑松露'),
((SELECT id FROM d), 'ja', 'リゾット・アッラ・マルヴァジア', '"アクアレッロ米"、クラッタと黒トリュフ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_vegetarian, is_pescetarian, pasta_tipo) VALUES ('Ravioli alla Crema di Parmigiano e Tartufo Nero', 19.00, 'primi', 'gourmet', TRUE, TRUE, 'burro') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Ravioli alla Crema di Parmigiano e Tartufo Nero', 'Pasta fresca con crema di parmigiano e tartufo nero'),
((SELECT id FROM d), 'en', 'Ravioli with Parmesan Cream and Black Truffle', 'Fresh pasta with parmesan cream and black truffle'),
((SELECT id FROM d), 'ru', 'Равиоли с кремом из пармезана и чёрным трюфелем', 'Свежая паста с кремом из пармезана и чёрным трюфелем'),
((SELECT id FROM d), 'de', 'Ravioli mit Parmesancreme und schwarzem Trüffel', 'Frische Pasta mit Parmesancreme und schwarzem Trüffel'),
((SELECT id FROM d), 'fr', 'Ravioli à la crème de parmesan et truffe noire', 'Pâtes fraîches à la crème de parmesan et truffe noire'),
((SELECT id FROM d), 'es', 'Ravioli con crema de parmesano y trufa negra', 'Pasta fresca con crema de parmesano y trufa negra'),
((SELECT id FROM d), 'uk', 'Равіолі з кремом із пармезану та чорним трюфелем', 'Свіжа паста з кремом із пармезану та чорним трюфелем'),
((SELECT id FROM d), 'zh', '帕尔马干酪奶油黑松露意大利饺', '帕尔马干酪奶油和黑松露新鲜意大利饺子'),
((SELECT id FROM d), 'ja', 'ラビオリ・アッラ・クレーマ・ディ・パルミジャーノ', 'パルメザンクリームと黒トリュフの新鮮なパスタ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_pescetarian, is_fish, pasta_tipo) VALUES ('Gnocchi alle Vongole Veraci e Carciofi', 18.00, 'primi', 'gourmet', TRUE, TRUE, 'pesce') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Gnocchi alle Vongole Veraci e Carciofi', 'Gnocchi fatti a mano con vongole veraci e carciofi'),
((SELECT id FROM d), 'en', 'Gnocchi with Clams and Artichokes', 'Handmade gnocchi with clams and seasonal artichokes'),
((SELECT id FROM d), 'ru', 'Ньокки с венерками и артишоками', 'Ручные ньокки с венерками и сезонными артишоками'),
((SELECT id FROM d), 'de', 'Gnocchi mit Venusmuscheln und Artischocken', 'Handgemachte Gnocchi mit Venusmuscheln und Artischocken'),
((SELECT id FROM d), 'fr', 'Gnocchi aux palourdes et artichauts', 'Gnocchis faits main aux palourdes et artichauts de saison'),
((SELECT id FROM d), 'es', 'Gnocchi con almejas y alcachofas', 'Ñoquis artesanales con almejas y alcachofas de temporada'),
((SELECT id FROM d), 'uk', 'Ньокі з венерками та артишоками', 'Ручні ньокі з венерками та сезонними артишоками'),
((SELECT id FROM d), 'zh', '蛤蜊朝鲜蓟疙瘩', '手工面疙瘩配蛤蜊和时令朝鲜蓟'),
((SELECT id FROM d), 'ja', 'ニョッキ・アッレ・ヴォンゴレ・ヴェラーチ', 'アサリと旬のアーティチョークの手作りニョッキ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_pescetarian, is_fish, pasta_tipo) VALUES ('Spaghetto alla Chitarra', 18.00, 'primi', 'gourmet', TRUE, TRUE, 'pesce') RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Spaghetto alla Chitarra', 'Aglio nero, tarallo e alici Rizzoli in salsa piccante'),
((SELECT id FROM d), 'en', 'Spaghetto alla Chitarra', 'Black garlic, tarallo and Rizzoli anchovies in spicy sauce'),
((SELECT id FROM d), 'ru', 'Спагетти алла Читарра', 'Чёрный чеснок, тарало и анчоусы Риццоли в остром соусе'),
((SELECT id FROM d), 'de', 'Spaghetto alla Chitarra', 'Schwarzer Knoblauch, Tarallo und Rizzoli-Sardellen in scharfer Sauce'),
((SELECT id FROM d), 'fr', 'Spaghetto alla Chitarra', 'Ail noir, tarallo et anchois Rizzoli en sauce piquante'),
((SELECT id FROM d), 'es', 'Spaghetto alla Chitarra', 'Ajo negro, tarallo y anchoas Rizzoli en salsa picante'),
((SELECT id FROM d), 'uk', 'Спагеті алла Читарра', 'Чорний часник, тарало та анчоуси Ріццолі в гострому соусі'),
((SELECT id FROM d), 'zh', '吉他面', '黑蒜、Tarallo和Rizzoli凤尾鱼配辣酱'),
((SELECT id FROM d), 'ja', 'スパゲッティ・アッラ・キターラ', '黒ニンニク、タラッロ、リッツォリのアンチョビのスパイシーソース');

-- ═══════════════════════════════════════════════════════
-- SEED: SECONDI TRADIZIONE
-- ═══════════════════════════════════════════════════════

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Punta di Vitello Ripiena', 15.00, 'secondi', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Punta di Vitello Ripiena', 'Con contorno di patate arrosto'),
((SELECT id FROM d), 'en', 'Stuffed Veal Brisket', 'With roast potato side dish'),
((SELECT id FROM d), 'ru', 'Фаршированная грудинка телёнка', 'С жареным картофелем'),
((SELECT id FROM d), 'de', 'Gefüllte Kalbsbrust', 'Mit Bratkartoffeln als Beilage'),
((SELECT id FROM d), 'fr', 'Pointe de veau farcie', 'Avec garniture de pommes de terre rôties'),
((SELECT id FROM d), 'es', 'Punta de ternera rellena', 'Con guarnición de patatas asadas'),
((SELECT id FROM d), 'uk', 'Фарширована грудинка телятини', 'З жареною картоплею'),
((SELECT id FROM d), 'zh', '酿小牛胸肉', '配烤土豆'),
((SELECT id FROM d), 'ja', 'プンタ・ディ・ヴィテッロ・リピエナ', 'ロースト・ポテトのサイドディッシュ付き');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Pesto di Cavallo', 13.00, 'secondi', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Pesto di Cavallo', 'Con salsa al miele, senape e cucunci'),
((SELECT id FROM d), 'en', 'Horse Pesto', 'With honey, mustard and caper berry sauce'),
((SELECT id FROM d), 'ru', 'Песто из конины', 'С соусом из мёда, горчицы и каперсов'),
((SELECT id FROM d), 'de', 'Pferde-Pesto', 'Mit Honig-Senf-Kapern-Sauce'),
((SELECT id FROM d), 'fr', 'Pesto de cheval', 'Avec sauce miel, moutarde et câpres'),
((SELECT id FROM d), 'es', 'Pesto de caballo', 'Con salsa de miel, mostaza y alcaparras'),
((SELECT id FROM d), 'uk', 'Песто з конини', 'З соусом із меду, гірчиці та каперсів'),
((SELECT id FROM d), 'zh', '马肉青酱', '配蜂蜜芥末刺山柑酱'),
((SELECT id FROM d), 'ja', 'ペスト・ディ・カヴァッロ', 'ハチミツ・マスタード・ケッパーソース添え');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Tagliata di Manzo', 22.00, 'secondi', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Tagliata di Manzo', 'Cime di rapa, patate arrosto e maionese alla senape'),
((SELECT id FROM d), 'en', 'Beef Tagliata', 'Turnip tops, roast potatoes and mustard mayonnaise'),
((SELECT id FROM d), 'ru', 'Тальята из говядины', 'Ботва репы, жареный картофель и горчичный майонез'),
((SELECT id FROM d), 'de', 'Rindfleisch-Tagliata', 'Rübenblätter, Bratkartoffeln und Senfmayonnaise'),
((SELECT id FROM d), 'fr', 'Tagliata de boeuf', 'Brocoli rabe, pommes de terre rôties et mayonnaise à la moutarde'),
((SELECT id FROM d), 'es', 'Tagliata de ternera', 'Grelos, patatas asadas y mayonesa de mostaza'),
((SELECT id FROM d), 'uk', 'Тальята з яловичини', 'Ботва ріпи, смажена картопля та гірчичний майонез'),
((SELECT id FROM d), 'zh', '牛肉薄片', '萝卜叶、烤土豆和芥末蛋黄酱'),
((SELECT id FROM d), 'ja', 'タリアータ・ディ・マンゾ', 'カブの葉、ロースト・ポテト、マスタードマヨネーズ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Vecchia di Cavallo', 14.00, 'secondi', 'tradizione', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Vecchia di Cavallo', 'Carne di cavallo matura, specialità della tradizione parmense'),
((SELECT id FROM d), 'en', 'Aged Horse Meat', 'Mature horse meat, speciality of the Parma tradition'),
((SELECT id FROM d), 'ru', 'Зрелая конина', 'Зрелое конское мясо, специалитет традиции Пармы'),
((SELECT id FROM d), 'de', 'Gereiftes Pferdefleisch', 'Gereiftes Pferdefleisch, Spezialität der Parmenser Tradition'),
((SELECT id FROM d), 'fr', 'Viande de cheval vieillie', 'Viande de cheval mature, spécialité de la tradition parmesane'),
((SELECT id FROM d), 'es', 'Carne de caballo envejecida', 'Carne de caballo madura, especialidad de la tradición parmesana'),
((SELECT id FROM d), 'uk', 'Зріла конина', 'Зріле кінське м''ясо, спеціалітет традиції Парми'),
((SELECT id FROM d), 'zh', '陈年马肉', '成熟马肉，帕尔马传统特色菜'),
((SELECT id FROM d), 'ja', 'ヴェッキア・ディ・カヴァッロ', '熟成した馬肉、パルマの伝統的なスペシャリティ');

-- ═══════════════════════════════════════════════════════
-- SEED: SECONDI GOURMET
-- ═══════════════════════════════════════════════════════

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_pescetarian, is_fish) VALUES ('Piovra con Crema di Fagioli Cannellini', 19.00, 'secondi', 'gourmet', TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Piovra con Crema di Fagioli Cannellini', 'Pomodorini confit e olive taggiasche'),
((SELECT id FROM d), 'en', 'Octopus with Cannellini Bean Cream', 'Confit cherry tomatoes and taggiasca olives'),
((SELECT id FROM d), 'ru', 'Осьминог с кремом из бобов каннеллини', 'Конфи из помидоров черри и оливки тальяске'),
((SELECT id FROM d), 'de', 'Tintenfisch mit Cannellini-Bohnencreme', 'Konfierte Kirschtomaten und Taggiasca-Oliven'),
((SELECT id FROM d), 'fr', 'Poulpe à la crème de haricots cannellini', 'Tomates cerises confites et olives taggiasca'),
((SELECT id FROM d), 'es', 'Pulpo con crema de alubias cannellini', 'Tomates cherry confitados y aceitunas taggiasca'),
((SELECT id FROM d), 'uk', 'Восьминіг з кремом із квасолі каннелліні', 'Конфі з помідорів черрі та оливки тальяске'),
((SELECT id FROM d), 'zh', '章鱼配白芸豆奶油', '糖渍樱桃番茄和塔加斯卡橄榄'),
((SELECT id FROM d), 'ja', 'タコとカネッリーニ豆のクリーム', 'セミドライトマトとタッジャスケオリーブ');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_pescetarian, is_fish) VALUES ('Filetto di Ombrina', 22.00, 'secondi', 'gourmet', TRUE, TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Filetto di Ombrina', 'Patata schiacciata e infuso alla menta'),
((SELECT id FROM d), 'en', 'Sea Bass Fillet', 'Crushed potato and mint infusion'),
((SELECT id FROM d), 'ru', 'Филе умбрины', 'Толчёный картофель и настой мяты'),
((SELECT id FROM d), 'de', 'Meerbarsch-Filet', 'Zerdrückte Kartoffel und Minzaufguss'),
((SELECT id FROM d), 'fr', 'Filet d''ombrine', 'Pomme de terre écrasée et infusion à la menthe'),
((SELECT id FROM d), 'es', 'Filete de corvina', 'Patata aplastada e infusión de menta'),
((SELECT id FROM d), 'uk', 'Філе умбрини', 'Товчена картопля та настій м''яти'),
((SELECT id FROM d), 'zh', '石首鱼柳', '压碎土豆和薄荷浸液'),
((SELECT id FROM d), 'ja', 'フィレット・ディ・オンブリーナ', 'つぶしジャガイモとミントのインフュージョン');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Gallo D''Oro con Verdure Croccanti', 17.00, 'secondi', 'gourmet', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Gallo D''Oro con Verdure Croccanti', 'Verdure croccanti di stagione e Salsa Yuzu'),
((SELECT id FROM d), 'en', 'Gallo D''Oro with Crunchy Vegetables', 'Seasonal crunchy vegetables and Yuzu sauce'),
((SELECT id FROM d), 'ru', 'Галло д''Оро с хрустящими овощами', 'Хрустящие сезонные овощи и соус Юзу'),
((SELECT id FROM d), 'de', 'Gallo D''Oro mit knusprigem Gemüse', 'Knuspriges Saisongemüse und Yuzu-Sauce'),
((SELECT id FROM d), 'fr', 'Gallo D''Oro aux légumes croustillants', 'Légumes croustillants de saison et sauce Yuzu'),
((SELECT id FROM d), 'es', 'Gallo D''Oro con verduras crujientes', 'Verduras crujientes de temporada y salsa Yuzu'),
((SELECT id FROM d), 'uk', 'Галло д''Оро з хрусткими овочами', 'Хрусткі сезонні овочі та соус Юзу'),
((SELECT id FROM d), 'zh', '金鸡配脆蔬菜', '时令脆蔬菜和柚子酱'),
((SELECT id FROM d), 'ja', 'ガッロ・ドーロ・コン・ヴェルドゥーレ・クロッカンティ', '旬のクリスピー野菜とユズソース');

WITH d AS (INSERT INTO dishes (name_it, price, category, menu_type, is_meat) VALUES ('Costolette d''Agnello', 22.00, 'secondi', 'gourmet', TRUE) RETURNING id)
INSERT INTO dish_translations (dish_id, lang, name, description) VALUES
((SELECT id FROM d), 'it', 'Costolette d''Agnello', 'Panure di pane panko e patate al forno'),
((SELECT id FROM d), 'en', 'Lamb Cutlets', 'Panko breadcrumbs and oven potatoes'),
((SELECT id FROM d), 'ru', 'Бараньи котлеты', 'Паниска панко и картофель в духовке'),
((SELECT id FROM d), 'de', 'Lammkoteletts', 'Panko-Panade und Ofenkartoffeln'),
((SELECT id FROM d), 'fr', 'Côtelettes d''agneau', 'Panure panko et pommes de terre au four'),
((SELECT id FROM d), 'es', 'Chuletas de cordero', 'Empanado de panko y patatas al horno'),
((SELECT id FROM d), 'uk', 'Баранячі котлети', 'Паніровка панко та картопля в духовці'),
((SELECT id FROM d), 'zh', '羊排', '面包糠和烤土豆'),
((SELECT id FROM d), 'ja', 'コストレッテ・ダニェッロ', 'パン粉のパナードとオーブンポテト');

-- ═══════════════════════════════════════════════════════
-- SEED: dish_allergens
-- ═══════════════════════════════════════════════════════
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Torta Fritta' AND a.name IN ('glutine','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Parmigiano Reggiano di Vacca Bruna' AND a.name IN ('latte','solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Giardiniera' AND a.name IN ('sedano','solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Gorgonzola' AND a.name IN ('latte');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Tagliere Goloso' AND a.name IN ('solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Tagliere dei Preziosi' AND a.name IN ('solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Tagliere Salumi del Contadino' AND a.name IN ('solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Degustazione di Formaggi Misti' AND a.name IN ('latte','solfiti','senape');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Battuta di Capriolo' AND a.name IN ('frutta a guscio','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Uovo Fritto alla Scozzese' AND a.name IN ('glutine','uova','latte','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Melanzana Gallo D''Oro' AND a.name IN ('latte','solfiti','frutta a guscio','glutine');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Cozze al Vapore' AND a.name IN ('molluschi','glutine','senape','solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it IN ('Tortelli di Erbetta','Tortelli di Zucca','Tortelli di Patate','Tris di Tortelli') AND a.name IN ('glutine','uova','latte','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Cappelletti al Ragù di Strolghino' AND a.name IN ('glutine','uova','sedano','solfiti','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Cappelletti in Brodo' AND a.name IN ('glutine','uova','sedano','solfiti','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Pappardelle al Ragù di Strolghino' AND a.name IN ('glutine','uova','solfiti','sedano','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Gnocchi al Ragù di Salumi' AND a.name IN ('glutine','sedano','uova','solfiti','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Risotto alla Malvasia Monte delle Vigne' AND a.name IN ('latte','solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Ravioli alla Crema di Parmigiano e Tartufo Nero' AND a.name IN ('glutine','uova','latte','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Gnocchi alle Vongole Veraci e Carciofi' AND a.name IN ('glutine','molluschi','uova','solfiti','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Spaghetto alla Chitarra' AND a.name IN ('glutine','pesce','soia','sesamo','latte','uova','frutta a guscio','solfiti');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Punta di Vitello Ripiena' AND a.name IN ('sedano','solfiti','latte','uova','glutine','soia','senape','lupini');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Pesto di Cavallo' AND a.name IN ('senape');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Tagliata di Manzo' AND a.name IN ('uova','senape');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Piovra con Crema di Fagioli Cannellini' AND a.name IN ('molluschi','sesamo','senape');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Filetto di Ombrina' AND a.name IN ('pesce');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Gallo D''Oro con Verdure Croccanti' AND a.name IN ('solfiti','soia');
INSERT INTO dish_allergens SELECT d.id, a.id FROM dishes d, allergens a WHERE d.name_it='Costolette d''Agnello' AND a.name IN ('glutine','soia','senape','lupini');

-- ═══════════════════════════════════════════════════════
-- ПОЛЕЗНЫЕ ЗАПРОСЫ
-- ═══════════════════════════════════════════════════════

-- Все блюда без глютена на английском:
-- SELECT d.name_it, t.name, t.description, d.price, d.category
-- FROM dishes d
-- JOIN dish_translations t ON d.id = t.dish_id AND t.lang = 'en'
-- WHERE d.is_active = TRUE
-- AND d.id NOT IN (
--     SELECT da.dish_id FROM dish_allergens da
--     JOIN allergens a ON da.allergen_id = a.id
--     WHERE a.name = 'glutine'
-- );

-- Все вегетарианские блюда без лактозы на русском:
-- SELECT d.name_it, t.name, d.price, d.category
-- FROM dishes d
-- JOIN dish_translations t ON d.id = t.dish_id AND t.lang = 'ru'
-- WHERE d.is_vegetarian = TRUE AND d.is_active = TRUE
-- AND d.id NOT IN (
--     SELECT da.dish_id FROM dish_allergens da
--     JOIN allergens a ON da.allergen_id = a.id
--     WHERE a.name = 'latte'
-- );

-- Все блюда с аллергенами:
-- SELECT d.name_it, d.price, d.category, d.menu_type,
--        STRING_AGG(a.name, ', ' ORDER BY a.name) AS allergens
-- FROM dishes d
-- LEFT JOIN dish_allergens da ON d.id = da.dish_id
-- LEFT JOIN allergens a ON da.allergen_id = a.id
-- GROUP BY d.id, d.name_it, d.price, d.category, d.menu_type
-- ORDER BY d.category, d.menu_type;
