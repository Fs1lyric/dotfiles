# dotfiles

My [Omarchy](https://omarchy.org) (Arch + Hyprland) setup. **[See it here →](https://fs1lyric.github.io/dotfiles/)**

## What's here

`home/` mirrors `$HOME`:

| Area | Files |
| --- | --- |
| Shell | `.bashrc`, `.bash_profile`, `.profile`, `starship.toml`, `fish/` |
| Desktop | `hypr/` (Hyprland, Lua config), `omarchy/` (bar layout, hooks, menu, backgrounds, `lyric.launchers` bar plugin) |
| Terminals | `alacritty/`, `ghostty/`, `kitty/`, `foot/`, `tmux/` |
| Editors | `nvim/` (LazyVim), `doom/`, `.doom.d/` |
| Firefox | `firefox/chrome/userChrome.css`, `userContent.css`, `user.js` (vertical tabs, compact, Zen-style) |
| Zen | `zen/chrome/userChrome.css`, `userContent.css`, `user.js` (Zen Mods themselves are managed in Zen's settings) |
| Tools | `git/`, `mise/` (claude, codex, gh, node, python…), `btop/`, `fastfetch/`, `cava/` |

## Install on a new machine

```sh
git clone https://github.com/Fs1lyric/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Open Firefox and Zen once before running it, so a profile exists for the CSS to go into.

`install.sh` copies everything in `home/` into `$HOME`, and `firefox/` and `zen/` into each browser's default profile. Any file it would overwrite is backed up to `~/.dotfiles-backup/<timestamp>/` first.

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


# Screenshot of Rice


![Uploading image.png…]()


## Secrets

Secrets never go in this repo. `.bashrc` sources `~/.bashrc.secrets`, which is git-ignored and `chmod 600`.
