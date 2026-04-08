SET client_encoding = 'UTF8';

-- ═══════════════════════════════════════════════════
-- ТАБЛИЦА ВИН
-- ═══════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS wines (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,       -- название вина
    producer        VARCHAR(200),                -- производитель
    region          VARCHAR(100),                -- регион (Parma, Toscana...)
    grape           VARCHAR(200),                -- виноград
    color           VARCHAR(20)  NOT NULL,       -- 'rosso' / 'bianco' / 'rosato' / 'spumante'
    style           VARCHAR(20)  NOT NULL,       -- 'fermo' / 'frizzante' / 'spumante'
    description_it  TEXT,
    description_en  TEXT,
    description_ru  TEXT,
    price_bottle    NUMERIC(8,2),               -- цена бутылки (NULL если нет)
    price_glass     NUMERIC(6,2),               -- цена бокала (NULL если нет)
    price_quarter   NUMERIC(6,2),               -- цена 0.25л (NULL если нет)
    price_half      NUMERIC(6,2),               -- цена 0.5л (NULL если нет)
    is_house_wine   BOOLEAN DEFAULT FALSE,       -- домашнее вино (Vini della Casa)
    is_by_glass     BOOLEAN DEFAULT FALSE,       -- продаётся бокалами (Selezione alla Mescita)
    is_active       BOOLEAN DEFAULT TRUE,
    sort_order      INTEGER DEFAULT 0            -- для сортировки рекомендаций
);

-- ═══════════════════════════════════════════════════
-- ПРАВИЛА ПОДБОРА (вино ↔ профиль блюда)
-- ═══════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS wine_pairings (
    id          SERIAL PRIMARY KEY,
    wine_id     INTEGER REFERENCES wines(id) ON DELETE CASCADE,
    -- профиль блюда
    dish_type   VARCHAR(30) NOT NULL,   -- 'meat' / 'fish' / 'vegetarian' / 'vegan' / 'any'
    category    VARCHAR(30),            -- 'antipasti' / 'primi' / 'secondi' / NULL = любая
    menu_type   VARCHAR(20),            -- 'tradizione' / 'gourmet' / NULL = любой
    score       INTEGER DEFAULT 1       -- чем выше — тем лучше совпадение (1-10)
);

-- ═══════════════════════════════════════════════════
-- ВИНА DELLA CASA (продаются бокалами и бутылками)
-- ═══════════════════════════════════════════════════

INSERT INTO wines (name, producer, region, grape, color, style, description_it, description_en, description_ru, price_bottle, price_glass, price_quarter, price_half, is_house_wine, is_by_glass, sort_order) VALUES

('Rosso Colli di Parma DOC BIO', 'Monte delle Vigne', 'Parma', 'Barbera 70%, Bonarda 30%', 'rosso', 'fermo',
 'Vino rosso locale biologico, corposo e fruttato. Perfetto con i piatti della tradizione parmigiana.',
 'Local organic red wine, full-bodied and fruity. Perfect with traditional Parma dishes.',
 'Местное органическое красное вино, насыщенное и фруктовое. Идеально к блюдам пармской традиции.',
 15.00, 5.00, 7.00, 9.00, TRUE, TRUE, 10),

('Lambrusco IGT Emilia', 'Monte delle Vigne', 'Emilia', 'Lambrusco Maestri 100%', 'rosso', 'frizzante',
 'Lambrusco frizzante secco, vivace e fresco. Il grande classico emiliano.',
 'Dry sparkling Lambrusco, lively and fresh. The great Emilian classic.',
 'Сухой игристый Ламбруско, живой и свежий. Великая классика Эмилии.',
 15.00, 5.00, 7.00, 9.00, TRUE, TRUE, 10),

('Genestra Bianco Colli di Parma DOC BIO', 'Monte delle Vigne', 'Parma', 'Malvasia di Candia Aromatica', 'bianco', 'fermo',
 'Vino bianco biologico profumato e aromatico, con note floreali e fruttate.',
 'Aromatic organic white wine with floral and fruity notes.',
 'Ароматное органическое белое вино с цветочными и фруктовыми нотами.',
 15.00, 5.00, 7.00, 9.00, TRUE, TRUE, 9),

