#!/usr/bin/env bash
# Bake the Lyric splash graphics into OUT_DIR.
# usage: gen.sh WALLPAPER OUT_DIR
set -euo pipefail

WALL=$1
OUT=$2

# Sized for 1920x1080; the script scales the background to any screen.
SW=1920 SH=1080
FONT_LIGHT=$(fc-match -f '%{file}' 'Roboto Mono:light')
FONT=$(fc-match -f '%{file}' 'Roboto Mono')

# hyprlock-colors.conf: outline c2c6d6aa, time e4e2e3, date e4e2e3cc
OUTLINE='#c2c6d6aa'
TEXT='#e4e2e3'
DIM='#e4e2e3cc'

# Must match the charsets in lyric.script.
BIG_CHARS='0123456789:'
SMALL_CHARS='0123456789:, ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

mkdir -p "$OUT"

# Blurred, slightly darkened wallpaper (hyprlock: blur_passes 3, size 5).
magick "$WALL" -resize "${SW}x${SH}^" -gravity center -extent "${SW}x${SH}" \
  -blur 0x14 -fill black -colorize 18% "$OUT/bg.png"

# One fixed-cell image per character (Roboto Mono is monospaced), so the
# script can spell out any time or date without fonts in the initramfs.
glyphs() { # prefix font size colour chars
  local adv h i c
  adv=$(magick -background none -font "$2" -pointsize "$3" label:0000000000 -format '%[fx:round(w/10)]' info:)
  h=$(magick -background none -font "$2" -pointsize "$3" label:0 -format '%h' info:)
  for ((i = 0; i < ${#5}; i++)); do
    c=${5:i:1}
    if [[ $c == ' ' ]]; then
      magick -size "${adv}x${h}" xc:none "$OUT/$1-$i.png"
    else
      magick -background none -font "$2" -pointsize "$3" -fill "$4" label:"$c" \
        -gravity center -extent "${adv}x${h}" "$OUT/$1-$i.png"
    fi
  done
}
glyphs big   "$FONT_LIGHT" 120 "$TEXT" "$BIG_CHARS"
glyphs small "$FONT"       26  "$DIM"  "$SMALL_CHARS"

magick -background none -font "$FONT" -pointsize 20 -fill "$DIM" label:en "$OUT/layout.png"

# Input field: 20% x 5% of the screen, 3px outline, rounding 25, no fill.
FW=$((SW / 5)) FH=$((SH / 20))
magick -size "${FW}x${FH}" xc:none -fill none -stroke "$OUTLINE" -strokewidth 3 \
  -draw "roundrectangle 2,2 $((FW - 3)),$((FH - 3)) 25,25" "$OUT/field.png"

# Password dot: 20% of the field height.
D=$((FH / 5))
magick -size "$((D * 4))x$((D * 4))" xc:none -fill "$TEXT" \
  -draw "circle $((D * 2)),$((D * 2)) $((D * 2)),2" -resize "${D}x${D}" "$OUT/dot.png"
