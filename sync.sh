#!/usr/bin/env bash
# Copy the live configs from $HOME into this repo (home/ mirrors $HOME).
# Run this after changing a config, then commit.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
DEST="$REPO/home"

# Paths relative to $HOME
PATHS=(
  .bashrc
  .bash_profile
  .profile
  .config/hypr
  .config/bash
  .config/uwsm
  .config/lyric-theme
  .config/omenu
  .config/noctalia
  .local/state/noctalia/settings.toml
  .local/state/noctalia/community-palettes
  .local/share/omenu
  .local/share/lyric
  .local/bin/lyric-crash-watch
  .local/bin/lyric-launch
  .local/bin/lyric-pkg
  .local/bin/lyric-record
  .local/bin/lyric-sleep-lock
  .local/bin/lyric-util
  .local/bin/lyric-window
  .local/bin/omenu
  .config/systemd/user/lyric-crash-watch.service
  .config/systemd/user/lyric-sleep-lock.service
  .config/systemd/user/fcitx5.service
  .config/systemd/user/update-cli-tools.service
  .config/systemd/user/update-cli-tools.timer
  .cache/nwg-dock-pinned
  .config/nwg-dock-hyprland
  .local/share/applications/trash.desktop
  .local/share/applications/chrome-web.whatsapp.com__-Default.desktop
  .config/alacritty
  .config/ghostty
  .config/kitty
  .config/foot
  .config/nvim
  .config/tmux
  .config/starship.toml
  .config/git
  .config/fish
  .config/btop
  .config/fastfetch
  .config/cava
  .config/doom
  .config/mise
  .config/environment.d
  .config/xdg-terminals.list
  .config/mimeapps.list
  .doom.d
)

# Never copy these
EXCLUDES=(--exclude='*.bak' --exclude='*.bak.*' --exclude='*.old' --exclude='.git' --exclude='__pycache__')

for p in "${PATHS[@]}"; do
  src="$HOME/$p"
  [[ -e $src ]] || { echo "skip (missing): $p"; continue; }
  mkdir -p "$DEST/$(dirname "$p")"
  if [[ -d $src ]]; then
    rsync -a --delete "${EXCLUDES[@]}" "$src/" "$DEST/$p/"
  else
    rsync -a "$src" "$DEST/$p"
  fi
done

# The gh credential helper lines point at a version-specific mise path; drop them.
# Run `gh auth setup-git` on a new machine instead.
for section in 'credential.https://github.com' 'credential.https://gist.github.com'; do
  git config --file "$DEST/.config/git/config" --remove-section "$section" 2>/dev/null || true
done

# Firefox and Zen: profile folder names are random per machine, so the custom
# CSS and user.js live in firefox/ and zen/ and are copied from whichever
# profile is the default. zen-themes.css is left out: Zen regenerates it from Mods.
source "$REPO/browser-profile.sh"
for browser in firefox zen; do
  if profile="$(browser_default_profile "$browser")"; then
    mkdir -p "$REPO/$browser/chrome"
    rsync -a --delete "${EXCLUDES[@]}" --exclude='*.bak-*' --exclude='zen-themes.css' \
      "$profile/chrome/" "$REPO/$browser/chrome/"
    cp -a "$profile/user.js" "$REPO/$browser/user.js"
    chmod 644 "$REPO/$browser/chrome/"*.css
  else
    echo "skip (missing): $browser default profile"
  fi
done

# Refuse to continue if anything secret-looking slipped in
if grep -rInE '(API_KEY|TOKEN|SECRET|PASSWORD)=["'\'']?[A-Za-z0-9_-]{16,}|gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9_-]{20,}' "$DEST" "$REPO/firefox" "$REPO/zen"; then
  echo "!! Possible secret found above. Move it to ~/.bashrc.secrets before committing." >&2
  exit 1
fi

echo "Synced into $DEST"