('Malvasia Frizzante IGT Emilia', 'Monte delle Vigne', 'Parma', 'Malvasia di Candia Aromatica', 'bianco', 'frizzante',
 'Malvasia frizzante aromatica, leggera e piacevole. La scelta perfetta per un aperitivo.',
 'Aromatic sparkling Malvasia, light and pleasant. The perfect aperitif choice.',
 'Ароматная игристая Мальвазия, лёгкая и приятная. Идеальный аперитив.',
 15.00, 5.00, 7.00, 9.00, TRUE, TRUE, 9);

-- ═══════════════════════════════════════════════════
-- SELEZIONE ALLA MESCITA (только бокалами, page 4)
-- ═══════════════════════════════════════════════════

INSERT INTO wines (name, producer, region, grape, color, style, description_it, description_en, description_ru, price_glass, is_by_glass, sort_order) VALUES

('Jejo Brut Prosecco Superiore DOCG', 'Bisol', 'Veneto', 'Glera', 'bianco', 'spumante',
 'Prosecco elegante e fine, con perlage persistente e note di mela verde.',
 'Elegant Prosecco with persistent bubbles and green apple notes.',
 'Элегантное Просекко с устойчивыми пузырьками и нотами зелёного яблока.',
 6.00, TRUE, 7),

('LH2 Metodo Classico Extra Brut BIO', 'Umani Ronchi', 'Marche', 'Verdicchio 70%, Chardonnay 30%', 'bianco', 'spumante',
 'Spumante biologico Metodo Classico, cremoso e complesso.',
 'Organic Metodo Classico sparkling wine, creamy and complex.',
 'Органическое игристое Метод Классик, кремовое и сложное.',
 7.00, TRUE, 6),

('Franciacorta Brut DOCG', 'Umani Ronchi', 'Lombardia', 'Chardonnay, Pinot Nero', 'bianco', 'spumante',
 'Franciacorta elegante, il Champagne italiano. Perlage fine e persistente.',
 'Elegant Franciacorta, the Italian Champagne. Fine and persistent bubbles.',
 'Элегантная Франчакорта — итальянское Шампанское. Тонкие, стойкие пузырьки.',
 8.00, TRUE, 6),

('Plenio Verdicchio dei Castelli di Jesi DOCG Riserva BIO', 'Umani Ronchi', 'Marche', 'Verdicchio', 'bianco', 'fermo',
 'Verdicchio biologico Riserva, strutturato e minerale con note di agrumi.',
 'Organic Riserva Verdicchio, structured and mineral with citrus notes.',
 'Органическое Резерва Вердиккио, структурированное и минеральное с цитрусовыми нотами.',
 7.00, TRUE, 7),

('Ape Chardonnay / Emilia IGT', 'Romagnoli', 'Emilia', 'Chardonnay', 'bianco', 'fermo',
 'Chardonnay emiliano, bianco secco e fresco con note di frutta bianca.',
 'Emilian Chardonnay, dry and fresh with white fruit notes.',
 'Эмилианское Шардоне, сухое и свежее с нотами белых фруктов.',
 7.00, TRUE, 6),

('Centovie Rosato Colli Aprutini IGT BIO', 'Umani Ronchi', 'Abruzzo', 'Montepulciano', 'rosato', 'fermo',
 'Rosato biologico dal colore vivace, fresco e beverino.',
 'Vibrant organic rosé, fresh and easy-drinking.',
 'Органическое розовое с ярким цветом, свежее и лёгкое.',
 7.00, TRUE, 5),

('Cà Grande Romagnia DOC Sangiovese Superiore', 'Umani Ronchi', 'Romagna', 'Sangiovese', 'rosso', 'fermo',
 'Sangiovese romagnolo di carattere, con note di ciliegia e spezie.',
 'Characterful Romagna Sangiovese with cherry and spice notes.',
 'Характерный Санджовезе Романьи с нотами вишни и специй.',
 6.00, TRUE, 7),

('Ape Pinot Nero / Romagna DOC Sangiovese Superiore', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosso', 'fermo',
 'Sangiovese superiore, elegante e fruttato.',
 'Superior Sangiovese, elegant and fruity.',
 'Превосходный Санджовезе, элегантный и фруктовый.',
 6.00, TRUE, 6),

