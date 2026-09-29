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

# Firefox/Zen custom CSS + user.js go into each browser's default profile
# (open the browser once first on a fresh machine so the profile exists).
source "$REPO/browser-profile.sh"
for browser in firefox zen; do
  [[ -d $REPO/$browser ]] || continue
  if profile="$(browser_default_profile "$browser")"; then
    cd "$REPO/$browser"
    find . -type f -print0 | while IFS= read -r -d '' f; do
      rel="${f#./}"
      target="$profile/$rel"
      if [[ -e $target ]] && ! cmp -s "$f" "$target"; then
        mkdir -p "$BACKUP/$browser/$(dirname "$rel")"
        cp -a "$target" "$BACKUP/$browser/$rel"
      fi
      mkdir -p "$(dirname "$target")"
      cp -a "$f" "$target"
    done
    echo "$browser CSS installed into $profile (restart $browser)"
  else
    echo "No $browser profile yet: open $browser once, then re-run install.sh"
  fi
done

[[ -f ~/.bashrc.secrets ]] || { touch ~/.bashrc.secrets; chmod 600 ~/.bashrc.secrets; }

echo "Installed. Backups (if any): $BACKUP"
echo "Next: put API keys in ~/.bashrc.secrets, run 'gh auth setup-git', then 'mise install'."
