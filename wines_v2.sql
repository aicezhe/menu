SET client_encoding = 'UTF8';

-- Удаляем старые таблицы если есть
DROP TABLE IF EXISTS wine_pairings CASCADE;
DROP TABLE IF EXISTS wines CASCADE;

-- ═══════════════════════════════════════
-- ТАБЛИЦА ВИН
-- ═══════════════════════════════════════
CREATE TABLE wines (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    producer        VARCHAR(200),
    region          VARCHAR(100),
    grape           VARCHAR(200),
    color           VARCHAR(20)  NOT NULL,   -- rosso / bianco / rosato / spumante
    style           VARCHAR(20)  NOT NULL,   -- fermo / frizzante / spumante
    is_local        BOOLEAN DEFAULT FALSE,   -- local = Parma/Emilia
    description_it  TEXT,
    description_en  TEXT,
    description_ru  TEXT,
    price_bottle    NUMERIC(8,2),
    price_glass     NUMERIC(6,2),
    price_quarter   NUMERIC(6,2),
    price_half      NUMERIC(6,2),
    section         VARCHAR(30) NOT NULL,    -- 'mescita' / 'casa' / 'bottle'
    is_active       BOOLEAN DEFAULT TRUE,
    sort_order      INTEGER DEFAULT 0
);

-- ═══════════════════════════════════════
-- ПРАВИЛА ПОДБОРА
-- ═══════════════════════════════════════
CREATE TABLE wine_pairings (
    id          SERIAL PRIMARY KEY,
    wine_id     INTEGER REFERENCES wines(id) ON DELETE CASCADE,
    dish_type   VARCHAR(30) NOT NULL,  -- meat / fish / vegetarian / vegan / any
    score       INTEGER DEFAULT 1
);

-- ═══════════════════════════════════════
-- 1. SELEZIONE ALLA MESCITA (бокалы, page 4)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_glass, section, sort_order) VALUES

('Jejo Brut Prosecco Superiore DOCG', 'Bisol', 'Veneto', 'Glera', 'bianco', 'spumante', false,
 'Prosecco elegante con perlage fine. Fresco e vivace.',
 'Elegant Prosecco with fine bubbles. Fresh and lively.',
 'Элегантное Просекко с тонкими пузырьками. Свежее и живое.',
 6.00, 'mescita', 8),

('LH2 Metodo Classico Extra Brut BIO', 'Umani Ronchi', 'Marche', 'Verdicchio 70%, Chardonnay 30%', 'bianco', 'spumante', false,
 'Spumante biologico Metodo Classico, cremoso e complesso.',
 'Organic Metodo Classico sparkling wine, creamy and complex.',
 'Органическое игристое Метод Классик — кремовое и сложное.',
 7.00, 'mescita', 7),

('Franciacorta Brut DOCG', 'Ferghettina', 'Lombardia', 'Chardonnay, Pinot Nero', 'bianco', 'spumante', false,
 'Franciacorta elegante, il Champagne italiano. Perlage fine e persistente.',
 'Elegant Franciacorta — the Italian Champagne.',
 'Элегантная Франчакорта — итальянское Шампанское.',
 8.00, 'mescita', 7),

('Plenio Verdicchio dei Castelli di Jesi DOCG Riserva BIO', 'Umani Ronchi', 'Marche', 'Verdicchio', 'bianco', 'fermo', false,
 'Verdicchio biologico Riserva, strutturato e minerale con note di agrumi.',
 'Organic Riserva Verdicchio, structured and mineral with citrus notes.',
 'Органическое Резерва Вердиккио — структурированное и минеральное с цитрусовыми нотами.',
 7.00, 'mescita', 8),

('Ape Chardonnay / Emilia IGT', 'Romagnoli', 'Emilia', 'Chardonnay', 'bianco', 'fermo', true,
 'Chardonnay emiliano, bianco secco e fresco.',
 'Emilian Chardonnay, dry and fresh.',
 'Эмилианское Шардоне, сухое и свежее.',
 7.00, 'mescita', 7),

('Centovie Rosato Colli Aprutini IGT BIO', 'Umani Ronchi', 'Abruzzo', 'Montepulciano', 'rosato', 'fermo', false,
 'Rosato biologico fresco e beverino.',
 'Fresh organic rosé, easy-drinking.',
 'Свежее органическое розовое, лёгкое.',
 7.00, 'mescita', 6),

