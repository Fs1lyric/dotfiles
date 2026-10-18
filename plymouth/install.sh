#!/usr/bin/env bash
# Install the Lyric boot splash and its clock hook, then rebuild the initramfs.
# usage: install.sh [WALLPAPER]   (default: the wallpaper awww is showing now)
# Undo:  sudo plymouth-set-default-theme bgrt && sudo limine-mkinitcpio
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
WALL=${1:-$(awww query | sed -n 's/.*image: //p' | head -1)}
[[ -f $WALL ]] || { echo "wallpaper not found: '$WALL'" >&2; exit 1; }
CONF=/etc/mkinitcpio.conf.d/zz-lyric.conf

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cp "$HERE"/lyric/lyric.{plymouth,script} "$TMP"/
"$HERE/gen.sh" "$WALL" "$TMP"

sudo rm -rf /usr/share/plymouth/themes/lyric
sudo install -Dm644 -t /usr/share/plymouth/themes/lyric "$TMP"/*
sudo install -Dm644 "$HERE/initcpio/install/lyric-clock" /etc/initcpio/install/lyric-clock
sudo install -Dm644 "$HERE/initcpio/hooks/lyric-clock" /etc/initcpio/hooks/lyric-clock
# The clock must start before `encrypt` blocks on the passphrase.
grep -q 'lyric-clock' "$CONF" || sudo sed -i 's/ encrypt / lyric-clock encrypt /' "$CONF"
grep -q 'lyric-clock encrypt' "$CONF" || { echo "could not add lyric-clock to HOOKS in $CONF" >&2; exit 1; }

sudo plymouth-set-default-theme lyric
sudo limine-mkinitcpio
echo "Done. The new splash shows on next boot."