('Ape Gutturnio Superiore DOC BIO', 'Romagnoli', 'Piacenza', 'Barbera 60%, Croatina 40%', 'rosso', 'fermo',
 'Gutturnio biologico, vino rosso tipico piacentino, morbido e profumato.',
 'Organic Gutturnio, typical Piacenza red wine, soft and fragrant.',
 'Органический Гуттурнио — типичное красное вино Пьяченцы, мягкое и ароматное.',
 7.00, TRUE, 6),

('Centovie Montepulciano d''Abruzzo DOC BIO', 'Romagnoli', 'Abruzzo', 'Montepulciano', 'rosso', 'fermo',
 'Montepulciano biologico, rosso corposo e caldo del centro Italia.',
 'Organic Montepulciano, full-bodied warm red from central Italy.',
 'Органический Монтепульчано — насыщенное тёплое красное из Центральной Италии.',
 6.00, TRUE, 6),

('Crocifero Sangiovese / Colli Fiorentini DOCG', 'Torre a Cona', 'Toscana', 'Sangiovese 90%, Colorino 10%', 'rosso', 'fermo',
 'Sangiovese toscano, elegante e strutturato con note di prugna e vaniglia.',
 'Tuscan Sangiovese, elegant and structured with plum and vanilla notes.',
 'Тосканский Санджовезе, элегантный и структурированный с нотами сливы и ванили.',
 6.00, TRUE, 7),

('Umani Ronchi Roseto degli Abruzzi', 'Umani Ronchi', 'Abruzzo', 'Montepulciano', 'rosso', 'fermo',
 'Rosso abruzzese robusto, caldo e persistente.',
 'Robust Abruzzo red, warm and persistent.',
 'Насыщенное красное из Абруццо, тёплое и длительное.',
 7.00, TRUE, 5);

-- ═══════════════════════════════════════════════════
-- VINI DELL'EMILIA ROMAGNA — бутылки (page 10-11)
-- ═══════════════════════════════════════════════════

INSERT INTO wines (name, producer, region, grape, color, style, description_it, description_en, description_ru, price_bottle, is_active, sort_order) VALUES

('I Calanchi Lambrusco Bio Colli di Parma DOC', 'Monte delle Vigne', 'Parma', 'Lambrusco', 'rosso', 'frizzante',
 'Lambrusco biologico locale, il compagno ideale dei salumi parmigiani.',
 'Local organic Lambrusco, the ideal companion for Parma cold cuts.',
 'Местный органический Ламбруско — идеальный компаньон для пармских деликатесов.',
 18.00, TRUE, 10),

('Otello Lambrusco IGT Emilia', 'Ceci', 'Emilia', 'Lambrusco Maestri', 'rosso', 'frizzante',
 'Lambrusco classico emiliano, fresco e beverino.',
 'Classic Emilian Lambrusco, fresh and easy-drinking.',
 'Классический эмилианский Ламбруско, свежий и лёгкий.',
 16.00, TRUE, 8),

('Terre Verdiane Lambrusco Emilia IGT', 'Ceci', 'Emilia', 'Lambrusco', 'rosso', 'frizzante',
 'Lambrusco secco, vivace con note di frutti rossi.',
 'Dry Lambrusco, lively with red fruit notes.',
 'Сухой Ламбруско, игривый с нотами красных фруктов.',
 16.00, TRUE, 7),

('Fortanna "La Luna" Fortana Emilia IGT', 'Ceci', 'Emilia', 'Fortana', 'rosso', 'frizzante',
 'Vino frizzante leggero e originale da uva Fortana.',
 'Light and original sparkling wine from Fortana grape.',
 'Лёгкое и оригинальное игристое из винограда Фортана.',
 16.00, TRUE, 6),

('Callas Malvasia di Candia Aromatica IGT', 'Monte delle Vigne', 'Parma', 'Malvasia di Candia Aromatica', 'bianco', 'fermo',
 'Malvasia ferma aromatica, elegante e floreale.',
 'Still aromatic Malvasia, elegant and floral.',
 'Тихая ароматная Мальвазия, элегантная и цветочная.',
 24.00, TRUE, 9),

