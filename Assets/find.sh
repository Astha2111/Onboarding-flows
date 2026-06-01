#!/bin/bash
# Find image paths by game name (fuzzy substring match on slug or name).
# Usage: ./find.sh "tomb raider"
#        ./find.sh "tomb raider" --json
if [ -z "$1" ]; then
  echo "Usage: $0 <search-term> [--json]"
  exit 1
fi

QUERY="$1"
FORMAT="${2:-text}"
INDEX="$(dirname "$0")/index.json"

python3 - "$QUERY" "$FORMAT" "$INDEX" <<'PY'
import json, sys
query, fmt, index_path = sys.argv[1].lower(), sys.argv[2], sys.argv[3]
data = json.load(open(index_path))
matches = [i for i in data["items"] if query in i["slug"].lower() or query in i["name"].lower()]
if fmt == "--json":
    print(json.dumps(matches, indent=2))
else:
    if not matches:
        print(f"No matches for '{query}'")
        sys.exit(1)
    for m in matches:
        print(f"\n{m['name']}  ({m['slug']})")
        if "horizontal" in m: print(f"  H 1920x1080: {m['horizontal']}")
        if "vertical"   in m: print(f"  V  720x1080: {m['vertical']}")
        if "hero"       in m: print(f"  Hero 1920x1080: {m['hero']}")
PY
