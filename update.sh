#!/usr/bin/env bash
# One command to publish changes:  ./update.sh "message"
cd "$(dirname "$0")"
./gen.sh                      # refresh wallpapers.js from your folders
git add -A
git commit -m "${1:-update site}" || { echo "Nothing new to publish."; exit 0; }
git push && echo "Pushed. Site updates in ~1 minute."
