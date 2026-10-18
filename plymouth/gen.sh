#!/usr/bin/env bash
# Bake the Lyric splash graphics into OUT_DIR.
# usage: gen.sh WALLPAPER OUT_DIR [TITLE]
set -euo pipefail

WALL=$1
OUT=$2
TITLE=${3:-$(cat /etc/hostname 2>/dev/null || echo archy)}

# Sized for 1920x1080; the script scales the background to any screen.
SW=1920 SH=1080
FONT_LIGHT=$(fc-match -f '%{file}' 'Roboto Mono:light')
FONT=$(fc-match -f '%{file}' 'Roboto Mono')

# hyprlock-colors.conf: outline c2c6d6aa, time e4e2e3, date e4e2e3cc
OUTLINE='#c2c6d6aa'
TEXT='#e4e2e3'
DIM='#e4e2e3cc'

mkdir -p "$OUT"

# Blurred, slightly darkened wallpaper (hyprlock: blur_passes 3, size 5).
magick "$WALL" -resize "${SW}x${SH}^" -gravity center -extent "${SW}x${SH}" \
  -blur 0x14 -fill black -colorize 18% "$OUT/bg.png"

text() { # file font size colour string
  magick -background none -font "$2" -pointsize "$3" -fill "$4" label:"$5" "$OUT/$1"
}
text title.png    "$FONT_LIGHT" 96 "$TEXT" "$TITLE"
text subtitle.png "$FONT"       24 "$DIM"  "enter passphrase to unlock"
text layout.png   "$FONT"       20 "$DIM"  "en"

# Input field: 20% x 5% of the screen, 3px outline, rounding 25, no fill.
FW=$((SW / 5)) FH=$((SH / 20))
magick -size "${FW}x${FH}" xc:none -fill none -stroke "$OUTLINE" -strokewidth 3 \
  -draw "roundrectangle 2,2 $((FW - 3)),$((FH - 3)) 25,25" "$OUT/field.png"

# Password dot: 20% of the field height.
D=$((FH / 5))
magick -size "$((D * 4))x$((D * 4))" xc:none -fill "$TEXT" \
  -draw "circle $((D * 2)),$((D * 2)) $((D * 2)),2" -resize "${D}x${D}" "$OUT/dot.png"
