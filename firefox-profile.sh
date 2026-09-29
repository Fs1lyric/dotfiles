# Sourced by sync.sh and install.sh.
# Prints the path of Firefox's default profile, or returns 1 if there is none.
firefox_default_profile() {
  local root ini path
  for root in "$HOME/.config/mozilla/firefox" "$HOME/.mozilla/firefox"; do
    # installs.ini names the profile the installed Firefox actually opens
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
