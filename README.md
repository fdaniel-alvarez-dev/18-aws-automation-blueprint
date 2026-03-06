# 18-aws-reliability-migrations-backup

A production-minded database reliability toolkit: HA lab, backup/PITR drills, and zero/low-downtime migration playbooks.

Focus: backup


## Why this repo exists
This is a portfolio-grade, runnable toolkit that demonstrates how I approach database reliability work:
safe changes, predictable operations, and recovery you can actually trust.

## The top pains this repo addresses
1) Backups you can actually restore—verified restore drills that prove outcomes, not just artifacts.
2) Safe schema evolution—repeatable migration playbook (nullable add, batched backfill, concurrent index, verification).
3) Predictable operations—replication checks that fail loudly, clear runbooks, and guarded production tests.

## Quick demo (local)
Prereqs: Docker + Docker Compose.

```bash
make demo
```

What you get:
- a Postgres primary + replica setup
- PgBouncer for connection pooling
- scripts to verify replication, run verified backup/restore drills, and execute a safe migration playbook

## Design decisions (high level)
- Prefer drills and runbooks over “tribal knowledge”.
- Keep the lab small but realistic (replication + pooling + backup).
- Make failure modes explicit and testable.

## What I would do next in production
- Add PITR with WAL archiving + periodic restore tests.
- Add SLOs (p95 query latency, replication lag) and alert thresholds.
- Add automated migration checks (preflight, locks, backout plan).

## Tests (two modes)
This repository supports exactly two test modes via `TEST_MODE`:

- `demo`: fast, offline checks against fixtures only (no Docker calls).
- `production`: real integration checks against Dockerized Postgres when properly configured.

Demo:
```bash
TEST_MODE=demo python3 tests/run_tests.py
```

Production (guarded):
```bash
TEST_MODE=production PRODUCTION_TESTS_CONFIRM=1 python3 tests/run_tests.py
```

## Sponsorship and authorship
Sponsored by:
CloudForgeLabs  
https://cloudforgelabs.ainextstudios.com/  
support@ainextstudios.com

Built by:
Freddy D. Alvarez  
https://www.linkedin.com/in/freddy-daniel-alvarez/

For job opportunities, contact:
it.freddy.alvarez@gmail.com

## License
Personal/non-commercial use is free. Commercial use requires permission (paid license).
See `LICENSE` and `COMMERCIAL_LICENSE.md` for details. For commercial licensing, contact: `it.freddy.alvarez@gmail.com`.
Note: this is a non-commercial license and is not OSI-approved; GitHub may not classify it as a standard open-source license.
