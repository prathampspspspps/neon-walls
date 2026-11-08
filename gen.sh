#!/usr/bin/env bash
# Builds wallpapers.js from everything git knows about, so it still works
# after you delete the local image copies.
cd "$(dirname "$0")"
DEFAULTS=(anime brands game minimalistic mix painting photography cyberpunk space nature abstract cars movies tech)
LS() { git -c core.quotepath=false ls-files -co --exclude-standard "$@"; }

mapfile -t CATS < <( (printf '%s\n' "${DEFAULTS[@]}"; LS wallpapers | cut -d/ -f2) | awk 'NF && !seen[$0]++')
{
  echo "const WALLS = {"
  for c in "${CATS[@]}"; do
    echo "  \"$c\": {"
    for v in dark light; do
      echo "    \"$v\": ["
      LS "wallpapers/$c/$v" | grep -iE '\.(jpe?g|png|webp)$' | sort | sed 's/.*/      "&",/'
      echo "    ],"
    done
    echo "  },"
  done
  echo "};"
} > wallpapers.js
echo "wallpapers.js updated"
