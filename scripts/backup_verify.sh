#!/usr/bin/env bash
set -euo pipefail

echo "Running backup/restore verification drill..."

make backup >/dev/null
make restore >/dev/null

echo "Verification drill completed (OK)."
