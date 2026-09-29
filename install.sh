#!/usr/bin/env bash
# Copy the configs in home/ onto this machine. Any file that would be
# overwritten is backed up first to ~/.dotfiles-backup/<timestamp>/.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
SRC="$REPO/home"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

cd "$SRC"
find . -type f -print0 | while IFS= read -r -d '' f; do
  rel="${f#./}"
  target="$HOME/$rel"
  if [[ -e $target ]] && ! cmp -s "$f" "$target"; then
    mkdir -p "$BACKUP/$(dirname "$rel")"
    cp -a "$target" "$BACKUP/$rel"
  fi
  mkdir -p "$(dirname "$target")"
  cp -a "$f" "$target"
done

# Firefox custom CSS + user.js go into the default profile (open Firefox once
# first on a fresh machine so the profile exists).
source "$REPO/firefox-profile.sh"
if FF_PROFILE="$(firefox_default_profile)"; then
  cd "$REPO/firefox"
  find . -type f -print0 | while IFS= read -r -d '' f; do
    rel="${f#./}"
    target="$FF_PROFILE/$rel"
    if [[ -e $target ]] && ! cmp -s "$f" "$target"; then
      mkdir -p "$BACKUP/firefox/$(dirname "$rel")"
      cp -a "$target" "$BACKUP/firefox/$rel"
    fi
    mkdir -p "$(dirname "$target")"
    cp -a "$f" "$target"
  done
  echo "Firefox CSS installed into $FF_PROFILE (restart Firefox)"
else
  echo "No Firefox profile yet: open Firefox once, then re-run install.sh"
fi

[[ -f ~/.bashrc.secrets ]] || { touch ~/.bashrc.secrets; chmod 600 ~/.bashrc.secrets; }

echo "Installed. Backups (if any): $BACKUP"
echo "Next: put API keys in ~/.bashrc.secrets, run 'gh auth setup-git', then 'mise install'."
