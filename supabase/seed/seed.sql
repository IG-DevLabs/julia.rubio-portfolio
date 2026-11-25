-- =====================================================================
-- JÚLIA RUBIO PORTFOLIO CMS - INITIAL SEED DATA
-- Migrates all 36 projects, categories, PROC process blocks and featured list
-- =====================================================================

-- Categories seed
INSERT INTO public.categories (slug, name, name_pt, name_en, display_order)
VALUES
    ('branding', 'Branding', 'Branding', 'Branding', 1),
    ('packaging', 'Packaging', 'Embalagens', 'Packaging', 2),
    ('web', 'Web', 'Web', 'Web', 3),
    ('illustration', 'Illustration', 'Ilustração', 'Illustration', 4),
    ('social', 'Social Media', 'Social Media', 'Social Media', 5),
    ('editorial', 'Editorial', 'Editorial', 'Editorial', 6)
ON CONFLICT (slug) DO UPDATE SET
    name = EXCLUDED.name,
    name_pt = EXCLUDED.name_pt,
    name_en = EXCLUDED.name_en,
    display_order = EXCLUDED.display_order;

-- Site Settings seed
INSERT INTO public.site_settings (key, value)
VALUES
    ('general', '{"title": "Júlia Rubio · Designer Gráfica", "email": "juliacrubio51@gmail.com", "instagram": "https://www.instagram.com/juu_rubio/", "behance": "https://www.behance.net/juliacosta55", "location": "Sorocaba, SP — Brasil"}'::jsonb),
    ('featured_selection', '["shelly-and-co","vondel","pouse","tecnofit","senda","ninjo","the-acting-garage","helia","prima"]'::jsonb)
ON CONFLICT (key) DO UPDATE SET
    value = EXCLUDED.value;

-- Projects seed

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    80,
    'oliva',
    'Oliva',
    '2025',
    'Focacceria · Buenos Aires',
    'Focaccería · Buenos Aires',
    ARRAY['branding']::text[],
    'assets/images/projects/p80_1.webp',
    'Oliva | brand proposal for a focacceria 🫒

A new artisanal focacceria in Buenos Aires, inspired by the Italian bakeries of the Mediterranean.

A bold serif wordmark signed with a hand-written script, a palette of Mediterranean blue and cream, and a set of hand-cut illustrations of olives, bread, cheese and everything that goes on the table — brought to life across the counter, uniforms, coasters, menus and stickers.

Pan, aceite y mucha focaccia.',
    'Oliva | brand proposal for a focacceria 🫒

A new artisanal focacceria in Buenos Aires, inspired by the Italian bakeries of the Mediterranean.

A bold serif wordmark signed with a hand-written script, a palette of Mediterranean blue and cream, and a set of hand-cut illustrations of olives, bread, cheese and everything that goes on the table — brought to life across the counter, uniforms, coasters, menus and stickers.

Pan, aceite y mucha focaccia.',
    '',
    'published',
    false,
    NULL,
    1,
    '[{"type":"i","url":"assets/images/projects/p80_0.webp"},{"type":"i","url":"assets/images/projects/p80_1.webp"},{"type":"i","url":"assets/images/projects/p80_2.webp"},{"type":"i","url":"assets/images/projects/p80_3.webp"},{"type":"i","url":"assets/images/projects/p80_4.webp"},{"type":"i","url":"assets/images/projects/p80_5.webp"},{"type":"i","url":"assets/images/projects/p80_6.webp"},{"type":"i","url":"assets/images/projects/p80_7.webp"},{"type":"i","url":"assets/images/projects/p80_8.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/oliva2_0.webp","assets/images/boards/c/oliva2_1.webp"],"skip":[],"en":[["The challenge","Oliva is a new artisanal focacceria arriving in Buenos Aires. It needed a brand that felt Mediterranean and handmade, but also fresh and contemporary enough to stand out in a city full of bakeries."],["The concept","<b>“Pan, aceite y mucha focaccia.”</b> The warmth of an Italian bakery by the sea — olive oil, good bread and long tables — translated into a confident, simple brand that invites you to sit down and stay."],["The system","A bold serif wordmark signed with a hand-written script, framed and unframed versions for signage, a palette of Mediterranean blue and cream, and a set of hand-cut illustrations of everything that goes on the table — applied to the counter, uniforms, coasters, menus, the soda siphon and stickers."]],"es":[["El desafío","Oliva es una nueva focaccería artesanal que llega a Buenos Aires. Necesitaba una marca que se sintiera mediterránea y hecha a mano, pero también fresca y contemporánea para destacarse en una ciudad llena de panaderías."],["El concepto","<b>“Pan, aceite y mucha focaccia.”</b> La calidez de una panadería italiana frente al mar —aceite de oliva, buen pan y mesas largas— traducida en una marca simple y segura que invita a sentarse y quedarse."],["El sistema","Un wordmark serif con peso, firmado con una script escrita a mano, versiones con y sin recuadro para la cartelería, una paleta de azul mediterráneo y crema, y una serie de ilustraciones recortadas de todo lo que va a la mesa, aplicado al mostrador, los uniformes, los posavasos, los menús, el sifón y los stickers."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    60,
    'prima',
    'Prima',
    '2026',
    'Tiramisù brand · Buenos Aires',
    'Marca de tiramisù · Buenos Aires',
    ARRAY['branding','packaging']::text[],
    'assets/images/projects/p60_10.webp',
    'Prima | The Tiramisù Society 🍰
Brand kit & packaging for Prima, a Buenos Aires tiramisù brand born from a family story, shared recipes and those long sobremesas we never want to end.

Inspired by their Italian roots, Prima reinvents the classic tiramisù as a ritual of indulgence — because treating yourself doesn’t need a special occasion. Pleasure is the occasion.

We built a warm, playful and premium universe: a hand-lettered script logotype with a society seal, a palette of deep bordeaux, ivory, soft pink, blue and yellow, and a family of patterns — waves, harlequin and ladyfingers — that wrap tins, boxes, bags and every detail of the experience.

Primero, lo dulce.',
    'Prima | The Tiramisù Society 🍰
Brand kit & packaging for Prima, a Buenos Aires tiramisù brand born from a family story, shared recipes and those long sobremesas we never want to end.

Inspired by their Italian roots, Prima reinvents the classic tiramisù as a ritual of indulgence — because treating yourself doesn’t need a special occasion. Pleasure is the occasion.

We built a warm, playful and premium universe: a hand-lettered script logotype with a society seal, a palette of deep bordeaux, ivory, soft pink, blue and yellow, and a family of patterns — waves, harlequin and ladyfingers — that wrap tins, boxes, bags and every detail of the experience.

Primero, lo dulce.',
    '',
    'published',
    true,
    9,
    2,
    '[{"type":"i","url":"assets/images/projects/p60_0.webp"},{"type":"i","url":"assets/images/projects/p60_1.webp"},{"type":"i","url":"assets/images/projects/p60_2.webp"},{"type":"i","url":"assets/images/projects/p60_3.webp"},{"type":"i","url":"assets/images/projects/p60_4.webp"},{"type":"i","url":"assets/images/projects/p60_5.webp"},{"type":"i","url":"assets/images/projects/p60_6.webp"},{"type":"i","url":"assets/images/projects/p60_7.webp"},{"type":"i","url":"assets/images/projects/p60_8.webp"},{"type":"i","url":"assets/images/projects/p60_9.webp"},{"type":"i","url":"assets/images/projects/p60_10.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/prima_0.webp","assets/images/boards/c/prima_1.webp","assets/images/boards/c/prima_2.webp","assets/images/boards/c/prima_4.webp","assets/images/boards/c/prima_5.webp","assets/images/boards/c/prima_6.webp","assets/images/boards/c/prima_8.webp","assets/images/boards/c/prima_9.webp"],"skip":[0,2,3],"en":[["The challenge","Prima is a tiramisù brand born from a family story and Italian roots. They needed a brand kit that turned a homemade dessert into something desirable and premium, ready to live on tins, boxes and social media from day one."],["The concept","<b>Primero, lo dulce</b> — the ritual of indulgence. Treating yourself doesn’t need a special occasion: pleasure is the occasion. Around that idea we built <b>The Tiramisù Society</b>, a warm, sociable universe made for sharing."],["The system","A hand-lettered script logotype with secondary and seal versions, a palette of bordeaux, ivory and soft pastels, an expressive editorial display paired with a clean text and mono family, and patterns inspired by the dessert — waves, harlequin and ladyfingers — applied to tins, boxes, bags, aprons and Instagram."]],"es":[["El desafío","Prima es una marca de tiramisù que nace de una historia familiar y de raíces italianas. Necesitaban un brand kit que convirtiera un postre casero en algo deseable y premium, listo para vivir en latas, cajas y redes desde el primer día."],["El concepto","<b>Primero, lo dulce:</b> el ritual de darse el gusto. Darse un gusto no necesita una ocasión especial: el placer es la ocasión. Alrededor de esa idea construimos <b>The Tiramisù Society</b>, un universo cálido y social, hecho para compartir."],["El sistema","Un logotipo script dibujado a mano con versiones secundaria y sello, una paleta de bordó, marfil y pasteles suaves, una display editorial expresiva junto a una familia de texto y mono limpia, y patrones inspirados en el postre —ondas, arlequín y vainillas— aplicados a latas, cajas, bolsas, delantales e Instagram."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    40,
    'shelly-and-co',
    'Shelly & Co',
    '2026',
    'Seafood curator',
    'Curador de productos del mar',
    ARRAY['branding','packaging']::text[],
    'assets/images/projects/p40_6.webp',
    'Beyond the ordinary catch 🐟
Meet SHELLY & CO., a contemporary seafood curator dedicated to carefully selecting exceptional products from the sea.
Our goal was to create a visual identity that reflects the brand’s premium positioning while bringing a fresh, modern perspective to the seafood industry.

Inspired by the ocean, we developed a visual universe that balances sophistication with a playful, graphic approach. Soft ocean blues, fluid gradients, and silver finishes evoke the sea while adding a refined, contemporary edge. Expressive serif typography meets clean sans-serif details, while custom illustrations reinterpret marine life through bold, organic silhouettes.

From packaging to merchandise, every element was designed to create a cohesive, distinctive, and effortlessly fresh identity.
A brand built around the art of selection, where thoughtful design meets exceptional taste.
Good taste runs deep.',
    'Beyond the ordinary catch 🐟
Meet SHELLY & CO., a contemporary seafood curator dedicated to carefully selecting exceptional products from the sea.
Our goal was to create a visual identity that reflects the brand’s premium positioning while bringing a fresh, modern perspective to the seafood industry.

Inspired by the ocean, we developed a visual universe that balances sophistication with a playful, graphic approach. Soft ocean blues, fluid gradients, and silver finishes evoke the sea while adding a refined, contemporary edge. Expressive serif typography meets clean sans-serif details, while custom illustrations reinterpret marine life through bold, organic silhouettes.

From packaging to merchandise, every element was designed to create a cohesive, distinctive, and effortlessly fresh identity.
A brand built around the art of selection, where thoughtful design meets exceptional taste.
Good taste runs deep.',
    '',
    'published',
    true,
    1,
    3,
    '[{"type":"i","url":"assets/images/projects/p40_0.webp"},{"type":"i","url":"assets/images/projects/p40_1.webp"},{"type":"i","url":"assets/images/projects/p40_2.webp"},{"type":"i","url":"assets/images/projects/p40_3.webp"},{"type":"i","url":"assets/images/projects/p40_4.webp"},{"type":"i","url":"assets/images/projects/p40_5.webp"},{"type":"i","url":"assets/images/projects/p40_6.webp"},{"type":"i","url":"assets/images/projects/p40_7.webp"},{"type":"i","url":"assets/images/projects/p40_8.webp"},{"type":"i","url":"assets/images/projects/p40_9.webp"},{"type":"i","url":"assets/images/projects/p40_10.webp"},{"type":"i","url":"assets/images/projects/p40_11.webp"},{"type":"i","url":"assets/images/projects/p40_12.webp"},{"type":"i","url":"assets/images/projects/p40_16.webp"},{"type":"i","url":"assets/images/projects/p40_17.webp"},{"type":"i","url":"assets/images/projects/p40_18.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/shelly_cover.webp","assets/images/boards/shelly_0.webp","assets/images/boards/shelly_1.webp","assets/images/boards/shelly_2.webp","assets/images/boards/shelly_4.webp","assets/images/boards/shelly_5.webp","assets/images/boards/shelly_6.webp","assets/images/boards/shelly_7.webp","assets/images/boards/shelly_8.webp"],"skip":[],"order":[0,2,1],"en":[["The challenge","Shelly & Co. selects and distributes premium seafood for the best kitchens. They needed an identity that could communicate quality and criteria from the very first glance — moving away from the industrial, cold codes of the seafood category and bringing a fresh, contemporary perspective."],["The concept","We built the brand around one idea: <b>Selected from the sea</b>. The exceptional is chosen, not found by chance. The name comes from the shell, a symbol of marine origin and of how carefully something valuable is protected — so the brand positions itself as a curator of rare finds rather than just an importer."],["The system","A condensed, high-contrast serif logotype with an ampersand and an underlined “co”, and <b>The Shell</b>, a scallop reduced to bold strokes and negative space. Soft ocean blues with fluid gradients and silver finishes, an expressive serif paired with clean sans-serif details, and organic marine illustrations that bring a playful side to packaging and merch."]],"es":[["El desafío","Shelly & Co. selecciona y distribuye productos del mar de primera calidad para las mejores cocinas. Necesitaban una identidad que transmitiera calidad y criterio desde el primer vistazo, alejándose de los códigos fríos e industriales del rubro y aportando una mirada fresca y contemporánea."],["El concepto","Construimos la marca alrededor de una idea: <b>Selected from the sea</b>. Lo excepcional se elige, no se encuentra por casualidad. El nombre viene de la concha, símbolo del origen marino y del cuidado con el que se protege lo valioso, para posicionar a la marca como curadora de hallazgos y no solo como importadora."],["El sistema","Un logotipo en serif condensada de alto contraste, con ampersand y el “co” subrayado, y <b>The Shell</b>, una vieira sintetizada en trazos gruesos y espacios negativos. Azules oceánicos suaves con degradés fluidos y terminaciones plateadas, una serif expresiva junto a detalles en sans serif, e ilustraciones marinas orgánicas que le suman un lado lúdico al packaging y el merch."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    1,
    'vondel',
    'Vondel',
    '2026',
    'Sports app · Argentina',
    'App deportiva · Argentina',
    ARRAY['branding']::text[],
    'assets/images/projects/p1_0.webp',
    'Meet VONDEL @vondel.app 