('Cà Grande Sangiovese Superiore', 'Umani Ronchi', 'Romagna', 'Sangiovese', 'rosso', 'fermo', false,
 'Sangiovese romagnolo con note di ciliegia e spezie.',
 'Romagna Sangiovese with cherry and spice notes.',
 'Санджовезе Романьи с нотами вишни и специй.',
 6.00, 'mescita', 7),

('Ape Pinot Nero / Romagnia DOC Sangiovese Superiore', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosso', 'fermo', false,
 'Sangiovese superiore, elegante e fruttato.',
 'Superior Sangiovese, elegant and fruity.',
 'Превосходный Санджовезе — элегантный и фруктовый.',
 6.00, 'mescita', 6),

('Ape Gutturnio Superiore DOC BIO', 'Romagnoli', 'Piacenza', 'Barbera 60%, Croatina 40%', 'rosso', 'fermo', true,
 'Gutturnio biologico piacentino, morbido e profumato.',
 'Organic Piacenza Gutturnio, soft and fragrant.',
 'Органический Гуттурнио из Пьяченцы — мягкое и ароматное.',
 7.00, 'mescita', 7),

('Centovie Montepulciano d''Abruzzo DOC BIO', 'Romagnoli', 'Abruzzo', 'Montepulciano', 'rosso', 'fermo', false,
 'Montepulciano biologico, rosso corposo del centro Italia.',
 'Organic Montepulciano, full-bodied red from central Italy.',
 'Органический Монтепульчано — насыщенное красное из Центральной Италии.',
 6.00, 'mescita', 6),

('Crocifero / Colli Fiorentini DOCG', 'Torre a Cona', 'Toscana', 'Sangiovese 90%, Colorino 10%', 'rosso', 'fermo', false,
 'Sangiovese toscano con note di prugna e vaniglia.',
 'Tuscan Sangiovese with plum and vanilla notes.',
 'Тосканский Санджовезе с нотами сливы и ванили.',
 6.00, 'mescita', 7),

('Umani Ronchi Roseto degli Abruzzi', 'Umani Ronchi', 'Abruzzo', 'Montepulciano', 'rosso', 'fermo', false,
 'Rosso abruzzese robusto e persistente.',
 'Robust Abruzzo red, warm and persistent.',
 'Насыщенное красное из Абруццо — тёплое и длительное.',
 7.00, 'mescita', 5);

-- ═══════════════════════════════════════
-- 2. VINI DELLA CASA (домашние, page 5)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_bottle, price_glass, price_quarter, price_half, section, sort_order) VALUES

('Rosso Colli di Parma DOC BIO', 'Monte delle Vigne', 'Parma', 'Barbera 70%, Bonarda 30%', 'rosso', 'fermo', true,
 'Vino rosso locale biologico. Corposo e fruttato, perfetto con i piatti della tradizione parmigiana.',
 'Local organic red wine. Full-bodied and fruity, perfect with traditional Parma dishes.',
 'Местное органическое красное вино. Насыщенное и фруктовое — идеально к блюдам пармской традиции.',
 15.00, 5.00, 7.00, 9.00, 'casa', 10),

('Lambrusco IGT Emilia', 'Monte delle Vigne', 'Emilia', 'Lambrusco Maestri 100%', 'rosso', 'frizzante', true,
 'Lambrusco frizzante secco, vivace e fresco. Il grande classico emiliano.',
 'Dry sparkling Lambrusco, lively and fresh. The great Emilian classic.',
 'Сухой игристый Ламбруско — живой и свежий. Великая классика Эмилии.',
 15.00, 5.00, 7.00, 9.00, 'casa', 10),

('Genestra Bianco Colli di Parma DOC BIO', 'Monte delle Vigne', 'Parma', 'Malvasia di Candia Aromatica', 'bianco', 'fermo', true,
 'Vino bianco biologico profumato con note floreali e fruttate.',
 'Aromatic organic white wine with floral and fruity notes.',
 'Ароматное органическое белое вино с цветочными и фруктовыми нотами.',
 15.00, 5.00, 7.00, 9.00, 'casa', 9),

