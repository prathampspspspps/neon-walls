#!/usr/bin/env bash
# Creates category folders (if missing) and builds wallpapers.js
# Layout: wallpapers/<category>/<dark|light>/<image>
cd "$(dirname "$0")"

CATEGORIES=(anime brands game minimalistic mix painting photography cyberpunk space nature abstract cars movies tech)
for c in "${CATEGORIES[@]}"; do mkdir -p "wallpapers/$c/dark" "wallpapers/$c/light"; done

{
  echo "const WALLS = {"
  for cat in wallpapers/*/; do
    name=$(basename "$cat")
    echo "  \"$name\": {"
    for v in dark light; do
      echo "    \"$v\": ["
      find "$cat$v" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null \
        | sort | sed 's/.*/      "&",/'
      echo "    ],"
    done
    echo "  },"
  done
  echo "};"
} > wallpapers.js
echo "wallpapers.js updated"