Brand identity for a platform that connects players with their next match :)⚽️

Starting from the concept of connection, we developed the naming, strategy and visual identity to create a brand that feels approachable, dynamic and community-driven.

The identity combines an organic visual language, a distinctive symbol and a warm, contemporary system designed to feel as human as the people using it.

A complete visual system built to live across both digital and physical touchpoints.',
    'Meet VONDEL @vondel.app 

Brand identity for a platform that connects players with their next match :)⚽️

Starting from the concept of connection, we developed the naming, strategy and visual identity to create a brand that feels approachable, dynamic and community-driven.

The identity combines an organic visual language, a distinctive symbol and a warm, contemporary system designed to feel as human as the people using it.

A complete visual system built to live across both digital and physical touchpoints.',
    '',
    'published',
    true,
    2,
    4,
    '[{"type":"i","url":"assets/images/projects/p1_0.webp"},{"type":"i","url":"assets/images/projects/p1_1.webp"},{"type":"i","url":"assets/images/projects/p1_3.webp"},{"type":"i","url":"assets/images/projects/p1_4.webp"},{"type":"i","url":"assets/images/projects/p1_5.webp"},{"type":"i","url":"assets/images/projects/p1_6.webp"},{"type":"i","url":"assets/images/projects/p1_7.webp"},{"type":"i","url":"assets/images/projects/p1_8.webp"},{"type":"i","url":"assets/images/projects/p1_9.webp"},{"type":"i","url":"assets/images/projects/p1_10.webp"},{"type":"i","url":"assets/images/projects/p1_11.webp"},{"type":"i","url":"assets/images/projects/p1_12.webp"},{"type":"i","url":"assets/images/projects/p1_13.webp"},{"type":"i","url":"assets/images/projects/p1_14.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/vondel_0.webp","assets/images/boards/c/vondel_2.webp","assets/images/boards/c/vondel_3.webp","assets/images/boards/c/vondel_5.webp","assets/images/boards/c/vondel_6.webp","assets/images/boards/c/vondel_7.webp","assets/images/boards/c/vondel_8.webp"],"skip":[3,7],"en":[["The challenge","Vondel is a subscription platform for amateur football: you choose when to play and they book the pitch, build the teams and coordinate every match. The brand had to make a tech service feel as warm and social as a Sunday game with friends."],["The concept","We started from strategy: purpose, mission, core values, archetypes (<b>The Connector</b> and <b>The Facilitator</b>) and a tone of voice that is close, simple and active. All of it condensed into one idea: <b>“Hacer posible el juego”</b> — making the game happen, the moment where individuals become a team."],["The system","A symbol of figures holding each other, forming a star, paired with a bold italic wordmark. A fresh palette of pitch greens and sunny accents, a typographic system with clear roles, icons and textures — designed to live in the app, on matchday graphics, kits and merch."]],"es":[["El desafío","Vondel es una plataforma de fútbol amateur por suscripción: elegís cuándo jugar y ellos reservan la cancha, arman los equipos y coordinan cada partido. La marca tenía que hacer que un servicio tecnológico se sintiera tan cercano y social como un partido con amigos."],["El concepto","Arrancamos por la estrategia: propósito, misión, valores, arquetipos (<b>El Conector</b> y <b>El Facilitador</b>) y un tono de voz cercano, simple y activo. Todo se resume en una idea: <b>“Hacer posible el juego”</b>, ese momento en el que las personas se conectan y pasan de individuos a equipo."],["El sistema","Un símbolo de figuras que se abrazan formando una estrella, junto a un wordmark bold en itálica. Una paleta fresca de verdes cancha y acentos soleados, un sistema tipográfico con roles claros, íconos y texturas, pensado para vivir en la app, en las piezas de cada partido, las camisetas y el merch."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    2,
    'pouse',
    'Pöuse',
    '2026',
    'Snacks · Amsterdam',
    'Snacks · Ámsterdam',
    ARRAY['branding','packaging']::text[],
    'assets/images/projects/p2_0.webp',
    'Branding for @takeapouse 💟🌷
A new crunchy legumes brand crafted in Amsterdam.
Designed for a world that constantly asks us to move faster, PÖUSE celebrates the small —crunchy— moments that help us slow down.
Not by escaping everyday life, but by finding pause within it.
Whether it’s your afternoon break, a picnic in the park, or the Dutch tradition of borrel—the after-work ritual of gathering with friends over drinks and snacks—PÖUSE naturally belongs at the table with a healthier proposal.
The visual identity reflects that same mindset.
Rather than following the muted aesthetics often associated with wellness, we built a vibrant, playful world inspired by long summer afternoons, shared tables, flowers, laughter, and everyday rituals. Bold lilacs, warm yellows, fresh greens, and expressive illustrations bring energy to a category that often feels predictable.
Because mindfulness isn’t always quiet.
Sometimes it’s laughing with friends over a glass of wine. Sometimes it’s taking ten minutes for yourself between meetings. Sometimes it’s simply reaching for a snack and being present for a moment.
PÖUSE embraces the idea that mindful moments don’t have to look a certain way—they just have to feel like yours.',
    'Branding for @takeapouse 💟🌷
A new crunchy legumes brand crafted in Amsterdam.
Designed for a world that constantly asks us to move faster, PÖUSE celebrates the small —crunchy— moments that help us slow down.
Not by escaping everyday life, but by finding pause within it.
Whether it’s your afternoon break, a picnic in the park, or the Dutch tradition of borrel—the after-work ritual of gathering with friends over drinks and snacks—PÖUSE naturally belongs at the table with a healthier proposal.
The visual identity reflects that same mindset.
Rather than following the muted aesthetics often associated with wellness, we built a vibrant, playful world inspired by long summer afternoons, shared tables, flowers, laughter, and everyday rituals. Bold lilacs, warm yellows, fresh greens, and expressive illustrations bring energy to a category that often feels predictable.
Because mindfulness isn’t always quiet.
Sometimes it’s laughing with friends over a glass of wine. Sometimes it’s taking ten minutes for yourself between meetings. Sometimes it’s simply reaching for a snack and being present for a moment.
PÖUSE embraces the idea that mindful moments don’t have to look a certain way—they just have to feel like yours.',
    '',
    'published',
    true,
    3,
    5,
    '[{"type":"i","url":"assets/images/projects/p2_0.webp"},{"type":"i","url":"assets/images/projects/p2_14.webp"},{"type":"i","url":"assets/images/projects/p2_60.webp"},{"type":"i","url":"assets/images/projects/p2_50.webp"},{"type":"i","url":"assets/images/projects/p2_51.webp"},{"type":"i","url":"assets/images/projects/p2_52.webp"},{"type":"i","url":"assets/images/projects/p2_2.webp"},{"type":"i","url":"assets/images/projects/p2_6.webp"},{"type":"i","url":"assets/images/projects/p2_7.webp"},{"type":"i","url":"assets/images/projects/p2_8.webp"},{"type":"i","url":"assets/images/projects/p2_9.webp"},{"type":"i","url":"assets/images/projects/p2_11.webp"},{"type":"i","url":"assets/images/projects/p2_12.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/pouse_0.webp","assets/images/boards/c/pouse_2.webp","assets/images/boards/c/pouse_3.webp","assets/images/boards/c/pouse_4.webp","assets/images/boards/c/pouse_5.webp","assets/images/boards/c/pouse_6.webp","assets/images/boards/c/pouse_x36.webp","assets/images/boards/c/pouse_7.webp"],"skip":[],"en":[["The challenge","Pöuse is a Dutch savoury snack brand of roasted legumes, built around the small pauses of everyday life — borrel with friends, golden hour, an office break. They wanted to stand out as an accessible-premium, clean option without losing any of the fun of a snack."],["The concept","We started with strategy — purpose, mission, values and two archetypes, <b>The Innocent</b> and <b>The Jester</b> — and landed on one idea: <b>“Your crunchy reason to slow down.”</b> Not just a healthier snack, but a more intentional way to snack."],["The system","A chunky, rounded wordmark with the umlaut as a playful signature, a bold rounded display type with a clean sans, a vibrant palette of lilac, lime, coral and sunny yellow, and hand-drawn illustrations of each flavour’s ingredients for packaging, social media and merch."]],"es":[["El desafío","Pöuse es una marca holandesa de snacks salados de legumbres tostadas, pensada para las pequeñas pausas de todos los días: el borrel con amigos, la golden hour, un break en la oficina. Querían destacarse como una opción premium accesible y clean, sin perder lo divertido de un snack."],["El concepto","Arrancamos por la estrategia —propósito, misión, valores y dos arquetipos, <b>El Inocente</b> y <b>El Bufón</b>— y llegamos a una idea: <b>“Your crunchy reason to slow down.”</b> No es solo un snack más saludable, es una forma más consciente de picar algo."],["El sistema","Un wordmark robusto y redondeado con la diéresis como firma lúdica, una display redondeada y audaz junto a una sans limpia, una paleta vibrante de lila, lima, coral y amarillo, e ilustraciones de los ingredientes de cada sabor para el packaging, las redes y el merch."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    4,
    'senda',
    'Senda',
    '2026',
    'Architecture studio',
    'Estudio de arquitectura',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p4_3.webp',
    'Rebranding for AP Arquitectos — now SENDA, an architecture studio that understands space as a carefully designed journey.

The identity is built around the concept of “architecture as a precise path”, translating movement, balance and proportion into a clean, contemporary visual language.

Collab with @marcopolo.agency',
    'Rebranding for AP Arquitectos — now SENDA, an architecture studio that understands space as a carefully designed journey.

The identity is built around the concept of “architecture as a precise path”, translating movement, balance and proportion into a clean, contemporary visual language.

Collab with @marcopolo.agency',
    'https://senda-arq.com/',
    'published',
    true,
    5,
    6,
    '[{"type":"i","url":"assets/images/projects/p4_0.webp"},{"type":"i","url":"assets/images/projects/p4_1.webp"},{"type":"i","url":"assets/images/projects/p4_2.webp"},{"type":"i","url":"assets/images/projects/p4_3.webp"},{"type":"i","url":"assets/images/projects/p4_4.webp"},{"type":"i","url":"assets/images/projects/p4_5.webp"},{"type":"i","url":"assets/images/projects/p4_6.webp"},{"type":"i","url":"assets/images/projects/p4_7.webp"},{"type":"i","url":"assets/images/projects/p4_8.webp"},{"type":"i","url":"assets/images/projects/p4_9.webp"},{"type":"i","url":"assets/images/projects/p4_10.webp"},{"type":"i","url":"assets/images/projects/p4_11.webp"},{"type":"i","url":"assets/images/projects/p4_12.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/senda_0.webp","assets/images/boards/senda_1.webp","assets/images/boards/senda_2.webp"],"skip":[10,12],"en":[["The challenge","Senda is an architecture studio focused on quality spaces, where proportion, path and form are designed with precision. They needed an identity as calm and precise as their projects."],["The concept","<b>Diseñamos recorridos</b> — we design journeys. Architecture is lived in movement, so the path becomes a conscious sequence that guides the experience of inhabiting a space, with balance, coherence and rhythm."],["The system","Isotypes built from the idea of a path — a step, a crossing, a staircase — alongside a clean, contemporary sans-serif wordmark. A calm palette of olives, earth and stone, a modular grid built from the “S”, and applications for plans, presentations and stationery."]],"es":[["El desafío","Senda es un estudio de arquitectura enfocado en espacios de calidad, donde la proporción, el recorrido y la forma se piensan con precisión. Necesitaban una identidad tan serena y precisa como sus proyectos."],["El concepto","<b>Diseñamos recorridos.</b> La arquitectura se habita en movimiento, por eso el recorrido se vuelve una secuencia consciente que guía la experiencia del habitar, con equilibrio, coherencia y ritmo."],["El sistema","Isotipos construidos desde la idea de camino —un paso, un cruce, una escalera— junto a un wordmark en una sans serif limpia y contemporánea. Una paleta serena de olivas, tierra y piedra, una grilla modular construida desde la “S” y aplicaciones para planos, presentaciones y papelería."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    3,
    'tecnofit',
    'TecnoFit',
    '2025',
    'Gym · Buenos Aires',
    'Gimnasio · Buenos Aires',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p3_2.webp',
    'We had the opportunity to lead @somostecnofit complete rebranding process.

