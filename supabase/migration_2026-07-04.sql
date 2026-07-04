-- ============================================================================
-- Migración de catálogo CutiLuminar — 2026-07-04
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query → Run
-- (corre como owner de la base, no necesita ninguna clave ni login aparte)
-- ============================================================================

-- ── 1) Nueva categoría: Vapes ───────────────────────────────────────────────
insert into public.categories (name, slug, order_index, is_active)
values ('Vapes', 'vapes', 9, true)
on conflict (slug) do nothing;

-- ── 2) Actualiza precios / nombres de productos existentes ─────────────────
update public.products set price = 55000 where id = 'ce780c54-4f37-44ef-bce6-841143b72a91';
update public.products set price = 45000 where id = 'c0ab1a73-309a-49d4-9079-a746fb134c45';
update public.products set price = 42000 where id = 'e791a33f-bc21-4c8d-8864-8c5c3d10e466';
update public.products set price = 59500, full_description = 'Fragancia masculina vibrante y moderna (familia olfativa Ámbar Amaderada), muy elogiada por su excelente relación calidad-precio y su estilo tipo gourmand.', short_description = 'Fragancia masculina vibrante y moderna (familia olfativa Ámbar Amaderada), muy elogiada por su excelente relación calidad-precio y su estilo tipo gourmand.' where id = '7fbc6a72-e62e-4f31-96d1-32aa70df6248';
update public.products set price = 14500 where id = 'a00db423-a5c1-490a-99e3-7eb8a6f890ae';
update public.products set price = 14500 where id = '4c450172-b1d7-4b7e-84e2-564a36194aaa';
update public.products set price = 9500 where id = '503288d1-e0a9-47ef-8a78-229f729e4bd7';
update public.products set price = 7500 where id = 'bfae751a-53ad-4a22-9815-7a8dfed8863b';
update public.products set price = 9000 where id = 'de3ee9e6-e2dc-44dc-98a3-adc23819ef6f';
update public.products set price = 155200, name = 'WORLD CUP VIP ZAKAT EDP 80ML AZUL' where id = '6b893cc0-2e10-4608-a91c-6092d411a65f';
update public.products set badge = null where id = 'c7161e55-2854-4396-ad15-811e0a90390d';

-- ── 3) 46 productos nuevos + su imagen principal ───────────────────────────
-- Las imágenes ya están en el repo (carpeta img/) y se sirven como archivos
-- estáticos junto al sitio, por eso image_url es una ruta relativa.

