SET client_encoding = 'UTF8';

-- Убираем can_adapt у Tortelli di Erbetta
UPDATE dishes SET can_adapt = NULL WHERE name_it = 'Tortelli di Erbetta';

-- Убираем adapt_note из переводов
UPDATE dish_translations SET adapt_note = NULL
WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Tortelli di Erbetta');