From the visual identity and brand system to the web and UX/UI of their upcoming app with @marcopolo.agency , while the architectural renovation of the space was developed alongside the project by @covosarquitectos — every decision was guided by a shared vision: creating a fitness experience where technology and performance work together.

TecnoFit is a fitness ecosystem built around movement, innovation and continuous evolution.

Through a system-driven approach, we developed a flexible identity that connects human performance and technology across every touchpoint.

The new identity balances performance and innovation through a bold visual system designed to evolve across multiple disciplines, platforms and experiences.

We’re excited to finally see the project come to life with the opening of their renovated studio in Buenos Aires 🏋🏽💪🏼

📍Costa Rica 5823, Palermo',
    'We had the opportunity to lead @somostecnofit complete rebranding process.

From the visual identity and brand system to the web and UX/UI of their upcoming app with @marcopolo.agency , while the architectural renovation of the space was developed alongside the project by @covosarquitectos — every decision was guided by a shared vision: creating a fitness experience where technology and performance work together.

TecnoFit is a fitness ecosystem built around movement, innovation and continuous evolution.

Through a system-driven approach, we developed a flexible identity that connects human performance and technology across every touchpoint.

The new identity balances performance and innovation through a bold visual system designed to evolve across multiple disciplines, platforms and experiences.

We’re excited to finally see the project come to life with the opening of their renovated studio in Buenos Aires 🏋🏽💪🏼

📍Costa Rica 5823, Palermo',
    'https://www.somostecnofit.com/',
    'published',
    true,
    4,
    7,
    '[{"type":"i","url":"assets/images/projects/p3_0.webp"},{"type":"i","url":"assets/images/projects/p3_1.webp"},{"type":"i","url":"assets/images/projects/p3_2.webp"},{"type":"i","url":"assets/images/projects/p3_3.webp"},{"type":"i","url":"assets/images/projects/p3_4.webp"},{"type":"i","url":"assets/images/projects/p3_5.webp"},{"type":"i","url":"assets/images/projects/p3_6.webp"},{"type":"i","url":"assets/images/projects/p3_7.webp"},{"type":"i","url":"assets/images/projects/p3_8.webp"},{"type":"i","url":"assets/images/projects/p3_9.webp"},{"type":"i","url":"assets/images/projects/p3_10.webp"},{"type":"i","url":"assets/images/projects/p3_11.webp"},{"type":"i","url":"assets/images/projects/p3_12.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/tecno_0.webp","assets/images/boards/c/tecno_x2.webp","assets/images/boards/c/tecno_x3.webp","assets/images/boards/c/tecno_x4.webp","assets/images/boards/c/tecno_x6.webp","assets/images/boards/c/tecno_x8.webp","assets/images/boards/c/tecno_x11.webp","assets/images/boards/c/tecno_x12.webp"],"skip":[],"en":[["The challenge","TecnoFit is a premium functional training centre that connects technology and expert guidance to offer fully personalised plans — 40-minute sessions in your own box. The brand had to transmit impact and energy while feeling high-end."],["The concept","<b>All disciplines, connected</b> through high-level technology and expert guidance. We designed a brand ready to grow into new disciplines — run, box, cycle, yoga, pilates — under one system."],["The system","A dynamic italic wordmark with a TF monogram, an orange-to-coral gradient that feels like heat and movement, and a custom icon system for each exercise. Applied to signage, the app, screens and staff ID."]],"es":[["El desafío","TecnoFit es un centro de entrenamiento funcional premium que conecta tecnología y guía experta para ofrecer planes 100% personalizados, en sesiones de 40 minutos en tu propio box. La marca tenía que transmitir impacto y energía sin perder lo premium."],["El concepto","<b>Todas las disciplinas, conectadas</b> a través de tecnología de alto nivel y guía experta. Diseñamos una marca preparada para expandirse a nuevas disciplinas —run, box, cycle, yoga, pilates— bajo un mismo sistema."],["El sistema","Un wordmark dinámico en itálica con un monograma TF, un degradé de naranja a coral que se siente como calor y movimiento, y un sistema de íconos propio para cada ejercicio. Aplicado a cartelería, la app, pantallas y credenciales."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    76,
    'custom-portraits',
    'Custom Portraits',
    '2025',
    'Illustration for events',
    'Ilustración para eventos',
    ARRAY['illustration']::text[],
    'assets/images/projects/p76_0.webp',
    'Custom portraits for events ✍🏼

Hand-drawn line portraits of every guest, made to order for birthdays, weddings and celebrations.

Each card carries the guest’s name, the date and the details of the event — a personal keepsake that turns a party into a memory everyone takes home.

Black ink on cream for my own birthday, blue on butter yellow for Kari’s birthday.',
    'Custom portraits for events ✍🏼

Hand-drawn line portraits of every guest, made to order for birthdays, weddings and celebrations.

Each card carries the guest’s name, the date and the details of the event — a personal keepsake that turns a party into a memory everyone takes home.

Black ink on cream for my own birthday, blue on butter yellow for Kari’s birthday.',
    '',
    'published',
    false,
    NULL,
    8,
    '[{"type":"i","url":"assets/images/projects/p76_0.webp"},{"type":"i","url":"assets/images/projects/p76_1.webp"},{"type":"i","url":"assets/images/projects/p76_2.webp"},{"type":"i","url":"assets/images/projects/p76_3.webp"},{"type":"i","url":"assets/images/projects/p76_4.webp"},{"type":"i","url":"assets/images/projects/p76_5.webp"},{"type":"i","url":"assets/images/projects/p76_7.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/portraits_0.webp","assets/images/boards/c/portraits_1.webp","assets/images/boards/c/portraits_2.webp","assets/images/boards/c/portraits_3.webp"],"skip":[],"en":[["The challenge","Celebrations are full of people, and the best gifts are the ones that feel made for each of them. The idea was a keepsake that every guest could take home, personal enough to keep long after the party."],["The concept","<b>Every guest, drawn by hand.</b> A loose, delicate line portrait of each person, signed with the name they go by among friends — so the illustration captures not just a face but the way the people closest to them see them."],["The system","A card format designed for each event, with the date and occasion framing a single-line portrait and a hand-written name. The ink colour and paper tone change with each celebration, so every set has its own personality while the line stays the same."]],"es":[["El desafío","Los festejos están llenos de gente, y los mejores regalos son los que se sienten hechos para cada uno. La idea era un recuerdo que cada invitado pudiera llevarse a casa, lo bastante personal como para guardarlo mucho después de la fiesta."],["El concepto","<b>Cada invitado, dibujado a mano.</b> Un retrato de línea suelta y delicada de cada persona, firmado con el nombre con el que la llaman sus amigos, para que la ilustración capture no solo una cara sino la forma en que la ven los más cercanos."],["El sistema","Un formato de tarjeta pensado para cada evento, con la fecha y la ocasión enmarcando un retrato de línea y un nombre escrito a mano. El color de la tinta y el tono del papel cambian con cada festejo, así cada serie tiene su propia personalidad mientras el trazo se mantiene."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    5,
    'good-grab',
    'Good Grab',
    '2026',
    'Snacks launch campaign',
    'Campaña de lanzamiento de snacks',
    ARRAY['illustration','social']::text[],
    'assets/images/projects/p5_0.webp',
    'Hopped into @goodgrab.co’s universe to design the key visual for the launch of their new flavors — Strawberry & Hibiscus and Matcha & Coconut 🍓🌺🍵🥥 

Brought to life through stickers, postcards & social content :))))',
    'Hopped into @goodgrab.co’s universe to design the key visual for the launch of their new flavors — Strawberry & Hibiscus and Matcha & Coconut 🍓🌺🍵🥥 

Brought to life through stickers, postcards & social content :))))',
    '',
    'published',
    false,
    NULL,
    9,
    '[{"type":"i","url":"assets/images/projects/p5_0.webp"},{"type":"i","url":"assets/images/projects/p5_1.webp"},{"type":"i","url":"assets/images/projects/p5_2.webp"},{"type":"i","url":"assets/images/projects/p5_3.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    6,
    'culpa-salada',
    'Culpa Salada',
    '2026',
    'Book cover · Spain',
    'Tapa de libro · España',
    ARRAY['editorial']::text[],
    'assets/images/projects/p6_0.webp',
    'Book cover design for Culpa Salada @davidlucaspresenta first novel, a Spanish writer living in Amsterdam.

It tells the intimate and psychological story of a couple whose honeymoon in Thailand takes a tragic turn. Through visual elements such as the couple, movement, landscape, travel and a sense of nostalgia, we aimed to capture the atmosphere and emotional tension of the novel.

Available on Amazon 📘',
    'Book cover design for Culpa Salada @davidlucaspresenta first novel, a Spanish writer living in Amsterdam.

It tells the intimate and psychological story of a couple whose honeymoon in Thailand takes a tragic turn. Through visual elements such as the couple, movement, landscape, travel and a sense of nostalgia, we aimed to capture the atmosphere and emotional tension of the novel.

Available on Amazon 📘',
    '',
    'published',
    false,
    NULL,
    10,
    '[{"type":"i","url":"assets/images/projects/p6_0.webp"},{"type":"i","url":"assets/images/projects/p6_1.webp"},{"type":"i","url":"assets/images/projects/p6_2.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    7,
    'buy-in',
    'Buy In',
    '2026',
    'Miami · Punta del Este · BA',
    'Miami · Punta del Este · BA',
    ARRAY['branding']::text[],
    'assets/images/projects/p7_1.webp',
    'New branding — Buy In Real Estate

A curated real estate studio focused on pre-construction developments across Miami, Punta del Este & Buenos Aires.

The concept was built around investing with confidence — merging aspiration with clarity, trust and informed decision-making.

A brand designed to filter noise, guide investment journeys and position Buy In as a strategic boutique partner rather than a traditional real estate agency.',
    'New branding — Buy In Real Estate

A curated real estate studio focused on pre-construction developments across Miami, Punta del Este & Buenos Aires.

The concept was built around investing with confidence — merging aspiration with clarity, trust and informed decision-making.

A brand designed to filter noise, guide investment journeys and position Buy In as a strategic boutique partner rather than a traditional real estate agency.',
    '',
    'published',
    false,
    NULL,
    11,
    '[{"type":"i","url":"assets/images/projects/p7_0.webp"},{"type":"i","url":"assets/images/projects/p7_1.webp"},{"type":"i","url":"assets/images/projects/p7_2.webp"},{"type":"i","url":"assets/images/projects/p7_3.webp"},{"type":"i","url":"assets/images/projects/p7_4.webp"},{"type":"i","url":"assets/images/projects/p7_5.webp"},{"type":"i","url":"assets/images/projects/p7_6.webp"},{"type":"i","url":"assets/images/projects/p7_7.webp"},{"type":"i","url":"assets/images/projects/p7_8.webp"},{"type":"i","url":"assets/images/projects/p7_9.webp"},{"type":"i","url":"assets/images/projects/p7_10.webp"},{"type":"i","url":"assets/images/projects/p7_11.webp"},{"type":"i","url":"assets/images/projects/p7_12.webp"},{"type":"i","url":"assets/images/projects/p7_13.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/buyin_0.webp","assets/images/boards/buyin_1.webp","assets/images/boards/buyin_2.webp","assets/images/boards/buyin_3.webp","assets/images/boards/buyin_4.webp"],"skip":[2,7],"en":[["The challenge","BuyIn is a curated real estate studio specialising in pre-construction developments in Miami, Punta del Este and Buenos Aires. In a market built on trust, the brand had to feel premium, solid and reliable from the first touchpoint."],["The concept","<b>Invest with confidence.</b> BuyIn acts as a trusted intermediary between developers and investors, so the identity speaks of clarity, expertise and carefully selected opportunities — “Built on trust. Backed by expertise.”"],["The system","An elegant serif wordmark built on a precise grid, a warm palette of deep browns, bronze and stone inspired by materials and sunsets, and a refined serif and sans pairing. Applied to brochures, business cards, digital screens and a library of brand phrases."]],"es":[["El desafío","BuyIn es un estudio inmobiliario especializado en desarrollos en pozo en Miami, Punta del Este y Buenos Aires. En un mercado basado en la confianza, la marca tenía que sentirse premium, sólida y confiable desde el primer contacto."],["El concepto","<b>Invest with confidence.</b> BuyIn funciona como intermediario de confianza entre desarrolladores e inversores, por eso la identidad habla de claridad, experiencia y oportunidades cuidadosamente seleccionadas: “Built on trust. Backed by expertise.”"],["El sistema","Un wordmark serif elegante construido sobre una grilla precisa, una paleta cálida de marrones profundos, bronce y piedra inspirada en materiales y atardeceres, y una dupla refinada de serif y sans. Aplicado a brochures, tarjetas, pantallas digitales y un repertorio de frases de marca."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    9,
    'martina-lema',
    'Dra. Martina Lema',
    '2025',
    'Buenos Aires',
    'Buenos Aires',
    ARRAY['branding','social']::text[],
    'assets/images/projects/p9_0.webp',
    'Visual identity design & monthly design for @dra.martinalema 

A new aesthetic medical studio from Buenos Aires —— a project that wasn’t about “looking pretty”, but about communicating a way of working: intentional, personalized and deeply human.

We built a brand focused on experience, medical criteria and real connection with each patient — creating educational content that feels clear, approachable and cool — without losing medical rigor.

