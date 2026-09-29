# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'


# Added by Antigravity CLI installer
export PATH="/home/lyric/.local/bin:$PATH"

. "$HOME/.local/share/../bin/env"
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$PATH:/opt/010editor" #ADDED BY 010 EDITOR
[[ -r ~/.bashrc.secrets ]] && source ~/.bashrc.secrets  # untracked: API keys, tokens

# >>> Codex installer >>>
export PATH="/home/lyric/.local/bin:$PATH"
# <<< Codex installer <<<

# Always run Claude Code inside ~/claude (trusted folder, so no safety prompt)
claude() {
  # Clawd-orange (#D47656) "CLAUDE CODE" banner, then launch as usual
  printf '\e[1;38;2;212;118;86m%s\e[0m\n' "$(cat <<'BANNER'
 ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗   ██████╗ ██████╗ ██████╗ ███████╗
██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝  ██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║     ██║     ███████║██║   ██║██║  ██║█████╗    ██║     ██║   ██║██║  ██║█████╗
██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝    ██║     ██║   ██║██║  ██║██╔══╝
╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗  ╚██████╗╚██████╔╝██████╔╝███████╗
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝   ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
BANNER
)"
  case "$PWD/" in
    "$HOME/claude/"*) command claude "$@" ;;
    *) (cd "$HOME/claude" && command claude "$@") ;;
  esac
}

# Spinning 3D fetch with the Arch logo, runs until a key is pressed
alias fetch='fetch -l arch --infinite'
