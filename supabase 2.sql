create extension if not exists pgcrypto;

create table if not exists public.entrainements (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  time time not null,
  type text not null default 'Entraînement',
  place text not null default 'Strasbourg',
  responsable text null,
  created_at timestamptz not null default now(),
  unique(date,time)
);

alter table public.entrainements enable row level security;

drop policy if exists "lecture publique" on public.entrainements;
drop policy if exists "prendre une séance libre" on public.entrainements;
drop policy if exists "liberer une séance" on public.entrainements;
drop policy if exists "ajouter séance admin" on public.entrainements;
drop policy if exists "supprimer séance admin" on public.entrainements;

create policy "lecture publique" on public.entrainements
for select to anon, authenticated using (true);

create policy "prendre une séance libre" on public.entrainements
for update to anon, authenticated
using (responsable is null)
with check (responsable is not null);

create policy "liberer une séance" on public.entrainements
for update to authenticated using (true) with check (true);

create policy "ajouter séance admin" on public.entrainements
for insert to authenticated with check (true);

create policy "supprimer séance admin" on public.entrainements
for delete to authenticated using (true);

alter table public.entrainements replica identity full;