Minimal, refined and quietly elevated🤍💉',
    'Visual identity design & monthly design for @dra.martinalema 

A new aesthetic medical studio from Buenos Aires —— a project that wasn’t about “looking pretty”, but about communicating a way of working: intentional, personalized and deeply human.

We built a brand focused on experience, medical criteria and real connection with each patient — creating educational content that feels clear, approachable and cool — without losing medical rigor.

Minimal, refined and quietly elevated🤍💉',
    '',
    'published',
    false,
    NULL,
    12,
    '[{"type":"i","url":"assets/images/projects/p9_0.webp"},{"type":"i","url":"assets/images/projects/p9_1.webp"},{"type":"v","url":"assets/media/p9_v0.mp4","poster":"assets/media/p9_v0.webp"},{"type":"i","url":"assets/images/projects/p9_2.webp"},{"type":"i","url":"assets/images/projects/p9_3.webp"},{"type":"i","url":"assets/images/projects/p9_4.webp"},{"type":"i","url":"assets/images/projects/p9_5.webp"},{"type":"i","url":"assets/images/projects/p9_6.webp"},{"type":"i","url":"assets/images/projects/p9_7.webp"},{"type":"v","url":"assets/media/p9_v1.mp4","poster":"assets/media/p9_v1.webp"},{"type":"i","url":"assets/images/projects/p9_8.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/lema_0.webp","assets/images/boards/lema_1.webp","assets/images/boards/lema_2.webp","assets/images/boards/lema_x13.webp","assets/images/boards/lema_x19.webp"],"skip":[0],"en":[["The challenge","Dra. Martina Lema leads an aesthetic medicine practice that combines clinical precision, aesthetic sensitivity and personalised care. The brand had to convey calm, trust and professionalism."],["The concept","A new way to experience aesthetic medicine: refined, natural and deeply personal. Inspired by <b>quiet luxury</b> and the it-girl universe, the clinic becomes an exclusive studio where every detail feels elegant and authentic."],["The system","A refined wordmark, a short “Dra. Lema” version and an ML monogram, a soft palette of greige, sand and charcoal, an elegant classic serif with a clean sans, and intimate, skin-focused photography — applied to stationery, product labels and social media."]],"es":[["El desafío","La Dra. Martina Lema lidera un espacio de estética médica que combina precisión clínica, sensibilidad estética y atención personalizada. La marca tenía que transmitir calma, confianza y profesionalismo."],["El concepto","Una nueva forma de vivir la estética médica: refinada, natural y profundamente personalizada. Inspirada en el <b>quiet luxury</b> y el universo de las it girls, el consultorio se transforma en un studio exclusivo donde cada detalle transmite elegancia y autenticidad."],["El sistema","Un wordmark refinado, una versión corta “Dra. Lema” y un monograma ML, una paleta suave de greige, arena y grafito, una serif clásica y elegante junto a una sans limpia, y una fotografía íntima centrada en la piel, aplicado a papelería, etiquetas de producto y redes."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    11,
    'ninjo',
    'Ninjō',
    '2025',
    'AI for creators',
    'IA para creadores',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p11_1.webp',
    'Ninjō — an AI Sales Team built for creators.

A visual universe that blends minimalism, precision, and emotion. A brand that lives at the intersection of human intuition and intelligent systems — where structure meets movement, and ideas turn into action.

We designed a symbol that reflects that exact moment of connection: the spark where creation begins. Ethereal gradients, sensorial photography, modular iconography, and a type system balancing strength and softness shaped an identity that feels both technical and deeply human.

A brand built to help creators scale without scaling their teams — and one that needed a visual language to match its vision.

Branding by CAN Creative Studio
In collab with @marcopolo.agency 
@ninjo.ai 🧡💻',
    'Ninjō — an AI Sales Team built for creators.

A visual universe that blends minimalism, precision, and emotion. A brand that lives at the intersection of human intuition and intelligent systems — where structure meets movement, and ideas turn into action.

We designed a symbol that reflects that exact moment of connection: the spark where creation begins. Ethereal gradients, sensorial photography, modular iconography, and a type system balancing strength and softness shaped an identity that feels both technical and deeply human.

A brand built to help creators scale without scaling their teams — and one that needed a visual language to match its vision.

Branding by CAN Creative Studio
In collab with @marcopolo.agency 
@ninjo.ai 🧡💻',
    'https://www.ninjo.ai/',
    'published',
    true,
    6,
    13,
    '[{"type":"i","url":"assets/images/projects/p11_0.webp"},{"type":"v","url":"assets/media/p11_v0.mp4","poster":"assets/media/p11_v0.webp"},{"type":"i","url":"assets/images/projects/p11_1.webp"},{"type":"i","url":"assets/images/projects/p11_2.webp"},{"type":"i","url":"assets/images/projects/p11_3.webp"},{"type":"i","url":"assets/images/projects/p11_4.webp"},{"type":"i","url":"assets/images/projects/p11_5.webp"},{"type":"i","url":"assets/images/projects/p11_6.webp"},{"type":"i","url":"assets/images/projects/p11_7.webp"},{"type":"i","url":"assets/images/projects/p11_8.webp"},{"type":"i","url":"assets/images/projects/p11_9.webp"},{"type":"i","url":"assets/images/projects/p11_10.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/ninjo_0.webp","assets/images/boards/ninjo_1.webp","assets/images/boards/ninjo_2.webp","assets/images/boards/ninjo_3.webp","assets/images/boards/ninjo_5.webp"],"skip":[2,3],"en":[["The challenge","Ninjō helps creators turn their knowledge into digital businesses, with an AI agent working as a world-class team in their pocket. The brand had to feel human and sensorial, not cold and technical."],["The concept","The symbol is inspired by <b>The Creation of Adam</b>: two hands reaching toward each other, suspended between creation and potential. A curved stroke cuts through the rigid N — the spark where human creativity meets intelligent systems."],["The system","An N symbol and a clean wordmark, a palette of black, white and greys with orange and light-blue accents and soft gradients, a warm photographic tint, and an editorial mix of display serif, grotesk and mono — applied to the app, screens and merch."]],"es":[["El desafío","Ninjō ayuda a creadores a convertir su conocimiento en negocios digitales, con un agente de IA que funciona como un equipo de primer nivel en el bolsillo. La marca tenía que sentirse humana y sensorial, no fría ni técnica."],["El concepto","El símbolo se inspira en <b>La Creación de Adán</b>: dos manos que se buscan, suspendidas entre la creación y el potencial. Una curva atraviesa la N rígida: la chispa donde la creatividad humana se encuentra con los sistemas inteligentes."],["El sistema","Un símbolo N y un wordmark limpio, una paleta de negro, blanco y grises con acentos naranja y celeste y degradés suaves, un tinte fotográfico cálido y una mezcla editorial de serif display, grotesca y mono, aplicado a la app, pantallas y merch."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    12,
    'civitas',
    'Civitas',
    '2025',
    'Real estate',
    'Real estate',
    ARRAY['branding']::text[],
    'assets/images/projects/p12_4.webp',
    'CIVITAS

Brand identity refresh for a new real estate developer redefining quality, transparency and professionalism in urban living.

The rebranding focused on refining their existing logo —— improving balance, weight and spacing for a stronger, more confident presence.

From there, the visual language expanded into a complete system: color, typography, icons and a graphic structure working together to express simplicity, trust and sophistication.

A renewed identity that strengthens what Civitas already stands for —— quality, transparency and a vision for the future.
👷🏽‍♂️🧱',
    'CIVITAS

Brand identity refresh for a new real estate developer redefining quality, transparency and professionalism in urban living.

The rebranding focused on refining their existing logo —— improving balance, weight and spacing for a stronger, more confident presence.

From there, the visual language expanded into a complete system: color, typography, icons and a graphic structure working together to express simplicity, trust and sophistication.

A renewed identity that strengthens what Civitas already stands for —— quality, transparency and a vision for the future.
👷🏽‍♂️🧱',
    '',
    'published',
    false,
    NULL,
    14,
    '[{"type":"i","url":"assets/images/projects/p12_0.webp"},{"type":"i","url":"assets/images/projects/p12_1.webp"},{"type":"i","url":"assets/images/projects/p12_2.webp"},{"type":"v","url":"assets/media/p12_v0.mp4","poster":"assets/media/p12_v0.webp"},{"type":"i","url":"assets/images/projects/p12_3.webp"},{"type":"i","url":"assets/images/projects/p12_4.webp"},{"type":"i","url":"assets/images/projects/p12_5.webp"},{"type":"i","url":"assets/images/projects/p12_6.webp"},{"type":"i","url":"assets/images/projects/p12_7.webp"},{"type":"i","url":"assets/images/projects/p12_8.webp"},{"type":"i","url":"assets/images/projects/p12_9.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/civitas_0.webp","assets/images/boards/c/civitas_1.webp","assets/images/boards/c/civitas_3.webp","assets/images/boards/c/civitas_4.webp","assets/images/boards/c/civitas_7.webp","assets/images/boards/c/civitas_8.webp","assets/images/boards/c/civitas_x10.webp"],"skip":[4,10],"en":[["The challenge","Civitas develops real estate projects from start to finish. They already had a logo, but it lacked weight, balance and presence — it lost legibility at small sizes and didn’t reflect the quality of their work."],["The concept","<b>“Construimos calidad”</b> — we build quality. A statement of principles about excellence at every stage, from design to handover, built on detail, transparency and personalised attention. We analysed the existing logo and optimised it rather than starting over."],["The system","A bolder, better-kerned wordmark that works as one unit with its building isotype, a sober palette of charcoal, stone and deep blue, a solid geometric sans with technical mono details, and an architectural icon set applied to signage, brochures and digital."]],"es":[["El desafío","Civitas desarrolla proyectos inmobiliarios de principio a fin. Ya tenían un logo, pero le faltaba peso, equilibrio y presencia: perdía legibilidad en tamaños chicos y no reflejaba la calidad de su trabajo."],["El concepto","<b>“Construimos calidad.”</b> Una declaración de principios sobre la excelencia en cada etapa, del diseño a la entrega, basada en el detalle, la transparencia y la atención personalizada. Analizamos el logo existente y lo optimizamos en lugar de empezar de cero."],["El sistema","Un wordmark con más peso y kerning ajustado que funciona como unidad junto a su isotipo de edificios, una paleta sobria de grafito, piedra y azul profundo, una sans geométrica sólida con detalles en mono técnica, y un set de íconos arquitectónicos aplicado a cartelería, brochures y digital."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    13,
    'almendro',
    'Almendro',
    '2025',
    'Concept store',
    'Concept store',
    ARRAY['branding']::text[],
    'assets/images/projects/p13_0.webp',
    'Almendro <3

Brand identity for @tienda.almendro —— a collaborative concept store by @vite.ar and @leste.letras 
A space where sustainability meets literature — between textures, scents, and timeless objects.

The identity embraces calm tones, organic shapes and quiet balance, reflecting the brand’s essence: to inhabit the world slowly and with intention.

Located inside a greenhouse, Almendro invites you to pause, read, and breathe 🌱🌸 @herbarium.ar',
    'Almendro <3

Brand identity for @tienda.almendro —— a collaborative concept store by @vite.ar and @leste.letras 
A space where sustainability meets literature — between textures, scents, and timeless objects.

The identity embraces calm tones, organic shapes and quiet balance, reflecting the brand’s essence: to inhabit the world slowly and with intention.

Located inside a greenhouse, Almendro invites you to pause, read, and breathe 🌱🌸 @herbarium.ar',
    '',
    'published',
    false,
    NULL,
    15,
    '[{"type":"i","url":"assets/images/projects/p13_0.webp"},{"type":"i","url":"assets/images/projects/p13_1.webp"},{"type":"i","url":"assets/images/projects/p13_2.webp"},{"type":"i","url":"assets/images/projects/p13_3.webp"},{"type":"i","url":"assets/images/projects/p13_4.webp"},{"type":"i","url":"assets/images/projects/p13_5.webp"},{"type":"i","url":"assets/images/projects/p13_6.webp"},{"type":"i","url":"assets/images/projects/p13_7.webp"},{"type":"i","url":"assets/images/projects/p13_8.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/almendro_0.webp","assets/images/boards/c/almendro_1.webp","assets/images/boards/c/almendro_3.webp","assets/images/boards/c/almendro_7.webp"],"skip":[1],"en":[["The challenge","Almendro is a concept store that brings together sustainable clothing and literature, born from the union of two brands, Vite and Lesté. The identity had to hold both worlds while feeling like a calm refuge."],["The concept","<b>“Habitar el mundo con pausa”</b> — inhabiting the world slowly. Thinking of consumption as connection and time as value: a place to choose consciously and stay a little longer."],["The system","An organic serif wordmark with its own almond symbol, variants that host Vite and Lesté, a warm earthy palette, a wide gothic paired with soft, natural serifs, and a family of seals and patterns — applied to bags, tissue paper, labels and signage."]],"es":[["El desafío","Almendro es una concept store que une prendas sustentables y literatura, y nace de la unión de dos marcas, Vite y Lesté. La identidad tenía que sostener ambos mundos y sentirse como un refugio de calma."],["El concepto","<b>“Habitar el mundo con pausa.”</b> Pensar el consumo como vínculo y el tiempo como valor: un lugar para elegir con conciencia y quedarse un poco más."],["El sistema","Un wordmark serif orgánico con un símbolo propio de almendra, variables que alojan a Vite y Lesté, una paleta cálida y terrosa, una gótica extendida junto a serifs suaves y naturales, y una familia de sellos y patrones, aplicado a bolsas, papel seda, etiquetas y cartelería."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    14,
    'the-acting-garage',
    'The Acting Garage',
    '2025',
    'Barcelona',
    'Barcelona',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p14_0.webp',
    'THE ACTING GARAGE