('Ape Chardonnay / Emilia IGT bottiglia', 'Romagnoli', 'Emilia', 'Chardonnay', 'bianco', 'fermo',
 'Chardonnay emiliano fresco, ideale con pesce e antipasti.',
 'Fresh Emilian Chardonnay, ideal with fish and starters.',
 'Свежее эмилианское Шардоне, идеально к рыбе и закускам.',
 28.00, TRUE, 7),

('Costa di Rose Sangiovese Rubicone IGT', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosato', 'fermo',
 'Rosato fermo da Sangiovese, fresco e gastronomico.',
 'Still Sangiovese rosé, fresh and food-friendly.',
 'Тихое розовое из Санджовезе, свежее и гастрономическое.',
 25.00, TRUE, 7),

('Il Chiu So Riserva Emilia IGT BIO', 'Monte delle Vigne', 'Parma', 'Cabernet Franc', 'rosso', 'fermo',
 'Cabernet Franc biologico, elegante e complesso con note di peperone e mora.',
 'Organic Cabernet Franc, elegant and complex with pepper and blackberry notes.',
 'Органический Каберне Фран, элегантный и сложный с нотами перца и ежевики.',
 26.00, TRUE, 9),

('Nabucco Emilia IGT BIO', 'Monte delle Vigne', 'Parma', 'Barbera, Merlot', 'rosso', 'fermo',
 'Blend biologico locale potente e strutturato.',
 'Powerful and structured local organic blend.',
 'Мощный и структурированный местный органический купаж.',
 38.00, TRUE, 8),

('Valnuraia Merlot / Emilia IGT', 'Romagnoli', 'Emilia', 'Merlot', 'rosso', 'fermo',
 'Merlot emiliano morbido e vellutato.',
 'Soft and velvety Emilian Merlot.',
 'Мягкое и бархатистое эмилианское Мерло.',
 22.00, TRUE, 7),

('Cà Grande Sangiovese Superiore bottiglia', 'Romagnoli', 'Romagna', 'Sangiovese', 'rosso', 'fermo',
 'Sangiovese Superiore di carattere, rosso vivace della Romagna.',
 'Characterful Superiore Sangiovese, lively Romagna red.',
 'Характерный Санджовезе Суперьоре — живое красное Романьи.',
 24.00, TRUE, 8),

('Laurento Romagna DOC Sangiovese Riserva', 'Umberto Cesari', 'Romagna', 'Sangiovese', 'rosso', 'fermo',
 'Sangiovese Riserva, vino rosso elegante e longevo.',
 'Sangiovese Riserva, elegant and age-worthy red wine.',
 'Санджовезе Резерва — элегантное красное вино с потенциалом выдержки.',
 26.00, TRUE, 8);

-- ═══════════════════════════════════════════════════
-- VINI BIANCHI ITALIANI — бутылки (page 12-13)
-- ═══════════════════════════════════════════════════

INSERT INTO wines (name, producer, region, grape, color, style, description_it, description_en, description_ru, price_bottle, is_active, sort_order) VALUES

('Floreado Sauvignon Blanc Alto Adige DOC', 'Andrian', 'Alto Adige', 'Sauvignon Blanc', 'bianco', 'fermo',
 'Sauvignon Blanc altoatesino, aromatico e minerale con note di sambuco.',
 'Alto Adige Sauvignon Blanc, aromatic and mineral with elderflower notes.',
 'Южнотирольский Совиньон Блан, ароматный и минеральный с нотами бузины.',
 26.00, TRUE, 8),

('Somdretto Chardonnay Alto Adige DOC', 'Andrian', 'Alto Adige', 'Chardonnay', 'bianco', 'fermo',
 'Chardonnay elegante dell''Alto Adige, fresco e complesso.',
 'Elegant Alto Adige Chardonnay, fresh and complex.',
 'Элегантное Шардоне из Альто-Адидже, свежее и сложное.',
 26.00, TRUE, 7),

('Abbazia di Rosazzo DOCG', 'Livio Felluga', 'Friuli', 'Friulano, Sauvignon, Pinot Bianco, Malvasia, Ribolla Gialla', 'bianco', 'fermo',
 'Grande bianco friulano, blend di vitigni autoctoni. Struttura e complessità eccezionali.',
 'Great Friulian white, blend of native varieties. Exceptional structure and complexity.',
 'Великое фриульское белое из местных сортов. Исключительная структура и сложность.',
 120.00, TRUE, 10),

