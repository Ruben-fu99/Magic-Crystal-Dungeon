-- 魔晶地牢：帳號、雲端存檔、排行榜、世界王、PvP（在 Supabase 的 SQL Editor 執行一次）
-- 即時聊天、好友在線、合作模式、PvP 對戰使用 Supabase Realtime Broadcast，不需要建表。

create table if not exists public.docs (
  coll text not null,
  doc_id text not null,
  uid uuid not null references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  score numeric generated always as (case when jsonb_typeof(data->'score') = 'number' then (data->>'score')::numeric end) stored,
  dmg   numeric generated always as (case when jsonb_typeof(data->'dmg')   = 'number' then (data->>'dmg')::numeric   end) stored,
  ts    numeric generated always as (case when jsonb_typeof(data->'ts')    = 'number' then (data->>'ts')::numeric    end) stored,
  primary key (coll, doc_id)
);
create index if not exists docs_coll_score on public.docs (coll, score desc);
create index if not exists docs_coll_dmg   on public.docs (coll, dmg desc);
create index if not exists docs_coll_ts    on public.docs (coll, ts desc);

alter table public.docs enable row level security;
drop policy if exists docs_select on public.docs;
drop policy if exists docs_insert on public.docs;
drop policy if exists docs_update on public.docs;

-- 所有人可讀排行榜類資料；存檔（coll = data）只有本人能讀
create policy docs_select on public.docs for select
  using (coll <> 'data' or uid = auth.uid());

-- 只能寫自己的文件：排行榜類文件 id = 自己的使用者 id；存檔 id = users/<自己的 id>/save
create policy docs_insert on public.docs for insert
  with check (
    uid = auth.uid()
    and coll in ('leaderboard','lb_tower','lb_daily','lb_week','lb_pvp','wb_dmg','data')
    and (doc_id = auth.uid()::text or doc_id = 'users/' || auth.uid()::text || '/save')
    and octet_length(data::text) < 600000
  );
create policy docs_update on public.docs for update
  using (uid = auth.uid())
  with check (
    uid = auth.uid()
    and coll in ('leaderboard','lb_tower','lb_daily','lb_week','lb_pvp','wb_dmg','data')
    and (doc_id = auth.uid()::text or doc_id = 'users/' || auth.uid()::text || '/save')
    and octet_length(data::text) < 600000
  );

-- 讓排行榜即時更新（已加入過會略過）
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when others then null; end $$;
