-- Apply in the Supabase SQL Editor or with `supabase db push`.
-- Email authentication is managed by Supabase Auth; these tables expose only
-- the signed-in user's profile and audit events under row-level security.
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.auth_access_logs (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  email text not null,
  event_type text not null check (event_type in ('sign_up', 'sign_in')),
  created_at timestamptz not null default now()
);

insert into public.profiles (id, email)
select id, email from auth.users where email is not null
on conflict (id) do update set email = excluded.email;

create index if not exists auth_access_logs_user_created_idx
  on public.auth_access_logs (user_id, created_at desc);

alter table public.profiles enable row level security;
alter table public.auth_access_logs enable row level security;

drop policy if exists "Users can read their own profile" on public.profiles;
create policy "Users can read their own profile"
  on public.profiles for select to authenticated
  using ((select auth.uid()) = id);

drop policy if exists "Users can read their own access logs" on public.auth_access_logs;
create policy "Users can read their own access logs"
  on public.auth_access_logs for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can record their own access events" on public.auth_access_logs;
create policy "Users can record their own access events"
  on public.auth_access_logs for insert to authenticated
  with check ((select auth.uid()) = user_id and email = (select auth.jwt() ->> 'email'));

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email)
  on conflict (id) do update set email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert or update of email on auth.users
  for each row execute procedure public.handle_new_auth_user();

revoke all on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;
revoke all on public.auth_access_logs from anon, authenticated;
grant select, insert on public.auth_access_logs to authenticated;
grant usage, select on sequence public.auth_access_logs_id_seq to authenticated;
