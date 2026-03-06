.PHONY: demo up down logs seed migrate backup restore verify check test clean

demo: up seed check migrate backup restore verify
	@echo "Demo complete. Try: make logs"

up:
	docker compose up -d --build

down:
	docker compose down -v

logs:
	docker compose logs -f --tail=200

check:
	bash scripts/check_replication.sh

seed:
	bash scripts/seed_demo_data.sh

migrate:
	bash scripts/migrate_safe_add_column.sh

backup:
	bash scripts/backup.sh

restore:
	bash scripts/restore.sh

verify:
	bash scripts/backup_verify.sh

test:
	TEST_MODE=demo python3 tests/run_tests.py

clean:
	rm -rf artifacts