Branding & web design for a new film and theatre acting school redefining creative expression and performance training in Barcelona.

Built around the idea of freedom to create, TAG’s visual system explores the balance between structure and spontaneity —— a bold identity where energy, movement and character meet in every performance. 

—— Website in collaboration with @marcopolo.agency :)

A creative space for Barcelona actors @theactingarage 🎬🎥🎞️',
    'THE ACTING GARAGE

Branding & web design for a new film and theatre acting school redefining creative expression and performance training in Barcelona.

Built around the idea of freedom to create, TAG’s visual system explores the balance between structure and spontaneity —— a bold identity where energy, movement and character meet in every performance. 

—— Website in collaboration with @marcopolo.agency :)

A creative space for Barcelona actors @theactingarage 🎬🎥🎞️',
    'https://www.theactingarage.com/',
    'published',
    true,
    7,
    16,
    '[{"type":"i","url":"assets/images/projects/p14_0.webp"},{"type":"v","url":"assets/media/p14_v0.mp4","poster":"assets/media/p14_v0.webp"},{"type":"i","url":"assets/images/projects/p14_1.webp"},{"type":"v","url":"assets/media/p14_v1.mp4","poster":"assets/media/p14_v1.webp"},{"type":"i","url":"assets/images/projects/p14_2.webp"},{"type":"i","url":"assets/images/projects/p14_3.webp"},{"type":"i","url":"assets/images/projects/p14_4.webp"},{"type":"i","url":"assets/images/projects/p14_5.webp"},{"type":"i","url":"assets/images/projects/p14_6.webp"},{"type":"v","url":"assets/media/p14_v2.mp4","poster":"assets/media/p14_v2.webp"},{"type":"i","url":"assets/images/projects/p14_7.webp"},{"type":"i","url":"assets/images/projects/p14_8.webp"},{"type":"i","url":"assets/images/projects/p14_9.webp"},{"type":"i","url":"assets/images/projects/p14_10.webp"},{"type":"i","url":"assets/images/projects/p14_11.webp"},{"type":"i","url":"assets/images/projects/p14_12.webp"},{"type":"i","url":"assets/images/projects/p14_13.webp"},{"type":"i","url":"assets/images/projects/p14_14.webp"},{"type":"i","url":"assets/images/projects/p14_15.webp"},{"type":"i","url":"assets/images/projects/p14_16.webp"},{"type":"i","url":"assets/images/projects/p14_17.webp"},{"type":"i","url":"assets/images/projects/p14_18.webp"},{"type":"i","url":"assets/images/projects/p14_19.webp"},{"type":"i","url":"assets/images/projects/p14_20.webp"},{"type":"i","url":"assets/images/projects/p14_21.webp"},{"type":"i","url":"assets/images/projects/p14_22.webp"},{"type":"i","url":"assets/images/projects/p14_23.webp"},{"type":"i","url":"assets/images/projects/p14_24.webp"},{"type":"i","url":"assets/images/projects/p14_25.webp"},{"type":"i","url":"assets/images/projects/p14_26.webp"},{"type":"i","url":"assets/images/projects/p14_27.webp"},{"type":"i","url":"assets/images/projects/p14_28.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/tag_0.webp","assets/images/boards/c/tag_1.webp","assets/images/boards/c/tag_2.webp","assets/images/boards/c/tag_3.webp","assets/images/boards/c/tag_5.webp","assets/images/boards/c/tag_x6.webp","assets/images/boards/c/tag_x7.webp","assets/images/boards/c/tag_x11.webp"],"skip":[2,5],"en":[["The challenge","The Acting Garage isn’t just another acting school in Barcelona: it’s the place where performance turns into character. They needed a brand with its own aesthetic and culture, combining technique and attitude."],["The concept","<b>“El motor de tu transformación creativa”</b> — the engine of your creative transformation. Training that challenges what you’ve learned, scenes that invite you to take risks. We also built a verbal system of subclaims from the acronym: Tag your talent, Tag your impact, Tag the stage."],["The system","A heavy condensed wordmark paired with a stacked TAG symbol, a strong yellow with black and cream, bold condensed titles balanced with a classic serif and mono details, and a cinematic black-and-white photographic style with spotlights — applied to posters, social media and merch."]],"es":[["El desafío","The Acting Garage no es una escuela de actuación más en Barcelona: es el lugar donde la interpretación se transforma en carácter. Necesitaban una marca con estética y cultura propia, que combinara técnica y actitud."],["El concepto","<b>“El motor de tu transformación creativa.”</b> Entrenamiento que desafía lo aprendido, escenas que invitan a arriesgar. También armamos un sistema verbal de subclaims a partir de la sigla: Tag your talent, Tag your impact, Tag the stage."],["El sistema","Un wordmark condensado y pesado junto a un símbolo TAG apilado, un amarillo fuerte con negro y crudo, títulos condensados y potentes equilibrados con una serif clásica y detalles en mono, y un estilo fotográfico cinematográfico en blanco y negro con reflectores, aplicado a afiches, redes y merch."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    16,
    'lote-8',
    'Lote 8',
    '2025',
    'Uruguay',
    'Uruguay',
    ARRAY['illustration','packaging']::text[],
    'assets/images/projects/p16_0.webp',
    'LOTE 8 —— Signature Artwork

Illustration for Lote 8, a premium extra virgin olive oil from Valle Edén, Uruguay. The composition of the olives create the number 8, turning a natural element into a key brand symbol. Hand-drawn with a free and textured style, the illustration conveys authenticity, warmth, and a premium identity — created for the label but adaptable across multiple brand touchpoints.

:)))✏️🫒✨ check out the process on tiktok',
    'LOTE 8 —— Signature Artwork

Illustration for Lote 8, a premium extra virgin olive oil from Valle Edén, Uruguay. The composition of the olives create the number 8, turning a natural element into a key brand symbol. Hand-drawn with a free and textured style, the illustration conveys authenticity, warmth, and a premium identity — created for the label but adaptable across multiple brand touchpoints.

:)))✏️🫒✨ check out the process on tiktok',
    '',
    'published',
    false,
    NULL,
    17,
    '[{"type":"i","url":"assets/images/projects/p16_0.webp"},{"type":"i","url":"assets/images/projects/p16_1.webp"},{"type":"i","url":"assets/images/projects/p16_2.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    17,
    'holding-families',
    'Holding Families',
    '2025',
    'Parenting · Miami',
    'Crianza · Miami',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p17_2.webp',
    'Holding Families —— brand concept, design, website & more :)

A brand universe designed to redefine parenting. Rooted in science, ai and human warmth, we crafted an identity that feels modern, technological, and deeply human. Earthy tones, authentic imagery, and organic design come together to reflect a new paradigm in family support.

🤎',
    'Holding Families —— brand concept, design, website & more :)

A brand universe designed to redefine parenting. Rooted in science, ai and human warmth, we crafted an identity that feels modern, technological, and deeply human. Earthy tones, authentic imagery, and organic design come together to reflect a new paradigm in family support.

🤎',
    'https://www.holding-families.com/',
    'published',
    false,
    NULL,
    18,
    '[{"type":"i","url":"assets/images/projects/p17_0.webp"},{"type":"i","url":"assets/images/projects/p17_1.webp"},{"type":"v","url":"assets/media/p17_v0.mp4","poster":"assets/media/p17_v0.webp"},{"type":"i","url":"assets/images/projects/p17_2.webp"},{"type":"v","url":"assets/media/p17_v1.mp4","poster":"assets/media/p17_v1.webp"},{"type":"i","url":"assets/images/projects/p17_3.webp"},{"type":"i","url":"assets/images/projects/p17_4.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    18,
    'curvina',
    'Curvina',
    '2025',
    'Fashion',
    'Moda',
    ARRAY['branding']::text[],
    'assets/images/projects/p18_7.webp',
    'Nueva identidad para @curvina__ — Fusionamos tradición, cultura y legado artesanal con el estilo streetwear contemporáneo, creando una marca femenina que inspira libertad y expresión a través de piezas de autor.

Trabajamos sobre las curvas imperfectas y un guiño al fileteado porteño, para rendir homenaje al origen de la marca: “Fundada en el campo de French, Bs. As., 2008, después de una costura que salió chueca... o mejor dicho, Curvina”.

De esta manera, logramos integrar la tradición cultural con una estética moderna, limpia y equilibrada.

Conozcan el gran talento de @curvina__ 🖤',
    'Nueva identidad para @curvina__ — Fusionamos tradición, cultura y legado artesanal con el estilo streetwear contemporáneo, creando una marca femenina que inspira libertad y expresión a través de piezas de autor.

Trabajamos sobre las curvas imperfectas y un guiño al fileteado porteño, para rendir homenaje al origen de la marca: “Fundada en el campo de French, Bs. As., 2008, después de una costura que salió chueca... o mejor dicho, Curvina”.

De esta manera, logramos integrar la tradición cultural con una estética moderna, limpia y equilibrada.

Conozcan el gran talento de @curvina__ 🖤',
    '',
    'published',
    false,
    NULL,
    19,
    '[{"type":"v","url":"assets/media/p18_v0.mp4","poster":"assets/media/p18_v0.webp"},{"type":"i","url":"assets/images/projects/p18_0.webp"},{"type":"i","url":"assets/images/projects/p18_1.webp"},{"type":"i","url":"assets/images/projects/p18_2.webp"},{"type":"i","url":"assets/images/projects/p18_3.webp"},{"type":"i","url":"assets/images/projects/p18_5.webp"},{"type":"i","url":"assets/images/projects/p18_6.webp"},{"type":"i","url":"assets/images/projects/p18_7.webp"},{"type":"i","url":"assets/images/projects/p18_9.webp"},{"type":"i","url":"assets/images/projects/p18_10.webp"},{"type":"i","url":"assets/images/projects/p18_11.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/curvina_0.webp","assets/images/boards/c/curvina_1.webp","assets/images/boards/c/curvina_2.webp","assets/images/boards/c/curvina_3.webp","assets/images/boards/c/curvina_x16.webp","assets/images/boards/c/curvina_x26.webp"],"skip":[5],"en":[["The challenge","Curvina is a fashion brand that takes the essence of the gaucho — with a feminine twist — and brings it into a modern, urban language. The identity had to bridge craftsmanship and streetwear."],["The concept","<b>The Modern Heritage</b> — the evolution of a legacy, tradition reinvented for the contemporary woman. Neo-gaucha: freedom, strength and identity translated into a more nocturnal, urban and contemporary world."],["The system","A clean, wide wordmark and a CV monogram inspired by the curves of a buckle, a palette of black, white and greys driven by photography, and modern geometric sans-serifs with a touch of character for details — applied to belts, bags, labels, packaging and social media."]],"es":[["El desafío","Curvina es una marca de moda que toma la esencia del gaucho —con su twist femenino— y la lleva a un lenguaje moderno y urbano. La identidad tenía que unir lo artesanal con el streetwear."],["El concepto","<b>The Modern Heritage:</b> la evolución del legado, tradición reinventada para la mujer contemporánea. Neo gaucha: libertad, fuerza e identidad traducidas a un mundo más urbano, nocturno y actual."],["El sistema","Un wordmark limpio y extendido y un monograma CV inspirado en las curvas de una hebilla, una paleta de negro, blanco y grises guiada por la fotografía, y sans geométricas modernas con un toque de carácter para los detalles, aplicado a cinturones, carteras, etiquetas, packaging y redes."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    20,
    'helia',
    'Helia',
    '2025',
    'Protein bars · Amsterdam',
    'Barritas proteicas · Ámsterdam',
    ARRAY['branding','packaging']::text[],
    'assets/images/projects/p20_0.webp',
    'Introducing Helia, a brand built with real meaning, set to revolutionize the snack industry. 

Through an extensive branding process, we shaped its identity, strategic core, storytelling, and designing a visual identity from scratch.

Inspired by its Argentinian co-founders in Amsterdam, we created a concept that bridges the gap —— the radiant sun of Argentina’s flag, often missing in Amsterdam, brought into daily life through honest, 100% clean snacks.

Your daily dose of sunshine 
Follow the journey as we continue to manage @heliabites brand :)🩵☀️',
    'Introducing Helia, a brand built with real meaning, set to revolutionize the snack industry. 

Through an extensive branding process, we shaped its identity, strategic core, storytelling, and designing a visual identity from scratch.

Inspired by its Argentinian co-founders in Amsterdam, we created a concept that bridges the gap —— the radiant sun of Argentina’s flag, often missing in Amsterdam, brought into daily life through honest, 100% clean snacks.

