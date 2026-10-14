-- Notre jeu d'amour — schéma Supabase avec sécurité RLS
-- 1) Exécuter ce SQL dans Supabase > SQL Editor.
-- 2) Créer votre utilisateur dans Authentication > Users (email + mot de passe).
-- 3) Copier son UUID et exécuter : insert into public.admin_users(user_id) values ('UUID_ICI');

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.game_events (
  id bigint generated always as identity primary key,
  event_type text not null check (event_type in ('visit','reaction','comment')),
  nickname text,
  reaction text,
  comment text,
  created_at timestamptz not null default now(),
  constraint nickname_length check (nickname is null or char_length(nickname) <= 40),
  constraint comment_length check (comment is null or char_length(comment) <= 500),
  constraint reaction_length check (reaction is null or char_length(reaction) <= 20)
);

alter table public.admin_users enable row level security;
alter table public.game_events enable row level security;

-- Les visiteurs peuvent envoyer uniquement les événements autorisés; aucune lecture publique.
drop policy if exists "Public can submit safe game events" on public.game_events;
create policy "Public can submit safe game events" on public.game_events
  for insert to anon, authenticated
  with check (
    event_type in ('visit','reaction','comment') and
    (nickname is null or char_length(nickname) <= 40) and
    (comment is null or char_length(comment) <= 500) and
    (reaction is null or char_length(reaction) <= 20) and
    (event_type <> 'visit' or (nickname is null and reaction is null and comment is null)) and
    (event_type <> 'reaction' or (reaction is not null and comment is null)) and
    (event_type <> 'comment' or (comment is not null and reaction is null))
  );

drop policy if exists "Admins can read admin list" on public.admin_users;
create policy "Admins can read admin list" on public.admin_users
  for select to authenticated using (user_id = auth.uid());
drop policy if exists "Admins can read events" on public.game_events;
create policy "Admins can read events" on public.game_events
  for select to authenticated using (
    exists (select 1 from public.admin_users a where a.user_id = auth.uid())
  );

grant insert on public.game_events to anon, authenticated;
grant select on public.game_events to authenticated;
grant select on public.admin_users to authenticated;
-- No grants for anonymous SELECT, UPDATE, or DELETE. Do not disable RLS.