insert into public.products (id, name, short_description, full_description, price, category_id, stock, is_active, is_featured, badge, order_index)
values
  ('194a12c5-27bb-4d13-bbff-4016e906f715', 'WORLD CUP VIP ZAKAT EDP 80ML VERDE', 'Versión regular de la colección del Mundial. Perfil tropical y exótico.', 'Versión regular de la colección del Mundial. Perfil tropical y exótico.', 120500, (select id from public.categories where slug = 'perfumes'), 10, true, true, 'nuevo', 109),
  ('14087b1d-f411-438f-8527-a16199436993', 'LATTAFA KHAMRAH WAHA 100ML EDP', 'Adapta el famoso ADN de Khamrah hacia una faceta fresca, cítrica y acuática, ideal para primavera o climas templados.', 'Adapta el famoso ADN de Khamrah hacia una faceta fresca, cítrica y acuática, ideal para primavera o climas templados.', 115165, (select id from public.categories where slug = 'perfumes'), 10, true, true, 'nuevo', 110),
  ('9aa224b2-f9ef-415a-8208-a7356a4d768b', 'LATTAFA ANA ABIYEDH 60ML EDP', 'Fragancia unisex de la colección más popular de Lattafa. Aromas sofisticados, de alta calidad y excelente fijación.', 'Fragancia unisex de la colección más popular de Lattafa. Aromas sofisticados, de alta calidad y excelente fijación.', 29450, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 111),
  ('2a9b0040-8792-4b1c-9bb5-e438303c3c94', 'LATTAFA ANA ABIYEDH SCARLET 60ML EDP', 'Floral Frutal Gourmand. Frasco elegante con detalles dorados y tapón color vino tinto.', 'Floral Frutal Gourmand. Frasco elegante con detalles dorados y tapón color vino tinto.', 29450, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 112),
  ('cbbab5fd-2301-4c55-a338-e9bbbede8e6e', 'LATTAFA ANA ABIYEDH ROUGE 60ML EDP', 'Gran parecido al icónico Baccarat Rouge 540, en una propuesta mucho más accesible, dulce y caramelizada.', 'Gran parecido al icónico Baccarat Rouge 540, en una propuesta mucho más accesible, dulce y caramelizada.', 29450, (select id from public.categories where slug = 'perfumes'), 10, true, true, 'nuevo', 113),
  ('d2322e44-4ca0-4b38-b3bb-ad8cf54af649', 'LATTAFA ANA ABIYEDH CORAL 60ML EDP', 'Propuesta tropical, frutal y vibrante inspirada en Wavechild de Room 1015. Dulce, estilo chicle de sandía.', 'Propuesta tropical, frutal y vibrante inspirada en Wavechild de Room 1015. Dulce, estilo chicle de sandía.', 29450, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 114),
  ('8686cd0c-45e2-4d7a-9796-0a27d924bca0', 'LATTAFA TERIAQ EDP 100ML', 'Oriental gourmand unisex. Creación original del célebre perfumista francés Quentin Bisch, no un clon.', 'Oriental gourmand unisex. Creación original del célebre perfumista francés Quentin Bisch, no un clon.', 46190, (select id from public.categories where slug = 'perfumes'), 10, true, true, 'nuevo', 115),
  ('a39056e3-e9b6-4cae-b5ee-6a9977657df2', 'LATTAFA AL NOBLE AMEER 100ML EDP', 'Oriental amaderada y especiada. Gran parecido al exclusivo Rosendo Mateu Nº 5.', 'Oriental amaderada y especiada. Gran parecido al exclusivo Rosendo Mateu Nº 5.', 39000, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 116),
  ('346b9a44-47b6-4c5f-a7c0-35ae2bd1a44f', 'LATTAFA AL NOBLE WAZEER 100ML EDP', 'Opción unisex y económica dentro de la perfumería de nicho del Medio Oriente.', 'Opción unisex y económica dentro de la perfumería de nicho del Medio Oriente.', 41000, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 117),
  ('4b98a132-e45c-4c18-a677-d3e8acbff852', 'LATTAFA AL NOBLE SAFEER 100ML EDP', 'Oriental amaderada. Aroma verde, herbal y cítrico. Botella verde gamuza con tapón cabeza de ciervo.', 'Oriental amaderada. Aroma verde, herbal y cítrico. Botella verde gamuza con tapón cabeza de ciervo.', 41000, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 118),
  ('1ee11749-0e84-4c4a-a429-fceb719c42e3', 'LATTAFA FIRE ON ICE U 100ML EDP', 'Frasco inspirado en un vaso de whisky con hielo. Compleja mezcla de calidez y frescura.', 'Frasco inspirado en un vaso de whisky con hielo. Compleja mezcla de calidez y frescura.', 31000, (select id from public.categories where slug = 'perfumes'), 10, true, false, 'nuevo', 119),
  ('cbfa3304-602d-4040-8cf4-a4055a6f2721', 'Auricular Ezra NO EZ071', 'Diseño cómodo especial para dormir. Color Blanco.', 'Diseño cómodo especial para dormir. Color Blanco.', 36008, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 120),
  ('fd840543-ea9a-49a4-94d6-742e0d295ba8', 'Auricular Ezra TWS67', 'Bluetooth con estuche de carga. Negros / Blancos.', 'Bluetooth con estuche de carga. Negros / Blancos.', 17612, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 121),
  ('9b5b69fe-888f-4a5a-8b9e-a120da7e0e7b', 'Auricular Ezra TWs53', 'Bluetooth con funda protectora incluida. Color Blanco.', 'Bluetooth con funda protectora incluida. Color Blanco.', 23800, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 122),
  ('63c40187-21ee-4104-b603-9797d7974d6f', 'Auricular Ezra TWS149', 'Con imán deportivo para mayor sujeción. Color Negro.', 'Con imán deportivo para mayor sujeción. Color Negro.', 32032, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 123),
  ('5fc19e9e-96b0-4141-91d4-df123c7f59fc', 'Auricular E6S Económicos', 'True Wireless básicos. Color Negro.', 'True Wireless básicos. Color Negro.', 7300, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 124),
  ('dc50dbc9-7c0c-4248-9b5c-4f1be882c726', 'Auricular Ezra Cable Tipo C', 'Auricular con cable, conector Tipo C.', 'Auricular con cable, conector Tipo C.', 5600, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 125),
  ('c42a26b5-6839-4a78-84d0-0986fabe8e66', 'Auricular Ezra Cable Auxiliar', 'Auricular con cable, conector auxiliar 3.5mm.', 'Auricular con cable, conector auxiliar 3.5mm.', 4400, (select id from public.categories where slug = 'auriculares'), 10, true, false, 'nuevo', 126),
  ('462771a0-1b7f-4fe6-b64e-511a96151046', 'Auricular Ezra Vincha BT Pure Bass', 'Vincha Bluetooth con cancelación de sonido. Azul / Rosa.', 'Vincha Bluetooth con cancelación de sonido. Azul / Rosa.', 49500, (select id from public.categories where slug = 'auriculares'), 10, true, true, 'nuevo', 127),
  ('d1a6f2db-403a-4328-899e-84f88a7da993', 'Parlante con 2 Micrófonos Mini', 'Incluye 2 micrófonos. Color Celeste.', 'Incluye 2 micrófonos. Color Celeste.', 16800, (select id from public.categories where slug = 'parlantes'), 10, true, false, 'nuevo', 128),
  ('861adf74-24c0-4975-a533-4961c11dadcc', 'Parlante Ezra NL90', 'Portátil tipo boombox con iluminación LED RGB. Color Negro.', 'Portátil tipo boombox con iluminación LED RGB. Color Negro.', 35190, (select id from public.categories where slug = 'parlantes'), 10, true, false, 'nuevo', 129),
  ('0e008158-4861-47da-9f26-120dd89955d6', 'Parlante Ezra Led NL69', 'Con luces LED RGB. Color Negro.', 'Con luces LED RGB. Color Negro.', 42840, (select id from public.categories where slug = 'parlantes'), 10, true, false, 'nuevo', 130),
  ('60b321f1-6040-4833-8005-f24bb6014b98', 'Micrófono Corbatero Lambo Tech F9', 'Pack x2 micrófonos inalámbricos.', 'Pack x2 micrófonos inalámbricos.', 22360, (select id from public.categories where slug = 'parlantes'), 10, true, false, 'nuevo', 131),
  ('1adb54a4-5ba3-4ad4-9e6b-d0671e7c599d', 'Micrófono Corbatero Lambo Peluche F15', 'Con cobertor peludo antiviento.', 'Con cobertor peludo antiviento.', 22360, (select id from public.categories where slug = 'parlantes'), 10, true, false, 'nuevo', 132),
  ('d5db1f26-84bd-430b-9f35-e6d3af1b16e4', 'Soporte Estuche Bici / Moto', 'Estuche plástico waterproof con soporte para manubrio.', 'Estuche plástico waterproof con soporte para manubrio.', 8700, (select id from public.categories where slug = 'soportes'), 10, true, false, 'nuevo', 133),
  ('d93df98e-02df-4c26-b052-7acbab8a3dab', 'Soporte Magnético Ventosa Beige', 'Con soporte, giro 360°. Color Beige.', 'Con soporte, giro 360°. Color Beige.', 7200, (select id from public.categories where slug = 'soportes'), 10, true, false, 'nuevo', 134),
  ('555830bd-acda-433e-a568-4c31b95527fb', 'Soporte Magnético Ventosa Lila', 'Con sujetador, giro 360°. Color Lila.', 'Con sujetador, giro 360°. Color Lila.', 7200, (select id from public.categories where slug = 'soportes'), 10, true, false, 'nuevo', 135),
  ('d06735cc-bff3-4360-946a-053a36cef3ce', 'Linterna Lambo P50', 'Led recargable, distintos niveles de iluminación. Variedad de tamaños de luz.', 'Led recargable, distintos niveles de iluminación. Variedad de tamaños de luz.', 16300, (select id from public.categories where slug = 'gadgets'), 10, true, false, 'nuevo', 136),
  ('3b233324-81ee-48a2-89ba-47c9988b9f19', 'Walkie Talkie Baofeng', 'Profesionales. Pack x2.', 'Profesionales. Pack x2.', 49400, (select id from public.categories where slug = 'gadgets'), 10, true, false, 'nuevo', 137),
  ('a238b561-22c4-4847-8789-57ec38a57f6c', 'Cargador + Soporte Ezra 4en1', '15W. Carga celular + reloj + auriculares al mismo tiempo.', '15W. Carga celular + reloj + auriculares al mismo tiempo.', 49000, (select id from public.categories where slug = 'cargadores'), 10, true, false, 'nuevo', 138),
  ('66658b8e-c122-4280-a913-7f65a23af10c', 'Cargador iPhone Ezra 20W', 'Puerto C USB + cable USB a Lightning.', 'Puerto C USB + cable USB a Lightning.', 11600, (select id from public.categories where slug = 'cargadores'), 10, true, false, 'nuevo', 139),
  ('9c77536e-78b3-43aa-9771-11355b73aeaf', 'Cargador LDNIO 20W', 'Puerto C USB + cable C a C.', 'Puerto C USB + cable C a C.', 13900, (select id from public.categories where slug = 'cargadores'), 10, true, false, 'nuevo', 140),
  ('6ee0848a-5a55-4a61-a4a7-458b0f23b4c4', 'Vape Supreme 18K Puff', 'Sabor Strawberry Banana.', 'Sabor Strawberry Banana.', 20000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 141),
  ('9418d1f0-a507-4eb4-967f-5dafaf1b1bdc', 'Vape ElfBar BC 15K Puff', 'Sabor Kiwi Passion Fruit Guava.', 'Sabor Kiwi Passion Fruit Guava.', 20000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 142),
  ('89534bb8-db59-45e3-b3bc-393d150dad81', 'Vape ElfBar BC 15K Puff', 'Sabor Sour Apple Ice.', 'Sabor Sour Apple Ice.', 20000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 143),
  ('b394a918-3708-487a-9071-e9a237fcf63d', 'Vape ElfBar TE 30K Puff', 'Sabor Strawberry Ice.', 'Sabor Strawberry Ice.', 27000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 144),
  ('b13ab314-84b1-4490-8db7-05c2d54b3062', 'Vape ElfBar TE 30K Puff', 'Sabor Bubbaloo Grape.', 'Sabor Bubbaloo Grape.', 27000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 145),
  ('32330242-233d-4f9d-b1d9-625f0ef08fec', 'Vape ElfBar TE 30K Puff', 'Sabor Bubbaloo Tutti Frutti.', 'Sabor Bubbaloo Tutti Frutti.', 27000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 146),
  ('8781b65b-b3f5-4dfa-a704-e7652dce35f0', 'Vape ElfBar Ice King 40K Puff', 'Sabor Blue Razz Ice.', 'Sabor Blue Razz Ice.', 28000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 147),
  ('3d3b9837-5012-43bf-b6c0-1d4a893c5ae9', 'Vape ElfBar Ice King 40K Puff', 'Sabor Peach+.', 'Sabor Peach+.', 28000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 148),
  ('5ab477fe-f7e1-48ff-93b2-d354d01a58b3', 'Vape ElfBar Ice King 40K Puff', 'Sabor Cherry Strazz.', 'Sabor Cherry Strazz.', 28000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 149),
  ('afb56816-8575-4693-8a18-1f94d3edcb4d', 'Vape ElfBar Ice King 40K Puff', 'Sabor Double Apple Ice.', 'Sabor Double Apple Ice.', 28000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 150),
  ('fb6d2374-7fd8-48bd-83f3-562f17fa44d3', 'Vape ElfBar Ice King 40K Puff', 'Sabor Strawberry Watermelon.', 'Sabor Strawberry Watermelon.', 28000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 151),
  ('9e10d5a6-4d1a-415b-9974-33047e2762fa', 'Vape ElfBar Ice King 40K Puff', 'Sabor Watermelon Ice.', 'Sabor Watermelon Ice.', 28000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 152),
  ('6e145ff6-ab85-49a3-8484-4b7cb944cbb3', 'Vape ElfBar Trio 40K Puff', 'Sabor Raspberry Watermelon.', 'Sabor Raspberry Watermelon.', 30000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 153),
  ('384c674a-c638-402b-87f1-3538c6cfdf2b', 'Vape ElfBar Trio 40K Puff', 'Sabor Strawberry Orange Lime.', 'Sabor Strawberry Orange Lime.', 30000, (select id from public.categories where slug = 'vapes'), 10, true, false, 'nuevo', 154);