('Plenio Verdicchio dei Castelli di Jesi DOCG Riserva BIO bottiglia', 'Umani Ronchi', 'Marche', 'Verdicchio', 'bianco', 'fermo',
 'Verdicchio biologico Riserva, uno dei migliori bianchi italiani.',
 'Organic Riserva Verdicchio, one of the best Italian whites.',
 'Органическое Резерва Вердиккио — одно из лучших итальянских белых вин.',
 32.00, TRUE, 9),

('Collezione Privata Chardonnay / Toscana IGT', 'Isole e Olena', 'Toscana', 'Chardonnay', 'bianco', 'fermo',
 'Chardonnay toscano di altissima qualità, elegante e persistente.',
 'Highest quality Tuscan Chardonnay, elegant and persistent.',
 'Тосканское Шардоне высочайшего качества, элегантное и длительное.',
 90.00, TRUE, 9),

('Alta Mora Etna Bianco DOC', 'Cusumano', 'Sicilia', 'Carricante', 'bianco', 'fermo',
 'Bianco etneo da Carricante, vulcanico e minerale con grande personalità.',
 'Etna white from Carricante, volcanic and mineral with great personality.',
 'Этнейское белое из Карриканте — вулканическое и минеральное с сильным характером.',
 36.00, TRUE, 8),

('Cinque Terre DOC', 'Terenzuola', 'Liguria', 'Bianco Bosco, Vermentino, Albarola, Russese', 'bianco', 'fermo',
 'Bianco ligure delle Cinque Terre, fresco e sapido con note marine.',
 'Ligurian Cinque Terre white, fresh and savory with sea notes.',
 'Лигурийское белое Чинкве Терре — свежее и пикантное с морскими нотами.',
 38.00, TRUE, 7);

-- ═══════════════════════════════════════════════════
-- VINI ROSSI ITALIANI — бутылки (page 14-18)
-- ═══════════════════════════════════════════════════

INSERT INTO wines (name, producer, region, grape, color, style, description_it, description_en, description_ru, price_bottle, is_active, sort_order) VALUES

('Monclivio Barolo DOCG', 'Colombo Sormani', 'Piemonte', 'Nebbiolo', 'rosso', 'fermo',
 'Barolo, il re dei vini italiani. Potente, tannico e longevo.',
 'Barolo, the king of Italian wines. Powerful, tannic and age-worthy.',
 'Бароло — король итальянских вин. Мощное, танинное, созданное для выдержки.',
 30.00, TRUE, 10),

('Chianti Classico DOCG', 'Castellare', 'Toscana', 'Sangiovese, Canaiolo', 'rosso', 'fermo',
 'Chianti Classico elegante, il simbolo del vino toscano.',
 'Elegant Chianti Classico, the symbol of Tuscan wine.',
 'Элегантный Кьянти Классико — символ тосканского вина.',
 39.00, TRUE, 9),

('Brunello di Montalcino DOCG', 'Biondi Santi', 'Toscana', 'Sangiovese', 'rosso', 'fermo',
 'Brunello leggendario della storica cantina Biondi Santi. Grande vino da meditazione.',
 'Legendary Brunello from the historic Biondi Santi winery. A great meditation wine.',
 'Легендарное Брунелло от исторической кантины Бионди Санти. Великое вино для медитации.',
 220.00, TRUE, 10),

('Nobile di Montepulciano DOCG', 'Poliziano', 'Toscana', 'Prugnolo Gentile, Colorino, Merlot', 'rosso', 'fermo',
 'Nobile elegante e strutturato, perfetto con carni rosse e selvaggina.',
 'Elegant and structured Nobile, perfect with red meats and game.',
 'Элегантное и структурированное Нобиле — идеально к красному мясу и дичи.',
 37.00, TRUE, 9),

('Asinone Nobile di Montepulciano IGT', 'Poliziano', 'Toscana', 'Sangiovese', 'rosso', 'fermo',
 'Nobile di Montepulciano di grande carattere, cru aziendale.',
 'Great character Nobile di Montepulciano, estate single vineyard.',
 'Нобиле ди Монтепульчано с сильным характером, виноградник хозяйства.',
 90.00, TRUE, 9),

