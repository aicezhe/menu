INSERT INTO dish_translations (dish_id, lang, name, description, adapt_note)
SELECT 13, 'it', 'Tortelli di Erbetta', 'Con burro fuso e Parmigiano Reggiano', NULL
WHERE NOT EXISTS (
    SELECT 1 FROM dish_translations WHERE dish_id = 13 AND lang = 'it'
);
