# Sourced by sync.sh and install.sh.
# Browsers whose custom CSS + user.js are kept in this repo: repo dir -> profile roots.
declare -A BROWSER_ROOTS=(
  [firefox]="$HOME/.config/mozilla/firefox:$HOME/.mozilla/firefox"
  [zen]="$HOME/.config/zen:$HOME/.zen"
)

# Prints the path of a browser's default profile, or returns 1 if there is none.
browser_default_profile() {
  local root ini path roots
  IFS=: read -ra roots <<<"${BROWSER_ROOTS[$1]}"
  for root in "${roots[@]}"; do
    # installs.ini names the profile the installed browser actually opens
    for ini in "$root/installs.ini" "$root/profiles.ini"; do
      [[ -f $ini ]] || continue
      path="$(grep -m1 '^Default=' "$ini" | cut -d= -f2-)"
      if [[ -n $path && -d $root/$path ]]; then
        echo "$root/$path"
        return 0
      fi
    done
  done
  return 1
}
