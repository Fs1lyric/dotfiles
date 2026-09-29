# dotfiles

My [Omarchy](https://omarchy.org) (Arch + Hyprland) setup.

## What's here

`home/` mirrors `$HOME`:

| Area | Files |
| --- | --- |
| Shell | `.bashrc`, `.bash_profile`, `.profile`, `starship.toml`, `fish/` |
| Desktop | `hypr/` (Hyprland, Lua config), `omarchy/` (bar layout, hooks, menu, backgrounds, `lyric.launchers` bar plugin) |
| Terminals | `alacritty/`, `ghostty/`, `kitty/`, `foot/`, `tmux/` |
| Editors | `nvim/` (LazyVim), `doom/`, `.doom.d/` |
| Tools | `git/`, `mise/` (claude, codex, gh, node, python…), `btop/`, `fastfetch/`, `cava/` |

## Install on a new machine

```sh
git clone https://github.com/Fs1lyric/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` copies everything in `home/` into `$HOME`. Any file it would overwrite is backed up to `~/.dotfiles-backup/<timestamp>/` first.

Then:

```sh
$EDITOR ~/.bashrc.secrets   # API keys, e.g. export OBSIDIAN_API_KEY=...
gh auth login && gh auth setup-git
mise install
```

## Updating

Edit configs in place as usual, then:

```sh
cd ~/dotfiles && ./sync.sh && git add -A && git commit -m "update" && git push
```

`sync.sh` copies the live configs into `home/`, strips machine-specific git credential helpers, and refuses to finish if it spots anything that looks like a secret.

## Secrets

Secrets never go in this repo. `.bashrc` sources `~/.bashrc.secrets`, which is git-ignored and `chmod 600`.