('Malvasia Frizzante IGT Emilia', 'Monte delle Vigne', 'Parma', 'Malvasia di Candia Aromatica', 'bianco', 'frizzante', true,
 'Malvasia frizzante aromatica, leggera e piacevole. Ideale come aperitivo.',
 'Aromatic sparkling Malvasia, light and pleasant. Ideal as aperitif.',
 'Ароматная игристая Мальвазия — лёгкая и приятная. Идеальный аперитив.',
 15.00, 5.00, 7.00, 9.00, 'casa', 9);

-- ═══════════════════════════════════════
-- 3. БУТЫЛКИ — Emilia Romagna (pages 10-11)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_bottle, section, sort_order) VALUES

('I Calanchi Lambrusco Bio Colli di Parma DOC', 'Monte delle Vigne', 'Parma', 'Lambrusco', 'rosso', 'frizzante', true,
 'Lambrusco biologico locale. Il compagno ideale dei salumi parmigiani.',
 'Local organic Lambrusco. The ideal companion for Parma cold cuts.',
 'Местный органический Ламбруско — идеальный компаньон для пармских деликатесов.',
 18.00, 'bottle', 10),

('Otello Lambrusco IGT Emilia', 'Ceci', 'Emilia', 'Lambrusco Maestri', 'rosso', 'frizzante', true,
 'Lambrusco classico emiliano, fresco e beverino.',
 'Classic Emilian Lambrusco, fresh and easy-drinking.',
 'Классический эмилианский Ламбруско — свежий и лёгкий.',
 16.00, 'bottle', 8),

('Terre Verdiane Lambrusco Emilia IGT', 'Ceci', 'Emilia', 'Lambrusco', 'rosso', 'frizzante', true,
 'Lambrusco secco, vivace con note di frutti rossi.',
 'Dry Lambrusco, lively with red fruit notes.',
 'Сухой Ламбруско с нотами красных фруктов.',
 16.00, 'bottle', 7),

('Fortanna "La Luna" Fortana Emilia IGT', 'Ceci', 'Emilia', 'Fortana', 'rosso', 'frizzante', true,
 'Vino frizzante leggero da uva Fortana, vitigno autoctono emiliano.',
 'Light sparkling wine from Fortana, native Emilian grape.',
 'Лёгкое игристое из Фортана — местного эмилианского сорта.',
 16.00, 'bottle', 6),

('Callas Malvasia di Candia Aromatica IGT', 'Monte delle Vigne', 'Parma', 'Malvasia di Candia Aromatica', 'bianco', 'fermo', true,
 'Malvasia ferma elegante e floreale, profumata.',
 'Still elegant and floral Malvasia, fragrant.',
 'Тихая элегантная и цветочная Мальвазия.',
 24.00, 'bottle', 9),

('Ape Chardonnay / Emilia IGT bottiglia', 'Romagnoli', 'Emilia', 'Chardonnay', 'bianco', 'fermo', true,
 'Chardonnay emiliano fresco, ideale con pesce e antipasti.',
 'Fresh Emilian Chardonnay, ideal with fish and starters.',
 'Свежее эмилианское Шардоне — идеально к рыбе и закускам.',
 28.00, 'bottle', 7),

('Costa di Rose Sangiovese Rubicone IGT', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosato', 'fermo', false,
 'Rosato fermo da Sangiovese, fresco e gastronomico.',
 'Still Sangiovese rosé, fresh and food-friendly.',
 'Тихое розовое из Санджовезе — свежее и гастрономическое.',
 25.00, 'bottle', 7),

('Rubina Brut Rosé BIO', 'Monte delle Vigne', 'Emilia', 'Barbera', 'rosato', 'spumante', true,
 'Brut Rosé spumante biologico, elegante e fresco.',
 'Organic sparkling Brut Rosé, elegant and fresh.',
 'Органическое игристое Брут Розе — элегантное и свежее.',
 19.00, 'bottle', 8),

('Il Chiu So Riserva Emilia IGT BIO', 'Monte delle Vigne', 'Parma', 'Cabernet Franc', 'rosso', 'fermo', true,
 'Cabernet Franc biologico di Parma, elegante con note di mora e peperone.',
 'Organic Parma Cabernet Franc, elegant with blackberry and pepper notes.',
 'Органический Каберне Фран из Пармы — элегантный с нотами ежевики и перца.',
 26.00, 'bottle', 9),

