SET client_encoding = 'UTF8';

-- Battuta di Capriolo
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Tartare di capriolo servita con topinambur in tre consistenze, nocciole tostate e cipolla rossa'
  WHEN 'en' THEN 'Venison tartare served with Jerusalem artichoke in three textures, toasted hazelnuts and red onion'
  WHEN 'ru' THEN 'Тартар из косули, поданный с тремя видами топинамбура, жареным фундуком и красным луком'
  WHEN 'de' THEN 'Reh-Tatar serviert mit Topinambur in drei Konsistenzen, gerösteten Haselnüssen und roter Zwiebel'
  WHEN 'fr' THEN 'Tartare de chevreuil servi avec topinambour en trois textures, noisettes grillées et oignon rouge'
  WHEN 'es' THEN 'Tartar de corzo servido con tupinambo en tres texturas, avellanas tostadas y cebolla roja'
  WHEN 'uk' THEN 'Тартар з косулі, поданий з трьома видами топінамбуру, смаженим фундуком та червоною цибулею'
  WHEN 'zh' THEN '鹿肉鞑靼，配三种质地的菊芋、烤榛子和红洋葱'
  WHEN 'ja' THEN '鹿肉タルタル、三種の食感のキクイモ、ローストヘーゼルナッツ、赤玉ねぎ添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Battuta di Capriolo');

-- Uovo Fritto alla Scozzese
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Uovo sodo passato in pastella e fritto, adagiato su un nido di salicornia con fonduta di parmigiano'
  WHEN 'en' THEN 'Hard-boiled egg coated in batter and deep-fried, resting on a salicornia nest with parmesan fondue'
  WHEN 'ru' THEN 'Варёное яйцо в кляре, обжаренное во фритюре, лежащее на гнезде из салькорнии с фондю из пармезана'
  WHEN 'de' THEN 'Hartgekochtes Ei in Teig frittiert, auf einem Salicornia-Nest mit Parmesanfondue'
  WHEN 'fr' THEN 'Oeuf dur enrobé et frit, posé sur un nid de salicorne avec fondue de parmesan'
  WHEN 'es' THEN 'Huevo duro en rebozado y frito, sobre un nido de salicornia con fondue de parmesano'
  WHEN 'uk' THEN 'Варене яйце в клярі, обсмажене у фритюрі, на гнізді з салькорнії з фондю з пармезану'
  WHEN 'zh' THEN '裹粉炸熟鸡蛋，置于海蓬子巢上，配帕尔马干酪火锅'
  WHEN 'ja' THEN '衣をつけて揚げたゆで卵、サリコルニアの巣の上にパルメザンフォンデュ添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Uovo Fritto alla Scozzese');

-- Melanzana Gallo D'Oro
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Melanzane al forno condite con mozzarella e pomodorini confit'
  WHEN 'en' THEN 'Oven-baked aubergines seasoned with mozzarella and confit cherry tomatoes'
  WHEN 'ru' THEN 'Запечённые баклажаны, заправленные моцареллой и помидорами конфи'
  WHEN 'de' THEN 'Ofengebackene Auberginen mit Mozzarella und Kirschtomaten-Confit'
  WHEN 'fr' THEN 'Aubergines au four avec mozzarella et tomates cerises confites'
  WHEN 'es' THEN 'Berenjenas al horno con mozzarella y tomates cherry confitados'
  WHEN 'uk' THEN 'Запечені баклажани з моцарелою та помідорами конфі'
  WHEN 'zh' THEN '烤茄子配马苏里拉奶酪和糖渍樱桃番茄'
  WHEN 'ja' THEN 'オーブン焼きナス、モッツァレラとコンフィのミニトマト添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Melanzana Gallo D''Oro');

-- Cozze al Vapore
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Cozze al vapore con crema di fagioli cannellini, pomodorini confit e olive taggiasche'
  WHEN 'en' THEN 'Steamed mussels with cannellini bean cream, confit cherry tomatoes and taggiasca olives'
  WHEN 'ru' THEN 'Мидии на пару с кремом из бобов каннеллини, конфи из помидоров черри и оливками тальяске'
  WHEN 'de' THEN 'Gedämpfte Muscheln mit Cannellini-Bohnencreme, Kirschtomaten-Confit und Taggiasca-Oliven'
  WHEN 'fr' THEN 'Moules à la vapeur avec crème de haricots cannellini, tomates cerises confites et olives taggiasca'
  WHEN 'es' THEN 'Mejillones al vapor con crema de alubias cannellini, tomates cherry confitados y aceitunas taggiasca'
  WHEN 'uk' THEN 'Мідії на парі з кремом із квасолі каннелліні, конфі з помідорів черрі та оливками тальяске'
  WHEN 'zh' THEN '清蒸贻贝配白芸豆奶油、糖渍樱桃番茄和塔加斯卡橄榄'
  WHEN 'ja' THEN '蒸しムール貝、カネッリーニ豆クリーム、コンフィのミニトマト、タッジャスケオリーブ添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Cozze al Vapore');

