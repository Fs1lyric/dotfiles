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
  .config/omarchy/shell.json
  .config/omarchy/keystroke.json
  .config/omarchy/defaults
  .config/omarchy/branding
  .config/omarchy/extensions
  .config/omarchy/hooks
  .config/omarchy/themed
  .config/omarchy/backgrounds
  .config/omarchy/plugins/lyric.launchers
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
EXCLUDES=(--exclude='*.bak' --exclude='*.bak.*' --exclude='*.old' --exclude='.git')

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

# Refuse to continue if anything secret-looking slipped in
if grep -rInE '(API_KEY|TOKEN|SECRET|PASSWORD)=["'\'']?[A-Za-z0-9_-]{16,}|gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9_-]{20,}' "$DEST"; then
  echo "!! Possible secret found above. Move it to ~/.bashrc.secrets before committing." >&2
  exit 1
fi

echo "Synced into $DEST"
