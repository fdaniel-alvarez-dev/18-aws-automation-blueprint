#!/usr/bin/env bash
set -euo pipefail

primary_id="$(docker compose ps -q postgres-primary)"
if [[ -z "${primary_id}" ]]; then
  echo "Postgres primary is not running. Start it first:"
  echo "  make up"
  exit 1
fi

echo "Running safe migration playbook: add users.email with backfill + index..."

docker exec -i "${primary_id}" psql -U app -d appdb -v ON_ERROR_STOP=1 -c "alter table users add column if not exists email text;"

echo "Backfilling users.email in small batches..."
while true; do
  updated="$(
    docker exec -i "${primary_id}" psql -U app -d appdb -v ON_ERROR_STOP=1 -At <<'SQL' | wc -l | tr -d '[:space:]'
with batch as (
  select ctid, id
  from users
  where email is null
  limit 100
)
update users u
set email = 'user' || u.id::text || '@example.com'
from batch
where u.ctid = batch.ctid
returning 1;
SQL
  )"

  if [[ "${updated}" == "0" ]]; then
    break
  fi
  sleep 0.1
done

echo "Creating index concurrently (if not exists)..."
docker exec -i "${primary_id}" psql -U app -d appdb -v ON_ERROR_STOP=1 -c "create index concurrently if not exists idx_users_email on users (email);"

echo "Migration verification..."
docker exec -i "${primary_id}" psql -U app -d appdb -v ON_ERROR_STOP=1 -c "select count(*) as null_emails from users where email is null;" | grep -q "0"

echo "Migration complete (OK)."
