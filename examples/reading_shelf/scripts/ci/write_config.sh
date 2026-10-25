#!/bin/sh
# Writes config/ci.json for --dart-define-from-file from environment variables
# (GitHub Environment variables in a delivery workflow).
set -eu
cd "$(dirname "$0")/../.."
for name in APP_ENV API_BASE_URL SUPABASE_URL SUPABASE_PUBLISHABLE_KEY; do
  eval "value=\${$name:-}"
  if [ -z "$value" ]; then
    echo "error: $name is empty. Set it as a GitHub Environment variable." >&2
    exit 1
  fi
done
python3 -c 'import json, os, sys
keys = ["APP_ENV", "API_BASE_URL", "SUPABASE_URL", "SUPABASE_PUBLISHABLE_KEY"]
json.dump({k: os.environ[k] for k in keys}, sys.stdout, indent=2)' > config/ci.json
echo "Wrote config/ci.json for APP_ENV=$APP_ENV"
