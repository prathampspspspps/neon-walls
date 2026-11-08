#!/usr/bin/env bash
# Publish: ./update.sh "message"   (never stages local deletions)
cd "$(dirname "$0")"
git add --ignore-removal . >/dev/null
./gen.sh
git add --ignore-removal . >/dev/null
git commit -m "${1:-update site}" || { echo "Nothing new to publish."; exit 0; }
git push && echo "Pushed. Site updates in ~1 minute."