('Nabucco Emilia IGT BIO', 'Monte delle Vigne', 'Parma', 'Barbera, Merlot', 'rosso', 'fermo', true,
 'Blend biologico locale potente e strutturato.',
 'Powerful and structured local organic blend.',
 'Мощный и структурированный местный органический купаж.',
 38.00, 'bottle', 8),

('Valnuraia Merlot / Emilia IGT', 'Romagnoli', 'Emilia', 'Merlot', 'rosso', 'fermo', true,
 'Merlot emiliano morbido e vellutato.',
 'Soft and velvety Emilian Merlot.',
 'Мягкое и бархатистое эмилианское Мерло.',
 22.00, 'bottle', 7),

('Cà Grande Sangiovese Superiore bottiglia', 'Romagnoli', 'Romagna', 'Sangiovese', 'rosso', 'fermo', false,
 'Sangiovese Superiore di carattere, rosso vivace della Romagna.',
 'Characterful Superiore Sangiovese, lively Romagna red.',
 'Характерный Санджовезе Суперьоре — живое красное Романьи.',
 24.00, 'bottle', 8),

('Laurento Romagna DOC Sangiovese Riserva', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosso', 'fermo', false,
 'Sangiovese Riserva elegante e longevo.',
 'Elegant and age-worthy Sangiovese Riserva.',
 'Элегантное Санджовезе Резерва с потенциалом выдержки.',
 26.00, 'bottle', 8);

-- ═══════════════════════════════════════
-- 3. БУТЫЛКИ — Bianchi Italiani (pages 12-13)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_bottle, section, sort_order) VALUES

('Floreado Sauvignon Blanc Alto Adige DOC', 'Andrian', 'Alto Adige', 'Sauvignon Blanc', 'bianco', 'fermo', false,
 'Sauvignon Blanc altoatesino, aromatico e minerale.',
 'Alto Adige Sauvignon Blanc, aromatic and mineral.',
 'Совиньон Блан из Альто-Адидже — ароматный и минеральный.',
 26.00, 'bottle', 8),

('Somdretto Chardonnay Alto Adige DOC', 'Andrian', 'Alto Adige', 'Chardonnay', 'bianco', 'fermo', false,
 'Chardonnay elegante dell''Alto Adige, fresco e complesso.',
 'Elegant Alto Adige Chardonnay, fresh and complex.',
 'Элегантное Шардоне из Альто-Адидже — свежее и сложное.',
 26.00, 'bottle', 7),

('Riesling Alto Adige DOC', 'Rielinger', 'Alto Adige', 'Riesling', 'bianco', 'fermo', false,
 'Riesling altoatesino, aromatico con note floreali e minerali.',
 'Alto Adige Riesling, aromatic with floral and mineral notes.',
 'Рислинг из Альто-Адидже — ароматный с цветочными и минеральными нотами.',
 40.00, 'bottle', 7),

('Abbazia di Rosazzo DOCG', 'Livio Felluga', 'Friuli', 'Friulano, Sauvignon, Pinot Bianco, Ribolla Gialla', 'bianco', 'fermo', false,
 'Grande bianco friulano da blend di vitigni autoctoni. Struttura e complessità.',
 'Great Friulian white blend of native varieties. Structure and complexity.',
 'Великое фриульское белое из местных сортов. Структура и сложность.',
 120.00, 'bottle', 10),

('Plenio Verdicchio dei Castelli di Jesi DOCG Riserva BIO', 'Umani Ronchi', 'Marche', 'Verdicchio', 'bianco', 'fermo', false,
 'Verdicchio biologico Riserva, uno dei migliori bianchi italiani.',
 'Organic Riserva Verdicchio, one of Italy''s best whites.',
 'Органическое Вердиккио Резерва — одно из лучших итальянских белых.',
 32.00, 'bottle', 9),

('Vigor Passerina Marche IGT BIO', 'Umani Ronchi', 'Marche', 'Passerina', 'bianco', 'fermo', false,
 'Passerina biologica, bianco fresco e sapido delle Marche.',
 'Organic Passerina, fresh and savory white from Marche.',
 'Органическая Пассерина — свежее и пикантное белое из Марке.',
 18.00, 'bottle', 7),

