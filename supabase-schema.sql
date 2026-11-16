create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  category text not null,
  price numeric(10, 2) not null check (price >= 0),
  image_url text not null default '',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
grant select on public.products to anon, authenticated;
grant insert, update, delete on public.products to authenticated;

drop policy if exists "Public read active products" on public.products;
create policy "Public read active products"
  on public.products for select
  to anon, authenticated
  using (active or (select auth.jwt() ->> 'email') = 'elorriii02@gmail.com');

drop policy if exists "Admin insert products" on public.products;
create policy "Admin insert products"
  on public.products for insert
  to authenticated
  with check ((select auth.jwt() ->> 'email') = 'elorriii02@gmail.com');

drop policy if exists "Admin update products" on public.products;
create policy "Admin update products"
  on public.products for update
  to authenticated
  using ((select auth.jwt() ->> 'email') = 'elorriii02@gmail.com')
  with check ((select auth.jwt() ->> 'email') = 'elorriii02@gmail.com');

drop policy if exists "Admin delete products" on public.products;
create policy "Admin delete products"
  on public.products for delete
  to authenticated
  using ((select auth.jwt() ->> 'email') = 'elorriii02@gmail.com');

insert into public.products (slug, name, category, price)
values
  ('layered-gold-necklace', 'Layered Gold Necklace', 'Necklaces', 180),
  ('pearl-drop-necklace', 'Pearl Drop Necklace', 'Necklaces', 220),
  ('statement-hoop-earrings', 'Statement Hoop Earrings', 'Earrings', 120),
  ('crystal-stud-earrings', 'Crystal Stud Earrings', 'Earrings', 90),
  ('twist-band-ring', 'Twist Band Ring', 'Rings', 100),
  ('stackable-ring-set', 'Stackable Ring Set', 'Rings', 150),
  ('charm-bracelet', 'Charm Bracelet', 'Bracelets', 160),
  ('gift-set-necklace-earrings', 'Gift Set: Necklace + Earrings', 'Gift sets', 300)
on conflict (slug) do nothing;

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "Public read product images" on storage.objects;
create policy "Public read product images"
  on storage.objects for select
  to public
  using (bucket_id = 'product-images');

drop policy if exists "Admin upload product images" on storage.objects;
create policy "Admin upload product images"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'product-images'
    and (select auth.jwt() ->> 'email') = 'elorriii02@gmail.com'
  );

drop policy if exists "Admin update product images" on storage.objects;
create policy "Admin update product images"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'product-images'
    and (select auth.jwt() ->> 'email') = 'elorriii02@gmail.com'
  )
  with check (
    bucket_id = 'product-images'
    and (select auth.jwt() ->> 'email') = 'elorriii02@gmail.com'
  );

drop policy if exists "Admin delete product images" on storage.objects;
create policy "Admin delete product images"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'product-images'
    and (select auth.jwt() ->> 'email') = 'elorriii02@gmail.com'
  );
