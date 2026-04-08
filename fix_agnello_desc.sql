SET client_encoding = 'UTF8';

UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Agnello con patate al forno'
  WHEN 'en' THEN 'Lamb with oven potatoes'
  WHEN 'ru' THEN 'Ягнёнок с картофелем в духовке'
  WHEN 'de' THEN 'Lamm mit Ofenkartoffeln'
  WHEN 'fr' THEN 'Agneau avec pommes de terre au four'
  WHEN 'es' THEN 'Cordero con patatas al horno'
  WHEN 'uk' THEN 'Ягня з картоплею в духовці'
  WHEN 'zh' THEN '烤箱土豆配羊肉'
  WHEN 'ja' THEN 'オーブンポテト添えラム'
END WHERE dish_id = 32;