('Historical Verdicchio Classico Superiore BIO', 'Umani Ronchi', 'Marche', 'Verdicchio', 'bianco', 'fermo', false,
 'Verdicchio biologico Classico Superiore, minerale e longevo.',
 'Organic Classico Superiore Verdicchio, mineral and age-worthy.',
 'Органическое Классико Суперьоре Вердиккио — минеральное с потенциалом.',
 56.00, 'bottle', 9),

('Collezione Privata Chardonnay / Toscana IGT', 'Isole e Olena', 'Toscana', 'Chardonnay', 'bianco', 'fermo', false,
 'Chardonnay toscano di altissima qualità, elegante e persistente.',
 'Highest quality Tuscan Chardonnay, elegant and persistent.',
 'Тосканское Шардоне высочайшего качества — элегантное и длительное.',
 90.00, 'bottle', 9),

('Vellodoro Pecorino / Terre di Chieti IGT BIO', 'Umani Ronchi', 'Abruzzo', 'Pecorino', 'bianco', 'fermo', false,
 'Pecorino biologico abruzzese, fresco e sapido.',
 'Organic Abruzzo Pecorino, fresh and savory.',
 'Органический Пекорино из Абруццо — свежий и пикантный.',
 15.00, 'bottle', 7),

('Alta Mora Etna Bianco DOC', 'Cusumano', 'Sicilia', 'Carricante', 'bianco', 'fermo', false,
 'Bianco etneo vulcanico e minerale con grande personalità.',
 'Volcanic and mineral Etna white with great personality.',
 'Вулканическое и минеральное Этна Бьянко с сильным характером.',
 36.00, 'bottle', 8),

('Cinque Terre DOC', 'Terenzuola', 'Liguria', 'Bianco Bosco, Vermentino, Albarola, Russese', 'bianco', 'fermo', false,
 'Bianco ligure fresco e sapido con note marine.',
 'Ligurian white, fresh and savory with sea notes.',
 'Лигурийское белое — свежее и пикантное с морскими нотами.',
 38.00, 'bottle', 7);

-- ═══════════════════════════════════════
-- 3. БУТЫЛКИ — Rosati (page 14)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_bottle, section, sort_order) VALUES

('Costa di Rose / Sangiovese Rubicone IGT', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosato', 'fermo', false,
 'Rosato fermo da Sangiovese, fresco e beverino.',
 'Still Sangiovese rosé, fresh and easy-drinking.',
 'Тихое розовое Санджовезе — свежее и лёгкое.',
 25.00, 'bottle', 7),

('Centove / Colli Aversani IGT Rosato BIO', 'Monte delle Vigne', 'Emilia', 'Montepulciano', 'rosato', 'fermo', true,
 'Rosato biologico locale, vivace e fresco.',
 'Local organic rosé, lively and fresh.',
 'Местное органическое розовое — живое и свежее.',
 18.00, 'bottle', 8),

('Hype / Rosato Primitivo IGP', 'Rosa del Golfo', 'Puglia', 'Primitivo', 'rosato', 'fermo', false,
 'Rosato pugliese da Primitivo, caldo e strutturato.',
 'Puglian Primitivo rosé, warm and structured.',
 'Пульезе розовое из Примитиво — тёплое и структурированное.',
 22.00, 'bottle', 6);

-- ═══════════════════════════════════════
-- 3. БУТЫЛКИ — Rossi Italiani (pages 14-18)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_bottle, section, sort_order) VALUES

('Patricia Pinot Nero Riserva Alto Adige DOC', 'Girlan', 'Alto Adige', 'Pinot Nero', 'rosso', 'fermo', false,
 'Pinot Nero Riserva altoatesino, elegante e fine.',
 'Alto Adige Pinot Nero Riserva, elegant and refined.',
 'Пино Неро Резерва из Альто-Адидже — элегантный и утончённый.',
 30.00, 'bottle', 8),

('Trattmann Pinot Noir Alto Adige DOC', 'Girlan', 'Alto Adige', 'Pinot Nero', 'rosso', 'fermo', false,
 'Pinot Noir altoatesino, rosso fine con note di ciliegia e spezie.',
 'Alto Adige Pinot Noir, refined red with cherry and spice notes.',
 'Пино Нуар из Альто-Адидже — утончённое красное с нотами вишни и специй.',
 70.00, 'bottle', 8),

