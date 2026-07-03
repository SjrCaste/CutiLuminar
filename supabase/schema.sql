-- ============================================================================
-- CutiLuminar — Esquema de base de datos para catálogo de productos
-- Ejecutar UNA SOLA VEZ en: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================================

create extension if not exists pgcrypto;
create extension if not exists unaccent;

-- ── Email del único usuario administrador. Las políticas de seguridad (RLS)
--    solo otorgan permisos de escritura a este email exacto.
--    Si en el futuro cambiás el email del admin, actualizá también las
--    políticas más abajo (buscar 'admin@cutiluminar.com').
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────
-- FUNCIONES AUXILIARES
-- ────────────────────────────────────────────────────────────────────────

create or replace function public.slugify(input text)
returns text
language sql
immutable
as $$
  select trim(both '-' from
    regexp_replace(
      lower(unaccent(coalesce(input, ''))),
      '[^a-z0-9]+', '-', 'g'
    )
  );
$$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ────────────────────────────────────────────────────────────────────────
-- TABLA: categories
-- ────────────────────────────────────────────────────────────────────────

create table if not exists public.categories (
  id           uuid primary key default gen_random_uuid(),
  name         text not null check (char_length(trim(name)) > 0),
  slug         text unique not null,
  description  text,
  is_active    boolean not null default true,
  order_index  integer not null default 0,
  created_at   timestamptz not null default now()
);

create or replace function public.set_category_slug()
returns trigger
language plpgsql
as $$
declare
  base_slug text;
  candidate text;
  i int := 1;
begin
  if new.slug is null or trim(new.slug) = '' then
    base_slug := public.slugify(new.name);
  else
    base_slug := public.slugify(new.slug);
  end if;
  if base_slug = '' then
    base_slug := 'categoria';
  end if;
  candidate := base_slug;
  while exists (
    select 1 from public.categories
    where slug = candidate and id <> coalesce(new.id, '00000000-0000-0000-0000-000000000000'::uuid)
  ) loop
    i := i + 1;
    candidate := base_slug || '-' || i;
  end loop;
  new.slug := candidate;
  return new;
end;
$$;

drop trigger if exists trg_category_slug on public.categories;
create trigger trg_category_slug
  before insert or update of name, slug on public.categories
  for each row execute function public.set_category_slug();

-- ────────────────────────────────────────────────────────────────────────
-- TABLA: products
-- ────────────────────────────────────────────────────────────────────────