('Grattamacco Bolgheri Rosso Superiore DOC', 'Grattamacco', 'Toscana', 'Cab. Sauvignon, Merlot, Sangiovese', 'rosso', 'fermo',
 'Super Tuscan di Bolgheri, potente e internazionale.',
 'Super Tuscan from Bolgheri, powerful and international in style.',
 'Супер-Тоскана из Больгери — мощное международного стиля вино.',
 130.00, TRUE, 9),

('Gant Merlot Alto Adige DOC Riserva', 'Andrian', 'Alto Adige', 'Merlot', 'rosso', 'fermo',
 'Merlot Riserva altoatesino, elegante e speziato.',
 'Alto Adige Merlot Riserva, elegant and spiced.',
 'Мерло Резерва из Альто-Адидже — элегантное и пряное.',
 75.00, TRUE, 8),

('Tor di Lupo Lagrein DOC Riserva', 'Andrian', 'Alto Adige', 'Merlot', 'rosso', 'fermo',
 'Lagrein Riserva, vitigno autoctono altoatesino. Scuro e vellutato.',
 'Lagrein Riserva, native Alto Adige variety. Dark and velvety.',
 'Лагрейн Резерва — местный сорт Альто-Адидже. Тёмное и бархатистое.',
 75.00, TRUE, 8),

('Carapace Montefalco Sagrantino DOCG BIO', 'Tenuta Castelbuono', 'Umbria', 'Sagrantino', 'rosso', 'fermo',
 'Sagrantino potente e tannico, uno dei vini più strutturati d''Italia.',
 'Powerful and tannic Sagrantino, one of Italy''s most structured wines.',
 'Мощный и танинный Сагрантино — одно из самых структурированных вин Италии.',
 45.00, TRUE, 9),

('Campo San Giorgio Montepulciano 100% BIO', 'Umani Ronchi', 'Marche', 'Montepulciano', 'rosso', 'fermo',
 'Montepulciano biologico puro, rosso caldo e avvolgente.',
 'Pure organic Montepulciano, warm and enveloping red.',
 'Чистый органический Монтепульчано — тёплое и обволакивающее красное.',
 58.00, TRUE, 8),

('Guardiola Etna Rosso DOC Riserva', 'Cusumano', 'Sicilia', 'Nerello Mascalese', 'rosso', 'fermo',
 'Etna Rosso Riserva da Nerello Mascalese, vulcanico e minerale.',
 'Etna Rosso Riserva from Nerello Mascalese, volcanic and mineral.',
 'Этна Россо Резерва из Нерелло Маскалезе — вулканическое и минеральное.',
 58.00, TRUE, 8),

('Primitivo di Manduria Rosso del Salento IGT', 'Rosa del Golfo', 'Puglia', 'Primitivo', 'rosso', 'fermo',
 'Primitivo pugliese, caldo e avvolgente con note di ciliegia nera e cioccolato.',
 'Puglian Primitivo, warm and enveloping with black cherry and chocolate notes.',
 'Пульезе Примитиво — тёплое и обволакивающее с нотами тёмной вишни и шоколада.',
 19.00, TRUE, 7);

-- ═══════════════════════════════════════════════════
-- GRANDI VINI (page 3) — только самые топовые
-- ═══════════════════════════════════════════════════

INSERT INTO wines (name, producer, region, grape, color, style, description_it, description_en, description_ru, price_bottle, is_active, sort_order) VALUES

('Giulio Ferrari Riserva del Fondatore', 'Ferrari', 'Trentino', 'Chardonnay', 'bianco', 'spumante',
 'Il più grande spumante italiano. Millesimato da singola vigna, affinato per oltre 10 anni.',
 'Italy''s greatest sparkling wine. Vintage from a single vineyard, aged over 10 years.',
 'Величайшее итальянское игристое. Миллезимированное из одного виноградника, выдержанное более 10 лет.',
 200.00, TRUE, 10),

('Historical Verdicchio dei Castelli di Jesi Classico Superiore BIO', 'Umani Ronchi', 'Marche', 'Verdicchio', 'bianco', 'fermo',
 'Verdicchio biologico Classico Superiore, minerale e longevo.',
 'Organic Classico Superiore Verdicchio, mineral and age-worthy.',
 'Органическое Классико Суперьоре Вердиккио — минеральное с потенциалом выдержки.',
 56.00, TRUE, 9),