-- Punta di Vitello Ripiena
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Fetta di vitello farcita con pane secco, parmigiano e uovo, servita con patate arrosto'
  WHEN 'en' THEN 'Veal slice stuffed with dry bread, parmesan and egg, served with roast potatoes'
  WHEN 'ru' THEN 'Ломоть телятины, фаршированный смесью из сухого хлеба, пармезана и яйца, подаётся с жареным картофелем'
  WHEN 'de' THEN 'Kalbsscheibe gefüllt mit trockenem Brot, Parmesan und Ei, mit Bratkartoffeln'
  WHEN 'fr' THEN 'Tranche de veau farcie de pain sec, parmesan et oeuf, servie avec pommes de terre rôties'
  WHEN 'es' THEN 'Loncha de ternera rellena de pan seco, parmesano y huevo, con patatas asadas'
  WHEN 'uk' THEN 'Скибка телятини, фарширована сухим хлібом, пармезаном та яйцем, з смаженою картоплею'
  WHEN 'zh' THEN '小牛肉片填入干面包、帕尔马干酪和鸡蛋，配烤土豆'
  WHEN 'ja' THEN '子牛の薄切り肉にドライブレッド・パルメザン・卵を詰め、ロースト・ポテト添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Punta di Vitello Ripiena');

-- Pesto di Cavallo
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Tartare di carne di cavallo (disponibile anche scottata), con salsa di miele, senape e cucunci'
  WHEN 'en' THEN 'Horse meat tartare (also available seared), with honey, mustard and caper berry sauce'
  WHEN 'ru' THEN 'Тартар из конины (также подаётся обжаренным), с соусом из мёда, горчицы и каперсов'
  WHEN 'de' THEN 'Pferdefleisch-Tatar (auch angebraten), mit Honig-Senf-Kapern-Sauce'
  WHEN 'fr' THEN 'Tartare de cheval (aussi disponible saisi), avec sauce miel, moutarde et câpres'
  WHEN 'es' THEN 'Tartar de caballo (también sellado), con salsa de miel, mostaza y alcaparras'
  WHEN 'uk' THEN 'Тартар з конини (також обсмажений), з соусом із меду, гірчиці та каперсів'
  WHEN 'zh' THEN '马肉鞑靼（也可煎烤），配蜂蜜芥末刺山柑酱'
  WHEN 'ja' THEN '馬肉タルタル（焼いても可）、ハチミツ・マスタード・ケッパーソース添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Pesto di Cavallo');

-- Tagliata di Manzo
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Classico steak di manzo con cime di rapa, patate arrosto e maionese alla senape'
  WHEN 'en' THEN 'Classic beef steak with turnip tops, roast potatoes and mustard mayonnaise'
  WHEN 'ru' THEN 'Классический стейк из говядины с ботвой репы, жареным картофелем и горчичным майонезом'
  WHEN 'de' THEN 'Klassisches Rindersteak mit Rübenblättern, Bratkartoffeln und Senfmayonnaise'
  WHEN 'fr' THEN 'Steak de boeuf classique avec brocoli rave, pommes de terre rôties et mayonnaise à la moutarde'
  WHEN 'es' THEN 'Clásico steak de ternera con grelos, patatas asadas y mayonesa de mostaza'
  WHEN 'uk' THEN 'Класичний стейк із яловичини з ботвою ріпи, смаженою картоплею та гірчичним майонезом'
  WHEN 'zh' THEN '经典牛排配萝卜叶、烤土豆和芥末蛋黄酱'
  WHEN 'ja' THEN 'クラシックな牛ステーキ、カブの葉・ロースト・ポテト・マスタードマヨネーズ添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Tagliata di Manzo');