Your daily dose of sunshine 
Follow the journey as we continue to manage @heliabites brand :)🩵☀️',
    '',
    'published',
    true,
    8,
    20,
    '[{"type":"i","url":"assets/images/projects/p20_0.webp"},{"type":"v","url":"assets/media/p20_v0.mp4","poster":"assets/media/p20_v0.webp"},{"type":"i","url":"assets/images/projects/p20_1.webp"},{"type":"i","url":"assets/images/projects/p20_50.webp"},{"type":"i","url":"assets/images/projects/p20_51.webp"},{"type":"i","url":"assets/images/projects/p20_52.webp"},{"type":"i","url":"assets/images/projects/p20_2.webp"},{"type":"i","url":"assets/images/projects/p20_3.webp"},{"type":"i","url":"assets/images/projects/p20_4.webp"},{"type":"i","url":"assets/images/projects/p20_6.webp"},{"type":"i","url":"assets/images/projects/p20_7.webp"},{"type":"i","url":"assets/images/projects/p20_8.webp"},{"type":"i","url":"assets/images/projects/p20_9.webp"},{"type":"i","url":"assets/images/projects/p20_11.webp"},{"type":"i","url":"assets/images/projects/p20_12.webp"},{"type":"i","url":"assets/images/projects/p20_13.webp"},{"type":"i","url":"assets/images/projects/p20_14.webp"},{"type":"i","url":"assets/images/projects/p20_15.webp"},{"type":"i","url":"assets/images/extras/helia0.webp"},{"type":"i","url":"assets/images/extras/helia1.webp"},{"type":"i","url":"assets/images/extras/helia2.webp"},{"type":"i","url":"assets/images/extras/helia3.webp"},{"type":"i","url":"assets/images/extras/helia4.webp"},{"type":"i","url":"assets/images/extras/helia5.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/helia_0.webp","assets/images/boards/c/helia_1.webp","assets/images/boards/c/helia_2.webp","assets/images/boards/c/helia_3.webp","assets/images/boards/c/helia_x7.webp","assets/images/boards/c/helia_x11.webp","assets/images/boards/c/helia_x36.webp","assets/images/boards/c/helia_x41.webp","assets/images/boards/helia_banner.webp"],"skip":[0,2,6,9],"en":[["The challenge","Helia was founded by two Argentinian friends in Amsterdam who couldn’t find snacks that were genuinely healthy, without excess sugar or hard-to-pronounce ingredients. They needed a brand for clean protein bars that felt as vibrant as their lifestyle."],["The concept","<b>“Your daily dose of sunshine.”</b> Helia channels the energy of the sun into honest snacks, bringing the light that’s often missing from Amsterdam’s grey days. Values of vitality, transparency, simplicity and community shape everything."],["The system","A bold, sculptural wordmark with a sun symbol that also works on its own, a palette of sky blue and sunlight yellow with gradients from sunrise to sundown, a geometric sans with mono accents, and sun-filled illustrations — applied to packaging, totes, billboards and social media."]],"es":[["El desafío","Helia nace de dos amigas argentinas en Ámsterdam que no encontraban snacks realmente saludables, sin exceso de azúcar ni ingredientes impronunciables. Necesitaban una marca de barritas proteicas clean que se sintiera tan vibrante como su estilo de vida."],["El concepto","<b>“Your daily dose of sunshine.”</b> Helia canaliza la energía del sol en snacks honestos, llevando la luz que tantas veces falta en los días grises de Ámsterdam. Vitalidad, transparencia, simpleza y comunidad guían todo."],["El sistema","Un wordmark audaz y escultórico con un símbolo de sol que funciona solo, una paleta de celeste cielo y amarillo sol con degradés del amanecer al atardecer, una sans geométrica con acentos en mono e ilustraciones soleadas, aplicado a packaging, totes, carteles y redes."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    21,
    'fat-dog',
    'Fat Dog',
    '2025',
    'Buenos Aires',
    'Buenos Aires',
    ARRAY['branding','illustration']::text[],
    'assets/images/projects/p21_3.webp',
    'Meet Fat Dog —— the new on-the-go pancho spot in Bs. As. where hot dogs takes center stage🌭✨

For their launch, we created a short but bold visual identity, covering the essentials—— logo, colors, fonts and a custom illustration to bring their unique vibe to life.

A club for true hot dog lovers with a no-nonsense that matches their street-food spirit

Fat Dog ;)',
    'Meet Fat Dog —— the new on-the-go pancho spot in Bs. As. where hot dogs takes center stage🌭✨

For their launch, we created a short but bold visual identity, covering the essentials—— logo, colors, fonts and a custom illustration to bring their unique vibe to life.

A club for true hot dog lovers with a no-nonsense that matches their street-food spirit

Fat Dog ;)',
    '',
    'published',
    false,
    NULL,
    21,
    '[{"type":"i","url":"assets/images/projects/p21_0.webp"},{"type":"i","url":"assets/images/projects/p21_1.webp"},{"type":"i","url":"assets/images/projects/p21_2.webp"},{"type":"i","url":"assets/images/projects/p21_3.webp"},{"type":"i","url":"assets/images/projects/p21_4.webp"},{"type":"i","url":"assets/images/projects/p21_5.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    22,
    'life-of-tyrol',
    'Life of Tyrol',
    '2024',
    'Fashion',
    'Moda',
    ARRAY['branding']::text[],
    'assets/images/projects/p22_0.webp',
    'Crafting a Legacy: @lifeoftyrol 

Introducing 2024 branding for LOT —— a brand that redefines modern elegance with timeless principles. For Life of Tyrol, we blended the precision of the golden ratio with the raw, grounding essence of nature to create a logo that resonates with harmony, balance and purpose.

We translated the brand’s ethos into visuals that exude sophistication, depth and conscious living.

This project was a journey of designing for the authentic men who values substance and connection: 

step into Tyrol’s world —— where timeless elegance meets purposeful living🙏🏼',
    'Crafting a Legacy: @lifeoftyrol 

Introducing 2024 branding for LOT —— a brand that redefines modern elegance with timeless principles. For Life of Tyrol, we blended the precision of the golden ratio with the raw, grounding essence of nature to create a logo that resonates with harmony, balance and purpose.

We translated the brand’s ethos into visuals that exude sophistication, depth and conscious living.

This project was a journey of designing for the authentic men who values substance and connection: 

step into Tyrol’s world —— where timeless elegance meets purposeful living🙏🏼',
    '',
    'published',
    false,
    NULL,
    22,
    '[{"type":"i","url":"assets/images/projects/p22_0.webp"},{"type":"v","url":"assets/media/p22_v0.mp4","poster":"assets/media/p22_v0.webp"},{"type":"i","url":"assets/images/projects/p22_1.webp"},{"type":"i","url":"assets/images/projects/p22_2.webp"},{"type":"i","url":"assets/images/projects/p22_3.webp"},{"type":"i","url":"assets/images/projects/p22_4.webp"},{"type":"i","url":"assets/images/projects/p22_5.webp"},{"type":"i","url":"assets/images/projects/p22_8.webp"},{"type":"i","url":"assets/images/projects/p22_9.webp"},{"type":"i","url":"assets/images/projects/p22_11.webp"},{"type":"i","url":"assets/images/projects/p22_12.webp"},{"type":"i","url":"assets/images/projects/p22_13.webp"},{"type":"i","url":"assets/images/projects/p22_14.webp"},{"type":"i","url":"assets/images/projects/p22_15.webp"},{"type":"i","url":"assets/images/projects/p22_16.webp"},{"type":"i","url":"assets/images/projects/p22_17.webp"},{"type":"i","url":"assets/images/projects/p22_18.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/lot_0.webp","assets/images/boards/c/lot_3.webp","assets/images/boards/c/lot_8.webp","assets/images/boards/c/lot_x5.webp","assets/images/boards/c/lot_x8.webp","assets/images/boards/c/lot_x37.webp"],"skip":[],"en":[["The challenge","Life of Tyrol is a menswear brand that fuses exclusive design with sustainability and wellbeing. The identity needed to feel timeless and elegant, while carrying a deeper purpose."],["The concept","Inspired by the golden ratio and natural balance: <b>“Phi as a guide to harmony and purpose”</b> and personal growth as a journey. Values of authenticity, timeless elegance, conscious sustainability and harmony — “Live a LOT”."],["The system","A classic serif logotype and a LOT monogram built on the golden ratio, an isotype inspired by a cypress, an earthy palette led by black-and-white photography, and timeless, elegant serifs with a humanist sans — applied to bags, labels, packaging, signage and social media."]],"es":[["El desafío","Life of Tyrol es una marca de moda masculina que fusiona diseño exclusivo con sostenibilidad y bienestar. La identidad tenía que sentirse atemporal y elegante, pero con un propósito más profundo."],["El concepto","Inspirada en la proporción áurea y el equilibrio natural: <b>“Phi como guía de armonía y propósito”</b> y el crecimiento personal como viaje. Autenticidad, elegancia atemporal, sostenibilidad consciente y armonía: “Live a LOT”."],["El sistema","Un logotipo serif clásico y un monograma LOT construidos sobre la proporción áurea, un isotipo inspirado en un ciprés, una paleta terrosa guiada por fotografía en blanco y negro, y serifs elegantes y atemporales junto a una sans humanista, aplicado a bolsos, etiquetas, packaging, cartelería y redes."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    26,
    'oak-summer-club',
    'Oak Summer Club',
    '2024',
    'Punta del Este',
    'Punta del Este',
    ARRAY['branding']::text[],
    'assets/images/projects/p26_1.webp',
    '‘25 season started in Punta del Este —— introducing brand identity for a summer nightclub in Uruguay, capturing the soul of endless summer nights

Join the vibe at @oakpde 🇺🇾 ;)',
    '‘25 season started in Punta del Este —— introducing brand identity for a summer nightclub in Uruguay, capturing the soul of endless summer nights

Join the vibe at @oakpde 🇺🇾 ;)',
    '',
    'published',
    false,
    NULL,
    23,
    '[{"type":"i","url":"assets/images/projects/p26_0.webp"},{"type":"i","url":"assets/images/projects/p26_1.webp"},{"type":"i","url":"assets/images/projects/p26_2.webp"},{"type":"i","url":"assets/images/projects/p26_3.webp"},{"type":"i","url":"assets/images/projects/p26_4.webp"},{"type":"i","url":"assets/images/projects/p26_5.webp"},{"type":"i","url":"assets/images/projects/p26_6.webp"},{"type":"i","url":"assets/images/projects/p26_7.webp"},{"type":"i","url":"assets/images/projects/p26_8.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    34,
    'homero',
    'Homero',
    '2024',
    'Pilar, Buenos Aires',
    'Pilar, Buenos Aires',
    ARRAY['branding','illustration']::text[],
    'assets/images/projects/p34_1.webp',
    '@homeroparrilla_ visual identity for Homero —— an upscale grill in Pilar, Buenos Aires. Project working alongside one of my best friends :) @panchigonzalez__  We’re incredibly proud of the outcome and so grateful for trusting us with the vision.

Treat yourself to their finest meat at Homero!',
    '@homeroparrilla_ visual identity for Homero —— an upscale grill in Pilar, Buenos Aires. Project working alongside one of my best friends :) @panchigonzalez__  We’re incredibly proud of the outcome and so grateful for trusting us with the vision.

Treat yourself to their finest meat at Homero!',
    '',
    'published',
    false,
    NULL,
    24,
    '[{"type":"i","url":"assets/images/projects/p34_0.webp"},{"type":"i","url":"assets/images/projects/p34_1.webp"},{"type":"i","url":"assets/images/projects/p34_2.webp"},{"type":"i","url":"assets/images/projects/p34_3.webp"},{"type":"i","url":"assets/images/projects/p34_4.webp"},{"type":"i","url":"assets/images/projects/p34_5.webp"},{"type":"i","url":"assets/images/projects/p34_6.webp"},{"type":"i","url":"assets/images/projects/p34_7.webp"},{"type":"i","url":"assets/images/projects/p34_8.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    35,
    'silvia-sver',
    'Silvia Sver',
    '2024',
    'Artist',
    'Artista',
    ARRAY['branding']::text[],
    'assets/images/projects/p35_0.webp',
    'visual identity for Silvia Sver ——— an Argentinian artist whose journey of transformation inspired a brand rooted in metamorphosis and duality. Through depth, sensitivity and connection, we captured her process, her art and identity, reflecting her profound essence 🤍 un placer trabajar con vos @silvia.sver',
    'visual identity for Silvia Sver ——— an Argentinian artist whose journey of transformation inspired a brand rooted in metamorphosis and duality. Through depth, sensitivity and connection, we captured her process, her art and identity, reflecting her profound essence 🤍 un placer trabajar con vos @silvia.sver',
    '',
    'published',
    false,
    NULL,
    25,
    '[{"type":"i","url":"assets/images/projects/p35_0.webp"},{"type":"i","url":"assets/images/projects/p35_1.webp"},{"type":"i","url":"assets/images/projects/p35_2.webp"},{"type":"i","url":"assets/images/projects/p35_3.webp"},{"type":"v","url":"assets/media/p35_v0.mp4","poster":"assets/media/p35_v0.webp"},{"type":"i","url":"assets/images/projects/p35_4.webp"},{"type":"i","url":"assets/images/projects/p35_5.webp"},{"type":"i","url":"assets/images/projects/p35_6.webp"},{"type":"i","url":"assets/images/projects/p35_7.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    38,
    'reformer',
    'Reformer',
    '2024',
    'Wellness club',
    'Wellness club',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p38_0.webp',
    'Reformer, wellness club | branding, visual identity & website :)

We designed the brand identity for Reformer and then brought it to life online with a fully custom digital experience — a custom landing page and an all-in-one booking system to simplify class scheduling and management, fully optimized for desktop and mobile use.