insert into public.product_images (product_id, image_url, is_main, order_index)
values
  ('194a12c5-27bb-4d13-bbff-4016e906f715', 'img/image109.jpg', true, 0),
  ('14087b1d-f411-438f-8527-a16199436993', 'img/image110.jpg', true, 0),
  ('9aa224b2-f9ef-415a-8208-a7356a4d768b', 'img/image111.jpg', true, 0),
  ('2a9b0040-8792-4b1c-9bb5-e438303c3c94', 'img/image112.jpg', true, 0),
  ('cbbab5fd-2301-4c55-a338-e9bbbede8e6e', 'img/image113.jpg', true, 0),
  ('d2322e44-4ca0-4b38-b3bb-ad8cf54af649', 'img/image114.jpg', true, 0),
  ('8686cd0c-45e2-4d7a-9796-0a27d924bca0', 'img/image115.jpg', true, 0),
  ('a39056e3-e9b6-4cae-b5ee-6a9977657df2', 'img/image116.jpg', true, 0),
  ('346b9a44-47b6-4c5f-a7c0-35ae2bd1a44f', 'img/image117.jpg', true, 0),
  ('4b98a132-e45c-4c18-a677-d3e8acbff852', 'img/image118.jpg', true, 0),
  ('1ee11749-0e84-4c4a-a429-fceb719c42e3', 'img/image119.jpg', true, 0),
  ('cbfa3304-602d-4040-8cf4-a4055a6f2721', 'img/image120.jpg', true, 0),
  ('fd840543-ea9a-49a4-94d6-742e0d295ba8', 'img/image121.jpg', true, 0),
  ('9b5b69fe-888f-4a5a-8b9e-a120da7e0e7b', 'img/image122.jpg', true, 0),
  ('63c40187-21ee-4104-b603-9797d7974d6f', 'img/image123.jpg', true, 0),
  ('5fc19e9e-96b0-4141-91d4-df123c7f59fc', 'img/image124.jpg', true, 0),
  ('dc50dbc9-7c0c-4248-9b5c-4f1be882c726', 'img/image125.jpg', true, 0),
  ('c42a26b5-6839-4a78-84d0-0986fabe8e66', 'img/image126.jpg', true, 0),
  ('462771a0-1b7f-4fe6-b64e-511a96151046', 'img/image127.jpg', true, 0),
  ('d1a6f2db-403a-4328-899e-84f88a7da993', 'img/image128.jpg', true, 0),
  ('861adf74-24c0-4975-a533-4961c11dadcc', 'img/image129.jpg', true, 0),
  ('0e008158-4861-47da-9f26-120dd89955d6', 'img/image130.jpg', true, 0),
  ('60b321f1-6040-4833-8005-f24bb6014b98', 'img/image131.jpg', true, 0),
  ('1adb54a4-5ba3-4ad4-9e6b-d0671e7c599d', 'img/image132.jpg', true, 0),
  ('d5db1f26-84bd-430b-9f35-e6d3af1b16e4', 'img/image133.jpg', true, 0),
  ('d93df98e-02df-4c26-b052-7acbab8a3dab', 'img/image134.jpg', true, 0),
  ('555830bd-acda-433e-a568-4c31b95527fb', 'img/image135.jpg', true, 0),
  ('d06735cc-bff3-4360-946a-053a36cef3ce', 'img/image136.jpg', true, 0),
  ('3b233324-81ee-48a2-89ba-47c9988b9f19', 'img/image137.jpg', true, 0),
  ('a238b561-22c4-4847-8789-57ec38a57f6c', 'img/image138.jpg', true, 0),
  ('66658b8e-c122-4280-a913-7f65a23af10c', 'img/image139.jpg', true, 0),
  ('9c77536e-78b3-43aa-9771-11355b73aeaf', 'img/image140.jpg', true, 0),
  ('6ee0848a-5a55-4a61-a4a7-458b0f23b4c4', 'img/image141.jpg', true, 0),
  ('9418d1f0-a507-4eb4-967f-5dafaf1b1bdc', 'img/image142.jpg', true, 0),
  ('89534bb8-db59-45e3-b3bc-393d150dad81', 'img/image143.jpg', true, 0),
  ('b394a918-3708-487a-9071-e9a237fcf63d', 'img/image144.jpg', true, 0),
  ('b13ab314-84b1-4490-8db7-05c2d54b3062', 'img/image145.jpg', true, 0),
  ('32330242-233d-4f9d-b1d9-625f0ef08fec', 'img/image146.jpg', true, 0),
  ('8781b65b-b3f5-4dfa-a704-e7652dce35f0', 'img/image147.jpg', true, 0),
  ('3d3b9837-5012-43bf-b6c0-1d4a893c5ae9', 'img/image148.jpg', true, 0),
  ('5ab477fe-f7e1-48ff-93b2-d354d01a58b3', 'img/image149.jpg', true, 0),
  ('afb56816-8575-4693-8a18-1f94d3edcb4d', 'img/image150.jpg', true, 0),
  ('fb6d2374-7fd8-48bd-83f3-562f17fa44d3', 'img/image151.jpg', true, 0),
  ('9e10d5a6-4d1a-415b-9974-33047e2762fa', 'img/image152.jpg', true, 0),
  ('6e145ff6-ab85-49a3-8484-4b7cb944cbb3', 'img/image153.jpg', true, 0),
  ('384c674a-c638-402b-87f1-3538c6cfdf2b', 'img/image154.jpg', true, 0);

-- ============================================================================
-- Fin. Refrescá el sitio (Ctrl+F5) para ver los 46 productos nuevos
-- y los precios actualizados.
-- ============================================================================