-- Vecchia di Cavallo
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Carne macinata di cavallo fritta servita con peperoni, patate e pomodori'
  WHEN 'en' THEN 'Fried minced horse meat served with peppers, potatoes and tomatoes'
  WHEN 'ru' THEN 'Жареный фарш из конины, поданный с перцами, картофелем и помидорами'
  WHEN 'de' THEN 'Gebratenes Pferdefleisch-Hackfleisch mit Paprika, Kartoffeln und Tomaten'
  WHEN 'fr' THEN 'Viande de cheval hachée frite avec poivrons, pommes de terre et tomates'
  WHEN 'es' THEN 'Carne picada de caballo frita con pimientos, patatas y tomates'
  WHEN 'uk' THEN 'Смажений фарш з конини з перцями, картоплею та помідорами'
  WHEN 'zh' THEN '炸马肉末配彩椒、土豆和番茄'
  WHEN 'ja' THEN '揚げた馬肉ひき肉、パプリカ・ジャガイモ・トマト添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Vecchia di Cavallo');

-- Piovra
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Polpo con crema di fagioli cannellini, pomodorini confit e olive taggiasche'
  WHEN 'en' THEN 'Octopus with cannellini bean cream, confit cherry tomatoes and taggiasca olives'
  WHEN 'ru' THEN 'Осьминог с кремом из бобов каннеллини, конфи из помидоров черри и оливками тальяске'
  WHEN 'de' THEN 'Oktopus mit Cannellini-Bohnencreme, Kirschtomaten-Confit und Taggiasca-Oliven'
  WHEN 'fr' THEN 'Poulpe avec crème de haricots cannellini, tomates cerises confites et olives taggiasca'
  WHEN 'es' THEN 'Pulpo con crema de alubias cannellini, tomates cherry confitados y aceitunas taggiasca'
  WHEN 'uk' THEN 'Восьминіг з кремом із квасолі каннелліні, конфі з помідорів черрі та оливками тальяске'
  WHEN 'zh' THEN '章鱼配白芸豆奶油、糖渍樱桃番茄和塔加斯卡橄榄'
  WHEN 'ja' THEN 'タコ、カネッリーニ豆クリーム、コンフィのミニトマト、タッジャスケオリーブ添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Piovra con Crema di Fagioli Cannellini');

-- Filetto di Ombrina
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Filetto di ombrina con patata schiacciata e infuso alla menta'
  WHEN 'en' THEN 'Sea bass fillet with crushed potato and mint infusion'
  WHEN 'ru' THEN 'Филе рыбы умбрина с толчёным картофелем и настоем мяты'
  WHEN 'de' THEN 'Meerbarsch-Filet mit zerdrückter Kartoffel und Minzaufguss'
  WHEN 'fr' THEN 'Filet de bar avec pomme de terre écrasée et infusion à la menthe'
  WHEN 'es' THEN 'Filete de corvina con patata aplastada e infusión de menta'
  WHEN 'uk' THEN 'Філе умбрини з товченою картоплею та настоєм м''яти'
  WHEN 'zh' THEN '石首鱼柳配压碎土豆和薄荷浸液'
  WHEN 'ja' THEN 'ウンブリーナの切り身、つぶしジャガイモとミントのインフュージョン添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Filetto di Ombrina');

-- Gallo D'Oro con Verdure Croccanti
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Pollo croccante con verdure croccanti di stagione e salsa Yuzu a base di soia'
  WHEN 'en' THEN 'Crispy chicken with seasonal crunchy vegetables and soy-based Yuzu sauce'
  WHEN 'ru' THEN 'Хрустящая курица с сезонными хрустящими овощами и соусом Юзу на основе сои'
  WHEN 'de' THEN 'Knuspriges Hähnchen mit knusprigem Saisongemüse und Yuzu-Sojasauce'
  WHEN 'fr' THEN 'Poulet croustillant avec légumes croustillants de saison et sauce Yuzu à base de soja'
  WHEN 'es' THEN 'Pollo crujiente con verduras crujientes de temporada y salsa Yuzu a base de soja'
  WHEN 'uk' THEN 'Хрустка курка з сезонними хрусткими овочами та соусом Юзу на основі сої'
  WHEN 'zh' THEN '脆皮鸡配时令脆蔬菜和大豆基底柚子酱'
  WHEN 'ja' THEN 'クリスピーチキン、旬のクリスピー野菜、大豆ベースのユズソース添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Gallo D''Oro con Verdure Croccanti');

-- Costolette d'Agnello
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Costolette di agnello in panure di pane panko con patate al forno'
  WHEN 'en' THEN 'Lamb cutlets in panko breadcrumbs with oven potatoes'
  WHEN 'ru' THEN 'Бараньи котлеты в панировке панко с картофелем в духовке'
  WHEN 'de' THEN 'Lammkoteletts in Panko-Panade mit Ofenkartoffeln'
  WHEN 'fr' THEN 'Côtelettes d''agneau en panure panko avec pommes de terre au four'
  WHEN 'es' THEN 'Chuletas de cordero en pan rallado panko con patatas al horno'
  WHEN 'uk' THEN 'Баранячі котлети в паніровці панко з картоплею в духовці'
  WHEN 'zh' THEN '面包糠裹羊排配烤土豆'
  WHEN 'ja' THEN 'パン粉パナードのラムチョップ、オーブンポテト添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Costolette d''Agnello');