From concept to execution, we created:
- A visual identity built around balance, strength and softness
- A clean, functional landing page aligned with the brand
- A custom class booking system with calendar view
- A personalized user dashboard to manage bookings and payments
- An intuitive admin panel for bookings, payments, class and schedule management
A seamless experience • users and studio staff',
    'Reformer, wellness club | branding, visual identity & website :)

We designed the brand identity for Reformer and then brought it to life online with a fully custom digital experience — a custom landing page and an all-in-one booking system to simplify class scheduling and management, fully optimized for desktop and mobile use.

From concept to execution, we created:
- A visual identity built around balance, strength and softness
- A clean, functional landing page aligned with the brand
- A custom class booking system with calendar view
- A personalized user dashboard to manage bookings and payments
- An intuitive admin panel for bookings, payments, class and schedule management
A seamless experience • users and studio staff',
    'https://www.reformer.com.ar',
    'published',
    false,
    NULL,
    26,
    '[{"type":"i","url":"assets/images/projects/p38_0.webp"},{"type":"v","url":"assets/media/p38_v0.mp4","poster":"assets/media/p38_v0.webp"},{"type":"i","url":"assets/images/projects/p38_1.webp"},{"type":"i","url":"assets/images/projects/p38_2.webp"},{"type":"i","url":"assets/images/projects/p38_3.webp"},{"type":"i","url":"assets/images/projects/p38_4.webp"},{"type":"i","url":"assets/images/projects/p38_5.webp"},{"type":"i","url":"assets/images/projects/p38_6.webp"},{"type":"i","url":"assets/images/projects/p38_7.webp"},{"type":"i","url":"assets/images/projects/p38_w1.webp"},{"type":"i","url":"assets/images/projects/p38_w2.webp"},{"type":"i","url":"assets/images/projects/p38_w3.webp"},{"type":"i","url":"assets/images/projects/p38_w4.webp"},{"type":"v","url":"assets/media/p38_w0.mp4","poster":"assets/media/p38_w0.webp"},{"type":"v","url":"assets/media/p38_w1.mp4","poster":"assets/media/p38_w1.webp"},{"type":"v","url":"assets/media/p38_w2.mp4","poster":"assets/media/p38_w2.webp"},{"type":"v","url":"assets/media/p38_w3.mp4","poster":"assets/media/p38_w3.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/reformer_0.webp","assets/images/boards/c/reformer_1.webp","assets/images/boards/c/reformer_2.webp","assets/images/boards/c/reformer_3.webp","assets/images/boards/c/reformer_5.webp","assets/images/boards/c/reformer_6.webp","assets/images/boards/c/reformer_10.webp","assets/images/boards/c/reformer_11.webp"],"skip":[],"en":[["The challenge","Reformer is a wellness club for pilates and yoga that believes in the integral transformation of the human being, where body and mind meet in balance. The brand had to feel calm and elevated, while carrying the strength of the practice."],["The concept","<b>Equilibrio Transformador</b> and <b>Energía en Evolución</b>: strength and softness coexisting in every session. The R isotype fuses both ideas with a central axis of balance that represents physical transformation and mental wellbeing."],["The system & the website","A refined logotype with an R isotype and a star as the main graphic element, an elegant serif with a soft sans and mono details, a warm neutral palette and an icon universe of energy, balance and flow. Later we designed and developed the website: a custom landing page, a class booking system with calendar view, a user dashboard and an admin panel."]],"es":[["El desafío","Reformer es un wellness club de pilates y yoga que cree en la transformación integral del ser humano, donde cuerpo y mente se encuentran en equilibrio. La marca tenía que sentirse calma y elevada, pero con la fuerza de la práctica."],["El concepto","<b>Equilibrio Transformador</b> y <b>Energía en Evolución</b>: la fuerza y la suavidad conviviendo en cada sesión. El isotipo R fusiona ambas ideas con un eje central de equilibrio que representa la transformación física y el bienestar mental."],["El sistema y la web","Un logotipo refinado con isotipo R y una estrella como elemento gráfico principal, una serif elegante junto a una sans suave y detalles en mono, una paleta neutra y cálida y un universo de íconos de energía, equilibrio y flujo. Después diseñamos y desarrollamos la web: landing a medida, sistema de reservas con calendario, dashboard de usuario y panel de administración."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    72,
    'punto-studio',
    'Punto Studio',
    '2026',
    'Architecture studio · Buenos Aires',
    'Architecture studio · Buenos Aires',
    ARRAY['branding']::text[],
    'assets/images/projects/p72_0.webp',
    'Punto Studio | brand kit for an architecture studio ○
Punto Studio designs and remodels homes and commercial spaces in Buenos Aires.

We created a calm, warm and contemporary identity: a custom logotype with soft, organic curves and its own symbol — the punto — a palette of espresso, mocha, mint and ivory, and a typographic duo that balances clean and editorial.

Applied to stationery, signage, the website and social media.',
    'Punto Studio | brand kit for an architecture studio ○
Punto Studio designs and remodels homes and commercial spaces in Buenos Aires.

We created a calm, warm and contemporary identity: a custom logotype with soft, organic curves and its own symbol — the punto — a palette of espresso, mocha, mint and ivory, and a typographic duo that balances clean and editorial.

Applied to stationery, signage, the website and social media.',
    '',
    'published',
    false,
    NULL,
    27,
    '[{"type":"i","url":"assets/images/projects/p72_0.webp"},{"type":"i","url":"assets/images/projects/p72_1.webp"},{"type":"i","url":"assets/images/projects/p72_2.webp"},{"type":"i","url":"assets/images/projects/p72_3.webp"},{"type":"i","url":"assets/images/projects/p72_4.webp"},{"type":"i","url":"assets/images/projects/p72_5.webp"},{"type":"i","url":"assets/images/projects/p72_6.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/punto_cov.webp","assets/images/boards/c/punto_logos.webp","assets/images/boards/c/punto_grid.webp","assets/images/boards/c/punto_vers.webp","assets/images/boards/c/punto_type.webp"],"skip":[1,6],"en":[["The challenge","Punto Studio is an architecture studio in Buenos Aires focused on remodelling homes and commercial spaces. They needed a brand kit that felt as warm and considered as the spaces they design."],["The concept","Everything starts at a <b>point</b>: the first line of a plan, the place where a project begins. The name became the symbol — a soft, organic punto that brings warmth and a human touch to the precision of architecture."],["The system","A custom logotype with rounded, organic curves in horizontal, compact and vertical versions, a symbol that works on its own, a palette of espresso, mocha, mint and ivory, and a clean sans paired with an elegant editorial serif — applied to stationery, signage, the website and social media."]],"es":[["El desafío","Punto Studio es un estudio de arquitectura de Buenos Aires especializado en remodelaciones de hogares y locales comerciales. Necesitaban un brand kit que se sintiera tan cálido y pensado como los espacios que diseñan."],["El concepto","Todo empieza en un <b>punto</b>: la primera línea de un plano, el lugar donde nace un proyecto. El nombre se volvió símbolo: un punto suave y orgánico que le suma calidez y un toque humano a la precisión de la arquitectura."],["El sistema","Un logotipo a medida con curvas redondeadas y orgánicas en versiones horizontal, compacta y vertical, un símbolo que funciona solo, una paleta de espresso, moka, menta y marfil, y una sans limpia junto a una serif editorial elegante, aplicado a papelería, cartelería, la web y redes."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    82,
    'green-waste',
    'Green Waste',
    '2025',
    'Organic waste shredders',
    'Trituradores orgánicos',
    ARRAY['branding']::text[],
    'assets/images/projects/p82_0.webp',
    'Green Waste | brand kit for organic waste shredders ♻️

Green Waste designs kitchen shredders that turn organic waste into something useful — a simple, everyday gesture with a real impact on the planet.

A friendly, rounded wordmark, a palette that moves from soft mint to deep forest green, a family of organic icons and a photographic world of leaves, forests and mountains.

The power to change your tomorrow, today.',
    'Green Waste | brand kit for organic waste shredders ♻️

Green Waste designs kitchen shredders that turn organic waste into something useful — a simple, everyday gesture with a real impact on the planet.

A friendly, rounded wordmark, a palette that moves from soft mint to deep forest green, a family of organic icons and a photographic world of leaves, forests and mountains.

The power to change your tomorrow, today.',
    '',
    'published',
    false,
    NULL,
    28,
    '[{"type":"i","url":"assets/images/projects/p82_0.webp"},{"type":"v","url":"assets/media/p82_v0.mp4","poster":"assets/media/p82_v0.webp"},{"type":"i","url":"assets/images/projects/p82_1.webp"},{"type":"i","url":"assets/images/projects/p82_2.webp"},{"type":"i","url":"assets/images/projects/p82_3.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/greenwaste_0.webp","assets/images/boards/c/greenwaste_1.webp","assets/images/boards/c/greenwaste_2.webp"],"skip":[],"en":[["The challenge","Green Waste brings organic waste shredders into the home kitchen. The brand needed to make a technical appliance feel approachable and to turn recycling into a simple, everyday gesture."],["The concept","<b>“The power to change your tomorrow, today.”</b> A green cycle for your kitchen: what we throw away becomes the beginning of something new. Small daily decisions with a real impact on the planet."],["The system","A friendly, rounded wordmark, a palette that moves from soft mint to deep forest green, a family of organic icons built from drops, leaves and flowers, and a photographic world of leaves, forests and mountains — applied to social media, product communication and key visuals."]],"es":[["El desafío","Green Waste lleva los trituradores de residuos orgánicos a la cocina de casa. La marca tenía que hacer que un electrodoméstico técnico se sintiera cercano y convertir el reciclaje en un gesto simple y cotidiano."],["El concepto","<b>“The power to change your tomorrow, today.”</b> Un ciclo verde para tu cocina: lo que tiramos se convierte en el comienzo de algo nuevo. Pequeñas decisiones diarias con un impacto real en el planeta."],["El sistema","Un wordmark amigable y redondeado, una paleta que va del menta suave al verde bosque profundo, una familia de íconos orgánicos construidos con gotas, hojas y flores, y un universo fotográfico de hojas, bosques y montañas, aplicado a redes, comunicación de producto y key visuals."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    84,
    'hasta-la-proxima-vez',
    'Hasta la próxima vez',
    '2025',
    'Single cover · Joaquín Martínez',
    'Portada de single · Joaquín Martínez',
    ARRAY['illustration','editorial']::text[],
    'assets/images/projects/p84_0.webp',
    'Hasta la próxima vez | single cover for Joaquín Martínez ft. Tomás Jara 🌅

A hand-painted illustration of two friends sitting on a pier at sunset — warm coral skies reflected on the water, framed by a quiet, minimal layout.

A cover about goodbyes that feel like a promise.',
    'Hasta la próxima vez | single cover for Joaquín Martínez ft. Tomás Jara 🌅

A hand-painted illustration of two friends sitting on a pier at sunset — warm coral skies reflected on the water, framed by a quiet, minimal layout.

A cover about goodbyes that feel like a promise.',
    '',
    'published',
    false,
    NULL,
    29,
    '[{"type":"i","url":"assets/images/projects/p84_0.webp"},{"type":"i","url":"assets/images/projects/p84_1.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    78,
    'acida',
    'Ácida',
    '2025',
    'Pickles brand · Buenos Aires',
    'Marca de pickles · Buenos Aires',
    ARRAY['branding','illustration']::text[],
    'assets/images/projects/p78_0.webp',
    'Ácida | brand concept 🥒💗

Cucumber pickles with personality, flavour and attitude — for real girlies who refuse to lower the volume of their personality.

We built the strategy and the first steps of the identity: an expressive script logotype with a dripping, liquid base, a monochrome palette with internal contrasts, an editorial serif, and two illustrated friends inspired by the founders.

Tu chispa diaria de acidez.',
    'Ácida | brand concept 🥒💗

Cucumber pickles with personality, flavour and attitude — for real girlies who refuse to lower the volume of their personality.

We built the strategy and the first steps of the identity: an expressive script logotype with a dripping, liquid base, a monochrome palette with internal contrasts, an editorial serif, and two illustrated friends inspired by the founders.

Tu chispa diaria de acidez.',
    '',
    'published',
    false,
    NULL,
    30,
    '[{"type":"i","url":"assets/images/projects/p78_0.webp"},{"type":"i","url":"assets/images/projects/p78_1.webp"},{"type":"i","url":"assets/images/projects/p78_2.webp"},{"type":"i","url":"assets/images/projects/p78_3.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/c/acida_0.webp"],"skip":[],"en":[["The challenge","Ácida makes cucumber pickles, a classic usually forgotten at the back of the fridge. The goal was to turn it into a snack with style and attitude, built for young, urban women who want brands with personality."],["The concept","<b>“La acidez como el sabor de lo auténtico”</b> — acidity as the taste of authenticity. Being ácida isn’t just a flavour, it’s a way of being in the world: no masks, no filters, with your own style. A community of real girlies, different from each other but united by the same craving."],["The system","An expressive script logotype with a liquid, dripping base, a monochrome palette with internal contrasts in pink and deep red, an editorial serif for the brand phrases, and two illustrated friends inspired by the founders — different in style and energy, but always together."]],"es":[["El desafío","Ácida hace pickles de pepino, un clásico que suele quedar olvidado al fondo de la heladera. El objetivo era convertirlo en un snack con estilo y actitud, pensado para mujeres jóvenes y urbanas que buscan marcas con personalidad."],["El concepto","<b>“La acidez como el sabor de lo auténtico.”</b> Ser ácida no es solo un sabor, es una manera de estar en el mundo: sin caretas, sin vueltas, con estilo propio. Una comunidad de girlies reales, distintas entre sí pero unidas por el mismo antojo."],["El sistema","Un logotipo script expresivo con una base líquida que gotea, una paleta monocromática con contrastes internos en rosa y rojo profundo, una serif editorial para las frases de marca, y dos amigas ilustradas inspiradas en las dueñas: distintas en estilo y energía, pero siempre juntas."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    70,
    'martina-y-agustin',
    'Martina & Agustín',
    '2026',
    'Wedding · Buenos Aires',
    'Casamiento · Buenos Aires',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p70_web.webp',
    'Martina & Agustín | wedding brand kit, save the date & website 🤍