('Gant Merlot Alto Adige DOC Riserva', 'Andrian', 'Alto Adige', 'Merlot', 'rosso', 'fermo', false,
 'Merlot Riserva altoatesino, elegante e speziato.',
 'Alto Adige Merlot Riserva, elegant and spiced.',
 'Мерло Резерва из Альто-Адидже — элегантное и пряное.',
 75.00, 'bottle', 8),

('Tor di Lupo Lagrein DOC Riserva', 'Andrian', 'Alto Adige', 'Lagrein', 'rosso', 'fermo', false,
 'Lagrein Riserva, vitigno autoctono altoatesino. Scuro e vellutato.',
 'Lagrein Riserva, native Alto Adige variety. Dark and velvety.',
 'Лагрейн Резерва — местный сорт Альто-Адидже. Тёмное и бархатистое.',
 75.00, 'bottle', 8),

('Rodel Pianezzi Pinot Nero / Alto Adige', 'Pojer e Sandri', 'Trentino', 'Pinot Nero', 'rosso', 'fermo', false,
 'Pinot Nero trentino di grande eleganza.',
 'Elegant Trentino Pinot Nero.',
 'Элегантное Пино Неро из Трентино.',
 60.00, 'bottle', 7),

('Primitivo di Manduria / Rosso del Salento IGT', 'Rosa del Golfo', 'Puglia', 'Primitivo', 'rosso', 'fermo', false,
 'Primitivo pugliese, caldo con note di ciliegia nera e cioccolato.',
 'Puglian Primitivo, warm with black cherry and chocolate notes.',
 'Пульезе Примитиво — тёплое с нотами тёмной вишни и шоколада.',
 19.00, 'bottle', 7),

('Portulano / Rosso Negroamaro del Salento IGT', 'Rosa del Golfo', 'Puglia', 'Negroamaro, Malvasia Nera', 'rosso', 'fermo', false,
 'Negroamaro strutturato e caldo, tipico della Puglia.',
 'Structured and warm Negroamaro, typical of Puglia.',
 'Структурированный и тёплый Негроамаро — типичный для Апулии.',
 19.00, 'bottle', 6),

('Chianti Classico DOCG', 'Castellare', 'Toscana', 'Sangiovese, Canaiolo', 'rosso', 'fermo', false,
 'Chianti Classico elegante, il simbolo del vino toscano.',
 'Elegant Chianti Classico, the symbol of Tuscan wine.',
 'Элегантный Кьянти Классико — символ тосканского вина.',
 39.00, 'bottle', 9),

('Brunello di Montalcino DOCG', 'Biondi Santi', 'Toscana', 'Sangiovese', 'rosso', 'fermo', false,
 'Brunello leggendario. Grande vino da meditazione.',
 'Legendary Brunello. A great meditation wine.',
 'Легендарное Брунелло. Великое вино для медитации.',
 220.00, 'bottle', 10),

('Nobile di Montepulciano DOCG', 'Poliziano', 'Toscana', 'Prugnolo Gentile, Colorino, Merlot', 'rosso', 'fermo', false,
 'Nobile elegante, perfetto con carni rosse.',
 'Elegant Nobile, perfect with red meats.',
 'Элегантное Нобиле — идеально к красному мясу.',
 37.00, 'bottle', 9),

('Asinone Nobile di Montepulciano IGT', 'Poliziano', 'Toscana', 'Sangiovese', 'rosso', 'fermo', false,
 'Nobile di Montepulciano di grande carattere.',
 'Great character Nobile di Montepulciano.',
 'Нобиле ди Монтепульчано с сильным характером.',
 90.00, 'bottle', 9),

('Grattamacco Bolgheri Rosso Superiore DOC', 'Grattamacco', 'Toscana', 'Cab. Sauvignon, Merlot, Sangiovese', 'rosso', 'fermo', false,
 'Super Tuscan di Bolgheri, potente e internazionale.',
 'Super Tuscan from Bolgheri, powerful and international.',
 'Супер-Тоскана из Больгери — мощное вино международного уровня.',
 130.00, 'bottle', 9),

('Monclivio Barolo DOCG', 'Colombo Sormani', 'Piemonte', 'Nebbiolo', 'rosso', 'fermo', false,
 'Barolo, il re dei vini italiani. Potente, tannico e longevo.',
 'Barolo, the king of Italian wines. Powerful and age-worthy.',
 'Бароло — король итальянских вин. Мощное, танинное, для выдержки.',
 30.00, 'bottle', 10),