-- Verdure Croccanti
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Verdure di stagione saltate in padella: finocchio, peperone, cavolfiore, sedano e zucchine'
  WHEN 'en' THEN 'Seasonal vegetables sautéed in a pan: fennel, pepper, cauliflower, celery and zucchini'
  WHEN 'ru' THEN 'Сезонные овощи, обжаренные на сковороде: фенхель, перец, цветная капуста, сельдерей и цуккини'
  WHEN 'de' THEN 'Saisonales Gemüse in der Pfanne: Fenchel, Paprika, Blumenkohl, Sellerie und Zucchini'
  WHEN 'fr' THEN 'Légumes de saison sautés: fenouil, poivron, chou-fleur, céleri et courgettes'
  WHEN 'es' THEN 'Verduras de temporada salteadas: hinojo, pimiento, coliflor, apio y calabacín'
  WHEN 'uk' THEN 'Сезонні овочі на сковороді: фенхель, перець, цвітна капуста, селера та цукіні'
  WHEN 'zh' THEN '季节蔬菜平底锅炒：茴香、彩椒、花椰菜、芹菜和西葫芦'
  WHEN 'ja' THEN '旬の野菜のソテー：フェンネル、パプリカ、カリフラワー、セロリ、ズッキーニ'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Verdure Croccanti di Stagione');

-- Crème Brulée
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Crème brûlée con crosta di zucchero caramellato, servita con gelato alla vaniglia a parte'
  WHEN 'en' THEN 'Crème brûlée with caramelised sugar crust, served with vanilla ice cream on the side'
  WHEN 'ru' THEN 'Крем-брюле с хрустящей карамельной корочкой, подаётся с ванильным мороженым отдельно'
  WHEN 'de' THEN 'Crème brûlée mit karamellisierter Zuckerkruste, mit Vanilleeis als Beilage'
  WHEN 'fr' THEN 'Crème brûlée avec croûte de sucre caramélisé, glace vanille à part'
  WHEN 'es' THEN 'Crème brûlée con costra de azúcar caramelizado, helado de vainilla aparte'
  WHEN 'uk' THEN 'Крем-брюле з хрусткою карамельною скоринкою, з ванільним морозивом окремо'
  WHEN 'zh' THEN '焦糖布丁配焦糖脆皮，香草冰淇淋另盘'
  WHEN 'ja' THEN 'カラメルシュガーの焦げ目のクレームブリュレ、バニラアイスクリームは別添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Crème Brulée alla Violetta di Parma');

-- Sbrisolona
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Torta sbrisolona con mandorle e mousse allo zabaione'
  WHEN 'en' THEN 'Sbrisolona almond cake with zabaione mousse'
  WHEN 'ru' THEN 'Твёрдый рассыпчатый торт сбризолона с миндалём и нежным муссом из забальоне'
  WHEN 'de' THEN 'Sbrisolona-Mandelkuchen mit Zabaione-Mousse'
  WHEN 'fr' THEN 'Gâteau sbrisolona aux amandes et mousse au zabaione'
  WHEN 'es' THEN 'Tarta sbrisolona de almendras con mousse de zabaione'
  WHEN 'uk' THEN 'Твердий розсипчастий торт сбризолона з мигдалем та муссом із забальоне'
  WHEN 'zh' THEN '杏仁碎粒蛋糕配萨巴雍慕斯'
  WHEN 'ja' THEN 'アーモンドのスブリゾローナケーキとザバイオーネムース'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Sbrisolona con Mousse di Zabaione');