create table if not exists public.products (
  id                 uuid primary key default gen_random_uuid(),
  name               text not null check (char_length(trim(name)) > 0),
  slug               text unique not null,
  short_description  text,
  full_description   text,
  price              numeric(12,2) not null check (price >= 0),
  old_price          numeric(12,2) check (old_price is null or old_price >= 0),
  category_id        uuid references public.categories(id) on delete set null,
  stock              integer not null default 0 check (stock >= 0),
  is_active          boolean not null default true,
  is_featured        boolean not null default false,
  badge              text check (badge is null or badge in ('nuevo','oferta','mas_vendido','sin_stock')),
  order_index        integer not null default 0,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create index if not exists idx_products_category on public.products(category_id);
create index if not exists idx_products_active on public.products(is_active);
create index if not exists idx_products_featured on public.products(is_featured);
create index if not exists idx_products_order on public.products(order_index);

create or replace function public.set_product_slug()
returns trigger
language plpgsql
as $$
declare
  base_slug text;
  candidate text;
  i int := 1;
begin
  if new.slug is null or trim(new.slug) = '' then
    base_slug := public.slugify(new.name);
  else
    base_slug := public.slugify(new.slug);
  end if;
  if base_slug = '' then
    base_slug := 'producto';
  end if;
  candidate := base_slug;
  while exists (
    select 1 from public.products
    where slug = candidate and id <> coalesce(new.id, '00000000-0000-0000-0000-000000000000'::uuid)
  ) loop
    i := i + 1;
    candidate := base_slug || '-' || i;
  end loop;
  new.slug := candidate;
  return new;
end;
$$;

drop trigger if exists trg_product_slug on public.products;
create trigger trg_product_slug
  before insert or update of name, slug on public.products
  for each row execute function public.set_product_slug();

drop trigger if exists trg_product_updated_at on public.products;
create trigger trg_product_updated_at
  before update on public.products
  for each row execute function public.set_updated_at();

-- ────────────────────────────────────────────────────────────────────────
-- TABLA: product_images
-- ────────────────────────────────────────────────────────────────────────

create table if not exists public.product_images (
  id           uuid primary key default gen_random_uuid(),
  product_id   uuid not null references public.products(id) on delete cascade,
  image_url    text not null check (char_length(trim(image_url)) > 0),
  alt_text     text,
  order_index  integer not null default 0,
  is_main      boolean not null default false,
  created_at   timestamptz not null default now()
);

create index if not exists idx_product_images_product on public.product_images(product_id);

-- Solo puede haber una imagen principal por producto: al marcar una como
-- principal, se desmarca automáticamente cualquier otra del mismo producto.
create or replace function public.enforce_single_main_image()
returns trigger
language plpgsql
as $$
begin
  if new.is_main then
    update public.product_images
    set is_main = false
    where product_id = new.product_id
      and id <> new.id
      and is_main = true;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_single_main_image on public.product_images;
create trigger trg_single_main_image
  before insert or update of is_main on public.product_images
  for each row execute function public.enforce_single_main_image();

-- Si un producto se queda sin ninguna imagen marcada como principal,
-- promueve automáticamente a la primera (por order_index) como principal.
create or replace function public.promote_main_image_if_missing()
returns trigger
language plpgsql
as $$
declare
  pid uuid;
begin
  pid := coalesce(old.product_id, new.product_id);
  if not exists (select 1 from public.product_images where product_id = pid and is_main = true) then
    update public.product_images
    set is_main = true
    where id = (
      select id from public.product_images
      where product_id = pid
      order by order_index asc, created_at asc
      limit 1
    );
  end if;
  return null;
end;
$$;

drop trigger if exists trg_promote_main_image on public.product_images;
create trigger trg_promote_main_image
  after insert or delete or update of is_main on public.product_images
  for each row execute function public.promote_main_image_if_missing();

-- ────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- El público (clave publishable/anon) solo puede LEER categorías/productos
-- activos. Solo el usuario admin (autenticado con el email exacto) puede
-- crear, editar o eliminar.
-- ────────────────────────────────────────────────────────────────────────

alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_images enable row level security;

-- categories
drop policy if exists "public read active categories" on public.categories;
create policy "public read active categories"
  on public.categories for select
  to anon
  using (is_active = true);

drop policy if exists "admin read all categories" on public.categories;
create policy "admin read all categories"
  on public.categories for select
  to authenticated
  using ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

drop policy if exists "admin write categories" on public.categories;
create policy "admin write categories"
  on public.categories for all
  to authenticated
  using ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com')
  with check ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

-- products
drop policy if exists "public read active products" on public.products;
create policy "public read active products"
  on public.products for select
  to anon
  using (is_active = true);

drop policy if exists "admin read all products" on public.products;
create policy "admin read all products"
  on public.products for select
  to authenticated
  using ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

drop policy if exists "admin write products" on public.products;
create policy "admin write products"
  on public.products for all
  to authenticated
  using ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com')
  with check ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

-- product_images
drop policy if exists "public read images of active products" on public.product_images;
create policy "public read images of active products"
  on public.product_images for select
  to anon
  using (
    exists (
      select 1 from public.products p
      where p.id = product_images.product_id and p.is_active = true
    )
  );

drop policy if exists "admin read all images" on public.product_images;
create policy "admin read all images"
  on public.product_images for select
  to authenticated
  using ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

drop policy if exists "admin write images" on public.product_images;
create policy "admin write images"
  on public.product_images for all
  to authenticated
  using ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com')
  with check ((auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

-- ────────────────────────────────────────────────────────────────────────
-- STORAGE: bucket público para imágenes de productos
-- ────────────────────────────────────────────────────────────────────────

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

drop policy if exists "public read product images bucket" on storage.objects;
create policy "public read product images bucket"
  on storage.objects for select
  to anon
  using (bucket_id = 'product-images');

drop policy if exists "admin write product images bucket" on storage.objects;
create policy "admin write product images bucket"
  on storage.objects for all
  to authenticated
  using (bucket_id = 'product-images' and (auth.jwt() ->> 'email') = 'admin@cutiluminar.com')
  with check (bucket_id = 'product-images' and (auth.jwt() ->> 'email') = 'admin@cutiluminar.com');

-- ────────────────────────────────────────────────────────────────────────
-- PERMISOS DE BASE (RLS filtra filas, pero además hace falta el GRANT a
-- nivel de tabla para que los roles anon/authenticated puedan acceder).
-- ────────────────────────────────────────────────────────────────────────

grant usage on schema public to anon, authenticated, service_role;

grant select on public.categories, public.products, public.product_images to anon;
grant select, insert, update, delete on public.categories, public.products, public.product_images to authenticated;
grant all on public.categories, public.products, public.product_images to service_role;

-- ============================================================================
-- Fin del esquema. Después de ejecutar esto, avisá para continuar con la
-- migración de categorías, productos e imágenes existentes.
-- ============================================================================