('Carapace Montefalco Sagrantino DOCG BIO', 'Tenuta Castelbuono', 'Umbria', 'Sagrantino', 'rosso', 'fermo', false,
 'Sagrantino potente e tannico, uno dei vini più strutturati d''Italia.',
 'Powerful and tannic Sagrantino, one of Italy''s most structured wines.',
 'Мощный и танинный Сагрантино — одно из самых структурированных вин Италии.',
 45.00, 'bottle', 9),

('Campo San Giorgio Montepulciano 100% BIO', 'Umani Ronchi', 'Marche', 'Montepulciano', 'rosso', 'fermo', false,
 'Montepulciano biologico puro, rosso caldo e avvolgente.',
 'Pure organic Montepulciano, warm and enveloping.',
 'Чистый органический Монтепульчано — тёплое и обволакивающее.',
 58.00, 'bottle', 8),

('Guardiola Etna Rosso DOC Riserva', 'Cusumano', 'Sicilia', 'Nerello Mascalese', 'rosso', 'fermo', false,
 'Etna Rosso Riserva, vulcanico e minerale.',
 'Etna Rosso Riserva, volcanic and mineral.',
 'Этна Россо Резерва — вулканическое и минеральное.',
 58.00, 'bottle', 8);

-- ═══════════════════════════════════════
-- 3. БУТЫЛКИ — Grandi Vini (pages 6-7)
-- ═══════════════════════════════════════
INSERT INTO wines (name, producer, region, grape, color, style, is_local, description_it, description_en, description_ru, price_bottle, section, sort_order) VALUES

('Giulio Ferrari Riserva del Fondatore', 'Ferrari', 'Trentino', 'Chardonnay', 'bianco', 'spumante', false,
 'Il più grande spumante italiano. Millesimato, affinato oltre 10 anni.',
 'Italy''s greatest sparkling. Vintage wine, aged over 10 years.',
 'Величайшее итальянское игристое. Миллезимированное, выдержанное более 10 лет.',
 200.00, 'bottle', 10),

('Livio Felluga Rosazzo DOCG', 'Livio Felluga', 'Friuli', 'Malvasia Istriana, Ribolla Gialla', 'bianco', 'fermo', false,
 'Bianco friulano di riferimento, elegante e complesso.',
 'Reference Friulian white, elegant and complex.',
 'Эталонное фриульское белое — элегантное и сложное.',
 120.00, 'bottle', 9);

-- ═══════════════════════════════════════
-- ПРАВИЛА ПОДБОРА
-- ═══════════════════════════════════════

-- МЯСО → красные fermo, Lambrusco, Sangiovese
INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'meat', 9 FROM wines WHERE color = 'rosso' AND style = 'fermo' AND section IN ('mescita','bottle');

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'meat', 10 FROM wines WHERE style = 'frizzante' AND color = 'rosso' AND is_local = true;

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'meat', 8 FROM wines WHERE name LIKE '%Sangiovese%' OR name LIKE '%Lambrusco%';

-- РЫБА → белые
INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'fish', 9 FROM wines WHERE color = 'bianco' AND style = 'fermo';

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'fish', 8 FROM wines WHERE color = 'bianco' AND style IN ('frizzante','spumante');

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'fish', 7 FROM wines WHERE color = 'rosato';

-- ВЕГЕТАРИАНСКОЕ → белые и frizzante
INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'vegetarian', 9 FROM wines WHERE name LIKE '%Malvasia%';

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'vegetarian', 8 FROM wines WHERE color = 'bianco';

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'vegetarian', 8 FROM wines WHERE style IN ('frizzante','spumante');

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'vegetarian', 7 FROM wines WHERE color = 'rosato';

-- ВЕГАН — то же что вегетарианское
INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT wine_id, 'vegan', score FROM wine_pairings WHERE dish_type = 'vegetarian';

-- ЛЮБОЕ (antipasti и универсальные)
INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'any', 8 FROM wines WHERE style IN ('spumante','frizzante');

INSERT INTO wine_pairings (wine_id, dish_type, score)
SELECT id, 'any', 7 FROM wines WHERE color = 'rosato';
