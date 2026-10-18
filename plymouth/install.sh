#!/usr/bin/env bash
# Install the Lyric boot splash and rebuild the initramfs.
# usage: install.sh [WALLPAPER]   (default: the wallpaper awww is showing now)
# Undo:  sudo plymouth-set-default-theme bgrt && sudo limine-mkinitcpio
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
WALL=${1:-$(awww query | sed -n 's/.*image: //p' | head -1)}
[[ -f $WALL ]] || { echo "wallpaper not found: '$WALL'" >&2; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cp "$HERE"/lyric/lyric.{plymouth,script} "$TMP"/
"$HERE/gen.sh" "$WALL" "$TMP"

sudo install -Dm644 -t /usr/share/plymouth/themes/lyric "$TMP"/*
sudo plymouth-set-default-theme lyric
sudo limine-mkinitcpio
echo "Done. The new splash shows on next boot."