A wedding identity designed to feel elegant, romantic and full of personality — a black tie celebration at Palacio Duhau, Buenos Aires.

From the brand kit and the save the date — hand-torn paper, delicate lace and a classic script — to a custom wedding website where guests can find every detail, the dress code and the moodboard, and confirm their attendance.

Timeless, intimate and a little bit cinematic.',
    'Martina & Agustín | wedding brand kit, save the date & website 🤍

A wedding identity designed to feel elegant, romantic and full of personality — a black tie celebration at Palacio Duhau, Buenos Aires.

From the brand kit and the save the date — hand-torn paper, delicate lace and a classic script — to a custom wedding website where guests can find every detail, the dress code and the moodboard, and confirm their attendance.

Timeless, intimate and a little bit cinematic.',
    '',
    'published',
    false,
    NULL,
    31,
    '[{"type":"w","url":"assets/images/projects/p70_web.webp","scrollPct":78.72},{"type":"i","url":"assets/images/projects/p70_0.webp"}]'::jsonb,
    '{"bb":[],"skip":[],"en":[["The brief","A black tie wedding at Palacio Duhau that needed its own identity: elegant and timeless, but romantic and with the couple’s personality in every detail."],["The concept","<b>Romance with personality.</b> Classic elegance — lace, candlelight, black and ivory — balanced with intimate, cinematic moments that feel like them."],["The system","A wedding brand kit with a refined script and a classic serif, an ivory and warm-taupe palette with deep blacks, and a save the date on hand-torn paper inside a lace envelope. It extends to a custom wedding website with the details, dress code, moodboard, RSVP and gifts."]],"es":[["El brief","Un casamiento black tie en el Palacio Duhau que necesitaba su propia identidad: elegante y atemporal, pero romántica y con la personalidad de la pareja en cada detalle."],["El concepto","<b>Romance con personalidad.</b> Elegancia clásica —encaje, luz de velas, negro y marfil— equilibrada con momentos íntimos y cinematográficos que los representan."],["El sistema","Un brand kit de casamiento con una script refinada y una serif clásica, una paleta de marfil y topo cálido con negros profundos, y un save the date en papel rasgado a mano dentro de un sobre de encaje. Se extiende a una web de casamiento a medida con los detalles, el dress code, el moodboard, el RSVP y los regalos."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    50,
    'covos-arquitectos',
    'Covos Arquitectos',
    '2025',
    'Architecture studio · Buenos Aires & Punta del Este',
    'Estudio de arquitectura · Buenos Aires & Punta del Este',
    ARRAY['branding','web']::text[],
    'assets/images/projects/p50_0.webp',
    'Brand identity for Covos Arquitectos, an architecture studio that comes from a family of architects — designing, projecting and building their clients’ dreams.

A solid, warm and timeless identity: a geometric isotype, a clean wordmark, a palette of stone and earth tones and a single geometric sans family, designed to live across the website, social media, presentations and signage.',
    'Brand identity for Covos Arquitectos, an architecture studio that comes from a family of architects — designing, projecting and building their clients’ dreams.

A solid, warm and timeless identity: a geometric isotype, a clean wordmark, a palette of stone and earth tones and a single geometric sans family, designed to live across the website, social media, presentations and signage.',
    'https://www.covosarquitectos.com/',
    'published',
    false,
    NULL,
    32,
    '[{"type":"i","url":"assets/images/projects/p50_0.webp"}]'::jsonb,
    '{"bb":["assets/images/boards/covos_0.webp","assets/images/boards/covos_1.webp","assets/images/boards/covos_2.webp","assets/images/boards/covos_3.webp","assets/images/boards/covos_4.webp","assets/images/boards/covos_5.webp","assets/images/boards/covos_6.webp","assets/images/boards/covos_7.webp","assets/images/boards/covos_8.webp"],"skip":[0],"noig":true,"en":[["The challenge","Covos Arquitectos is a studio that comes from a family of architects: they design, project and build, making their clients’ dreams real. They needed an identity as solid and warm as the homes they create."],["The concept","<b>Arquitectos desde siempre</b> — architects since always. A brand built on legacy and craft, that speaks of the whole process, from the first sketch to the finished home."],["The system","A geometric isotype that evokes a folded plane and an open door, a clean wordmark with variants and tagline, a palette of stone and earth greys, and a single geometric sans family — applied to the website, social media, presentations and signage."]],"es":[["El desafío","Covos Arquitectos es un estudio que viene de una familia de arquitectos: diseñan, proyectan y construyen, haciendo realidad los sueños de sus clientes. Necesitaban una identidad tan sólida y cálida como las casas que crean."],["El concepto","<b>Arquitectos desde siempre.</b> Una marca construida sobre el legado y el oficio, que habla de todo el proceso, del primer boceto a la casa terminada."],["El sistema","Un isotipo geométrico que evoca un plano plegado y una puerta abierta, un wordmark limpio con variables y tagline, una paleta de grises piedra y tierra, y una única familia sans geométrica, aplicado a la web, redes, presentaciones y cartelería."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    52,
    'football-town',
    'Football Town',
    '2024',
    'Vintage football fashion',
    'Moda futbolera vintage',
    ARRAY['illustration','social']::text[],
    'assets/images/projects/p52_0.webp',
    'Football Town ⚽️ | graphic design for @footballtownofficial, a vintage football jersey brand with a fashion approach.

For a whole year I designed jerseys and apparel for different teams — prints, logos, inside details, color combinations and formats — plus content for social media.

The biggest project: the full collection design & creative direction for the ''24 Cup Season vintage drop, inspired by the 2024 Euro Cup and Copa América.

Alongside it, a series of illustrated icons :) iconic players brought to life for tribute jersey launches.',
    'Football Town ⚽️ | graphic design for @footballtownofficial, a vintage football jersey brand with a fashion approach.

For a whole year I designed jerseys and apparel for different teams — prints, logos, inside details, color combinations and formats — plus content for social media.

The biggest project: the full collection design & creative direction for the ''24 Cup Season vintage drop, inspired by the 2024 Euro Cup and Copa América.

Alongside it, a series of illustrated icons :) iconic players brought to life for tribute jersey launches.',
    '',
    'published',
    false,
    NULL,
    33,
    '[{"type":"i","url":"assets/images/projects/p52_0.webp"},{"type":"i","url":"assets/images/projects/p52_1.webp"},{"type":"i","url":"assets/images/projects/p52_2.webp"},{"type":"i","url":"assets/images/projects/p52_3.webp"},{"type":"i","url":"assets/images/projects/p52_4.webp"},{"type":"i","url":"assets/images/projects/p52_5.webp"},{"type":"v","url":"assets/media/p52_v0.mp4","poster":"assets/media/p52_v0.webp"},{"type":"i","url":"assets/images/projects/p52_6.webp"},{"type":"i","url":"assets/images/projects/p52_7.webp"},{"type":"i","url":"assets/images/projects/p52_8.webp"},{"type":"i","url":"assets/images/projects/p52_9.webp"},{"type":"i","url":"assets/images/projects/p52_10.webp"}]'::jsonb,
    '{"bb":[],"skip":[],"en":[["The brand","Football Town is a vintage football jersey brand with a fashion approach — shirts made to wear, not to play in. For a whole year I worked as their graphic designer, designing jerseys and apparel for different teams, plus content for social media."],["The work","Most of the work happened on existing garments: designing the prints, the logos, the inside details and defining color combinations and formats for each piece. The biggest project was the <b>''24 Cup Season vintage collection</b>, a full drop designed for the Copa América and the Euro Cup."],["The illustrations","Alongside the collection, I illustrated a series of iconic players. Each illustration was created for a tribute jersey launch, turning football legends into a graphic language that lives on the shirts and across social media."]],"es":[["La marca","Football Town es una marca de camisetas de fútbol vintage con una mirada fashion: camisetas para usar, no para jugar. Durante un año entero trabajé como su diseñadora gráfica, diseñando camisetas e indumentaria para distintos equipos y material para redes sociales."],["El trabajo","La mayor parte del trabajo fue sobre prendas existentes: diseñar las estampas, los logos y los detalles interiores, y definir las combinaciones de colores y formatos de cada pieza. El proyecto más grande fue la <b>colección vintage ''24 Cup Season</b>, un drop completo pensado para la Copa América y la Eurocopa."],["Las ilustraciones","Además de la colección, ilustré una serie de jugadores icónicos. Cada ilustración acompañó el lanzamiento de una camiseta homenaje, llevando a las leyendas del fútbol a un lenguaje gráfico que vive en las prendas y en redes."]]}'::jsonb
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    32,
    'el-club-de-la-milanesa',
    'El Club de la Milanesa',
    '2024',
    'Miami',
    'Miami',
    ARRAY['social']::text[],
    'assets/images/projects/p32_0.webp',
    'social media visual identity for @elclubdelamilanesa.us — bringing the best Argentinian food to Miami, working alongside @poise_digitalstudio for their monthly instagram design :)',
    'social media visual identity for @elclubdelamilanesa.us — bringing the best Argentinian food to Miami, working alongside @poise_digitalstudio for their monthly instagram design :)',
    '',
    'published',
    false,
    NULL,
    34,
    '[{"type":"v","url":"assets/media/p32_v0.mp4","poster":"assets/media/p32_v0.webp"},{"type":"i","url":"assets/images/projects/p32_0.webp"},{"type":"i","url":"assets/images/projects/p32_1.webp"},{"type":"i","url":"assets/images/projects/p32_2.webp"},{"type":"i","url":"assets/images/projects/p32_3.webp"},{"type":"v","url":"assets/media/p32_v1.mp4","poster":"assets/media/p32_v1.webp"},{"type":"v","url":"assets/media/p32_v2.mp4","poster":"assets/media/p32_v2.webp"},{"type":"i","url":"assets/images/projects/p32_4.webp"},{"type":"v","url":"assets/media/p32_v3.mp4","poster":"assets/media/p32_v3.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    74,
    'spirited-away',
    'Spirited Away',
    '2025',
    'Personal project',
    'Proyecto personal',
    ARRAY['illustration','editorial']::text[],
    'assets/images/projects/p74_0.webp',
    'Spirited Away | personal print 🌸

A poster I designed for my own home, inspired by one of my all-time favourite films.

“Nothing that happens is ever forgotten, even if you can’t remember it.”',
    'Spirited Away | personal print 🌸

A poster I designed for my own home, inspired by one of my all-time favourite films.

“Nothing that happens is ever forgotten, even if you can’t remember it.”',
    '',
    'published',
    false,
    NULL,
    35,
    '[{"type":"i","url":"assets/images/projects/p74_0.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;

INSERT INTO public.projects (
    legacy_id, slug, name, year, place, place_pt, tags,
    cover_url, caption_pt, caption_en, web_url, status,
    featured, featured_order, display_order, media, proc
) VALUES (
    30,
    'fontana-barok',
    'Fontana Barok',
    '2024',
    'Restaurant bar · Núñez',
    'Restaurant bar · Núñez',
    ARRAY['illustration','social']::text[],
    'assets/images/projects/p30_0.webp',
    'menu & social media design and illustration for @fontanabarok side by side with @poise_digitalstudio ——— Núñez, Bs. As.

check it out :)',
    'menu & social media design and illustration for @fontanabarok side by side with @poise_digitalstudio ——— Núñez, Bs. As.

check it out :)',
    '',
    'published',
    false,
    NULL,
    36,
    '[{"type":"i","url":"assets/images/projects/p30_0.webp"},{"type":"i","url":"assets/images/projects/p30_1.webp"},{"type":"v","url":"assets/media/p30_v0.mp4","poster":"assets/media/p30_v0.webp"},{"type":"i","url":"assets/images/projects/p30_2.webp"},{"type":"i","url":"assets/images/projects/p30_3.webp"},{"type":"v","url":"assets/media/p30_v1.mp4","poster":"assets/media/p30_v1.webp"}]'::jsonb,
    NULL
)
ON CONFLICT (slug) DO UPDATE SET
    legacy_id = EXCLUDED.legacy_id,
    name = EXCLUDED.name,
    year = EXCLUDED.year,
    place = EXCLUDED.place,
    place_pt = EXCLUDED.place_pt,
    tags = EXCLUDED.tags,
    cover_url = EXCLUDED.cover_url,
    caption_pt = EXCLUDED.caption_pt,
    caption_en = EXCLUDED.caption_en,
    web_url = EXCLUDED.web_url,
    status = EXCLUDED.status,
    featured = EXCLUDED.featured,
    featured_order = EXCLUDED.featured_order,
    display_order = EXCLUDED.display_order,
    media = EXCLUDED.media,
    proc = EXCLUDED.proc;
