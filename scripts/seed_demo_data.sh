#!/usr/bin/env bash
set -euo pipefail

primary_id="$(docker compose ps -q postgres-primary)"
if [[ -z "${primary_id}" ]]; then
  echo "Postgres primary is not running. Start it first:"
  echo "  make up"
  exit 1
fi

echo "Waiting for Postgres primary to accept connections..."
deadline="$((SECONDS + 60))"
while true; do
  if docker exec -i "${primary_id}" psql -U app -d appdb -At -c "select 1" >/dev/null 2>&1; then
    break
  fi
  if (( SECONDS >= deadline )); then
    echo "Postgres primary did not become ready within 60s."
    echo "Check logs:"
    echo "  make logs"
    exit 1
  fi
  sleep 2
done

echo "Seeding demo schema/data..."
docker exec -i "${primary_id}" psql -U app -d appdb -v ON_ERROR_STOP=1 <<'SQL'
create table if not exists users (
  id bigint generated always as identity primary key,
  username text not null unique,
  created_at timestamptz not null default now()
);

insert into users (username)
values ('alice'), ('bob'), ('carol'), ('dave')
on conflict (username) do nothing;
SQL

echo "Seed complete."