('Livio Felluga Rosazzo DOCG', 'Livio Felluga', 'Friuli', 'Malvasia Istriana, Ribolla Gialla', 'bianco', 'fermo',
 'Bianco friulano di riferimento, elegante e complesso.',
 'Reference Friulian white, elegant and complex.',
 'Эталонное фриульское белое — элегантное и сложное.',
 120.00, TRUE, 9);

-- ═══════════════════════════════════════════════════
-- ПРАВИЛА ПОДБОРА (wine_pairings)
-- ═══════════════════════════════════════════════════

-- Логика:
-- meat (is_meat=true) → красные fermo, особенно Sangiovese, Montepulciano, Barolo
-- fish (is_fish=true) → белые fermo, Verdicchio, Sauvignon, Chardonnay
-- vegetarian → белые frizzante, Malvasia, Lambrusco (универсально)
-- vegan → то же что vegetarian
-- antipasti → игристые, frizzante, rosato
-- gourmet → более сложные и дорогие вина

-- ── БЕЛЫЕ (рыба, морепродукты, вегетарианское) ──

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'fish', NULL, NULL, 9 FROM wines WHERE name LIKE '%Verdicchio%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'fish', NULL, NULL, 8 FROM wines WHERE name LIKE '%Sauvignon%' OR name LIKE '%Floread%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'fish', NULL, NULL, 8 FROM wines WHERE name LIKE '%Chardonnay%' OR name LIKE '%Ape Chardonnay%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'fish', NULL, NULL, 7 FROM wines WHERE name LIKE '%Genestra%' OR name LIKE '%Malvasia%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'fish', NULL, NULL, 9 FROM wines WHERE name LIKE '%Cinque Terre%' OR name LIKE '%Alta Mora%' AND color = 'bianco';

-- ── ВЕГЕТАРИАНСКОЕ ──

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'vegetarian', NULL, NULL, 9 FROM wines WHERE name LIKE '%Malvasia%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'vegetarian', NULL, NULL, 8 FROM wines WHERE name LIKE '%Lambrusco%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'vegetarian', NULL, NULL, 7 FROM wines WHERE color = 'bianco' AND style = 'fermo';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'vegetarian', NULL, NULL, 7 FROM wines WHERE color = 'rosato';

-- ── МЯСО (tradizione) ──

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'tradizione', 10 FROM wines WHERE name LIKE '%Lambrusco%' AND style = 'frizzante';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'tradizione', 9 FROM wines WHERE name LIKE '%Sangiovese%' OR name LIKE '%Cà Grande%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'tradizione', 9 FROM wines WHERE name LIKE '%Rosso Colli di Parma%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'tradizione', 8 FROM wines WHERE name LIKE '%Barbera%' OR name LIKE '%Gutturnio%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'tradizione', 8 FROM wines WHERE name LIKE '%Montepulciano%';

-- ── МЯСО (gourmet) — более сложные вина ──

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'gourmet', 10 FROM wines WHERE name LIKE '%Barolo%' OR name LIKE '%Brunello%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'gourmet', 10 FROM wines WHERE name LIKE '%Chianti Classico%' OR name LIKE '%Nobile%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'gourmet', 9 FROM wines WHERE name LIKE '%Grattamacco%' OR name LIKE '%Carapace%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'meat', NULL, 'gourmet', 9 FROM wines WHERE name LIKE '%Sagrantino%' OR name LIKE '%Guardiola%';

-- ── ANTIPASTI (универсально — игристые и frizzante) ──

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'any', 'antipasti', NULL, 10 FROM wines WHERE style = 'spumante';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'any', 'antipasti', NULL, 9 FROM wines WHERE style = 'frizzante';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'any', 'antipasti', NULL, 8 FROM wines WHERE color = 'rosato';

-- ── УНИВЕРСАЛЬНЫЕ ВИНА (подходят ко всему) ──

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'any', NULL, NULL, 7 FROM wines WHERE name LIKE '%Malvasia Frizzante%';

INSERT INTO wine_pairings (wine_id, dish_type, category, menu_type, score)
SELECT id, 'any', NULL, NULL, 7 FROM wines WHERE name LIKE '%Lambrusco%' AND is_house_wine = TRUE;
