-- ============================================================
-- FOLEY PROPERTY TRACKER — SUPABASE SETUP
-- Paste this entire file into your Supabase SQL Editor and click Run
-- supabase.com → your project → SQL Editor → New Query → paste → Run
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ── PROFILES (one row per user, auto-created on signup) ──────
create table if not exists profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  name text not null default '',
  created_at timestamptz default now()
);

-- Auto-create profile on user signup
create or replace function handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into profiles (id, name)
  values (new.id, coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- ── TASKS ────────────────────────────────────────────────────
create table if not exists tasks (
  id text primary key,
  name text not null,
  cat text default '',
  area text default '',
  freq text default '',
  priority text default 'Medium',
  status text default 'Not Started',
  who text default 'Both',
  last_done text default '',
  time_est text default '',
  equipment text default '',
  notes text default '',
  updated_at timestamptz default now(),
  updated_by uuid references profiles(id)
);

-- ── HOUSEHOLD ────────────────────────────────────────────────
create table if not exists household (
  id text primary key,
  name text not null,
  area text default '',
  type text default 'Inside',
  freq text default 'Monthly',
  priority text default 'Medium',
  who text default 'Both',
  done boolean default false,
  last_done text default '',
  time_est text default '',
  notes text default '',
  updated_at timestamptz default now(),
  updated_by uuid references profiles(id)
);

-- ── PROJECTS ─────────────────────────────────────────────────
create table if not exists projects (
  id text primary key,
  name text not null,
  cat text default '',
  priority text default 'Medium',
  status text default 'Not Started',
  season text default 'Spring',
  who text default 'Both',
  cost numeric default 0,
  target_date text default '',
  notes text default '',
  updated_at timestamptz default now(),
  updated_by uuid references profiles(id)
);

-- ── FOOD ─────────────────────────────────────────────────────
create table if not exists food (
  id text primary key,
  name text not null,
  type text default 'Dry',
  location text default '',
  cat text default 'Staples',
  qty numeric default 0,
  unit text default '',
  useby text default '',
  restock boolean default false,
  used_up boolean default false,
  notes text default '',
  updated_at timestamptz default now(),
  updated_by uuid references profiles(id)
);

-- ── MOWERS ───────────────────────────────────────────────────
create table if not exists mowers (
  id text primary key,
  name text not null,
  type text default '',
  area text default '',
  status text default 'Active',
  hours text default '',
  oil text default '',
  blade text default '',
  battery text default '',
  belt text default '',
  storage text default 'Mower Storage',
  notes text default '',
  updated_at timestamptz default now(),
  updated_by uuid references profiles(id)
);

-- ── EVENTS (calendar) ────────────────────────────────────────
create table if not exists events (
  id text primary key,
  title text not null,
  cat text default 'other',
  who text default 'Both',
  start_date text not null,
  end_date text default '',
  all_day boolean default true,
  start_time text default '',
  end_time text default '',
  repeat text default 'none',
  repeat_end text default '',
  notes text default '',
  updated_at timestamptz default now(),
  updated_by uuid references profiles(id)
);

-- ── PRESENCE (who is online / what page they're on) ─────────
create table if not exists presence (
  user_id uuid references profiles(id) on delete cascade primary key,
  name text default '',
  page text default 'dashboard',
  last_seen timestamptz default now()
);

-- ── ENABLE REALTIME on all tables ────────────────────────────
alter publication supabase_realtime add table tasks;
alter publication supabase_realtime add table household;
alter publication supabase_realtime add table projects;
alter publication supabase_realtime add table food;
alter publication supabase_realtime add table mowers;
alter publication supabase_realtime add table events;
alter publication supabase_realtime add table presence;

-- ── ROW LEVEL SECURITY ───────────────────────────────────────
-- Both users can read/write everything (it's a shared household tracker)
alter table tasks     enable row level security;
alter table household enable row level security;
alter table projects  enable row level security;
alter table food      enable row level security;
alter table mowers    enable row level security;
alter table events    enable row level security;
alter table presence  enable row level security;
alter table profiles  enable row level security;

-- Allow any authenticated user to read/write all rows
create policy "authenticated_all" on tasks     for all to authenticated using (true) with check (true);
create policy "authenticated_all" on household for all to authenticated using (true) with check (true);
create policy "authenticated_all" on projects  for all to authenticated using (true) with check (true);
create policy "authenticated_all" on food      for all to authenticated using (true) with check (true);
create policy "authenticated_all" on mowers    for all to authenticated using (true) with check (true);
create policy "authenticated_all" on events    for all to authenticated using (true) with check (true);
create policy "authenticated_all" on presence  for all to authenticated using (true) with check (true);
create policy "authenticated_all" on profiles  for all to authenticated using (true) with check (true);

-- ── DONE ─────────────────────────────────────────────────────
-- Your database is ready.
-- Next: go back to the DEPLOY.md instructions.
