#!/usr/bin/env bash
# Usage: ./add.sh <folder-with-images> <category> [dark|light]
# Shrinks images, makes thumbnails, pushes to GitHub, then removes the local copies.
set -e
src="$1"; cat="$2"; var="${3:-dark}"
[ -d "$src" ] && [ -n "$cat" ] || { echo "Usage: ./add.sh <folder> <category> [dark|light]"; exit 1; }
src=$(realpath "$src"); cd "$(dirname "$0")"
command -v magick >/dev/null || { echo "Install ImageMagick: sudo pacman -S imagemagick"; exit 1; }
dest="wallpapers/$cat/$var"; th="thumbs/$cat/$var"; mkdir -p "$dest" "$th"
shopt -s nullglob nocaseglob; n=0
for f in "$src"/*.{jpg,jpeg,png,webp}; do
  b=$(basename "$f"); name=$(echo "${b%.*}" | tr ' ' '-' | tr -cd 'A-Za-z0-9._-')
  magick "$f" -auto-orient -resize '2560x1440>' -quality 82 "$dest/$name.jpg"
  magick "$f" -auto-orient -resize '420x236^' -gravity center -extent 420x236 -quality 70 "$th/$name.webp"
  n=$((n+1)); printf '\r%s done' "$n"
done
echo; [ "$n" -gt 0 ] || { echo "No images found in $src"; exit 1; }
./update.sh "add $n to $cat/$var"
# only reached if the push succeeded: free the laptop space
rm -rf "$dest" "$th"
echo "Local copies removed. Your originals in $src are untouched, delete them when you like."
