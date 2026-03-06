# Backup & restore drill

Goal: make recovery predictable by practicing it.

## Drill steps
```bash
make up
make seed
make backup
make restore
make verify
```

## What “good” looks like
- You can restore without guessing commands.
- The backup artifact is versioned *out of band* (`artifacts/` is ignored).
- The restore is verified (a known query succeeds).
- The drill is safe: restore runs into an isolated verification database (`appdb_verify`) by default.