-- Zuppa Inglese
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Specialità della casa: crema pasticcera, crema al cioccolato e biscotto imbevuto di liquore Alchermes'
  WHEN 'en' THEN 'House speciality: pastry cream, chocolate cream and sponge soaked in Alchermes liqueur'
  WHEN 'ru' THEN 'Фирменный десерт: крем пастичера, шоколадный крем и бисквит, пропитанный ликёром Алкермис'
  WHEN 'de' THEN 'Hausspezialität: Konditorcreme, Schokoladencreme und in Alchermes-Likör getränkter Biskuit'
  WHEN 'fr' THEN 'Spécialité maison: crème pâtissière, crème au chocolat et biscuit imbibé de liqueur Alchermes'
  WHEN 'es' THEN 'Especialidad de la casa: crema pastelera, crema de chocolate y bizcocho empapado en licor Alchermes'
  WHEN 'uk' THEN 'Фірмовий десерт: заварний крем, шоколадний крем та бісквіт, просочений лікером Алкермес'
  WHEN 'zh' THEN '招牌甜点：卡仕达奶油、巧克力奶油和浸过阿尔克尔梅斯利口酒的海绵蛋糕'
  WHEN 'ja' THEN 'ハウススペシャリティ：カスタードクリーム、チョコレートクリーム、アルケルメスリキュール浸けスポンジ'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Zuppa Inglese Gallo D''Oro');

-- Tortino di Mele
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Tortino di mele con crema pasticcera e cannella, gelato alla crema a parte'
  WHEN 'en' THEN 'Apple cake with pastry cream and cinnamon, cream ice cream on the side'
  WHEN 'ru' THEN 'Яблочный пирог с кремом пастичера и корицей, мороженое подаётся отдельно'
  WHEN 'de' THEN 'Apfelküchlein mit Konditorcreme und Zimt, Sahneis als Beilage'
  WHEN 'fr' THEN 'Gâteau aux pommes avec crème pâtissière et cannelle, glace à la crème à part'
  WHEN 'es' THEN 'Pastelito de manzana con crema pastelera y canela, helado de nata aparte'
  WHEN 'uk' THEN 'Яблучний пиріг з заварним кремом та корицею, морозиво подається окремо'
  WHEN 'zh' THEN '苹果蛋糕配卡仕达奶油和肉桂，奶油冰淇淋另盘'
  WHEN 'ja' THEN 'カスタードクリームとシナモンのアップルケーキ、クリームアイスクリームは別添え'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Tortino di Mele');

-- Sorbetto
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Sorbetto artigianale al limone fresco'
  WHEN 'en' THEN 'Artisanal fresh lemon sorbet'
  WHEN 'ru' THEN 'Ручной сорбет из свежего лимона'
  WHEN 'de' THEN 'Handwerkliches frisches Zitronensorbet'
  WHEN 'fr' THEN 'Sorbet artisanal au citron frais'
  WHEN 'es' THEN 'Sorbete artesanal de limón fresco'
  WHEN 'uk' THEN 'Ручний сорбет зі свіжого лимона'
  WHEN 'zh' THEN '手工新鲜柠檬冰沙'
  WHEN 'ja' THEN '手作りの新鮮なレモンシャーベット'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Sorbetto al Limone');

-- Tiramisù
UPDATE dish_translations SET description = CASE lang
  WHEN 'it' THEN 'Classico tiramisù fatto in casa'
  WHEN 'en' THEN 'Classic homemade tiramisù'
  WHEN 'ru' THEN 'Классическое домашнее тирамису'
  WHEN 'de' THEN 'Klassisches hausgemachtes Tiramisu'
  WHEN 'fr' THEN 'Classique tiramisu fait maison'
  WHEN 'es' THEN 'Clásico tiramisú casero'
  WHEN 'uk' THEN 'Класичне домашнє тірамісу'
  WHEN 'zh' THEN '经典家制提拉米苏'
  WHEN 'ja' THEN 'クラシックな手作りティラミス'
END WHERE dish_id = (SELECT id FROM dishes WHERE name_it = 'Tiramisù');

-- adapt_note fix для всех тортелли
UPDATE dish_translations SET adapt_note = CASE lang
  WHEN 'it' THEN 'Può essere preparato senza lattosio su richiesta'
  WHEN 'en' THEN 'Can be prepared lactose-free on request'
  WHEN 'ru' THEN 'Можно приготовить без лактозы по запросу'
  WHEN 'de' THEN 'Kann auf Wunsch laktosefrei zubereitet werden'
  WHEN 'fr' THEN 'Peut être préparé sans lactose sur demande'
  WHEN 'es' THEN 'Se puede preparar sin lactosa a petición'
  WHEN 'uk' THEN 'Можна приготувати без лактози на прохання'
  WHEN 'zh' THEN '可应要求制作无乳糖版本'
  WHEN 'ja' THEN 'ご要望によりラクトースフリーで調理可能'
END WHERE dish_id IN (
  SELECT id FROM dishes WHERE name_it IN (
    'Tortelli di Erbetta', 'Tortelli di Zucca', 'Tortelli di Patate', 'Tris di Tortelli'
  )
) AND adapt_note IS NOT NULL;
