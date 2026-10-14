#!/usr/bin/env python3
"""Default apps for omenu's Defaults section.

Usage: defaults.py list <kind>             rows of `name	desktop-id	current` for omenu
       defaults.py set <kind> <desktop-id>
"""
import os
import subprocess
import sys

HOME = os.path.expanduser("~")
TERMINALS = os.path.join(HOME, ".config/xdg-terminals.list")

# kind: mime types it owns. The first one decides which apps qualify and which is current.
KINDS = {
    "browser": ["x-scheme-handler/https", "x-scheme-handler/http", "text/html"],
    "terminal": [],
    "files": ["inode/directory"],
    "editor": ["text/plain", "text/markdown", "application/x-shellscript"],
    "images": ["image/png", "image/jpeg", "image/webp", "image/gif", "image/svg+xml"],
    "pdf": ["application/pdf"],
    "video": ["video/mp4", "video/x-matroska", "video/webm", "video/quicktime"],
    "music": ["audio/mpeg", "audio/flac", "audio/ogg", "audio/x-wav"],
    "email": ["x-scheme-handler/mailto"],
}


def application_dirs():
    data_home = os.environ.get("XDG_DATA_HOME", os.path.join(HOME, ".local/share"))
    data_dirs = os.environ.get("XDG_DATA_DIRS", "/usr/local/share:/usr/share").split(":")
    return [os.path.join(d, "applications") for d in [data_home, *data_dirs] if d]


def read_entry(path):
    """Keys of a .desktop file's [Desktop Entry] group."""
    entry, inside = {}, False
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            for line in f:
                line = line.strip()
                if line.startswith("["):
                    inside = line == "[Desktop Entry]"
                elif inside and "=" in line:
                    key, value = line.split("=", 1)
                    entry.setdefault(key.strip(), value.strip())
    except OSError:
        pass
    return entry


def _qualifies(kind, entry):
    if entry.get("NoDisplay") == "true" or entry.get("Hidden") == "true":
        return False
    if kind == "terminal":
        return "TerminalEmulator" in entry.get("Categories", "").split(";")
    return KINDS[kind][0] in entry.get("MimeType", "").split(";")


def candidates(kind, dirs=None):
    """(name, desktop id) for apps that can be the default for kind, sorted by name."""
    seen, found = set(), []
    for directory in dirs if dirs is not None else application_dirs():
        try:
            names = sorted(os.listdir(directory))
        except OSError:
            continue
        for name in names:
            if not name.endswith(".desktop") or name in seen:
                continue
            seen.add(name)
            entry = read_entry(os.path.join(directory, name))
            if _qualifies(kind, entry):
                found.append((entry.get("Name", name), name))
    return sorted(found, key=lambda app: app[0].lower())


def first_terminal(text):
    for line in text.splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            return line
    return ""


def terminal_list(text, desktop_id):
    """xdg-terminals.list text with desktop_id moved to the top, comments kept."""
    lines = text.splitlines()
    comments = [line for line in lines if line.strip().startswith("#")]
    entries = [line.strip() for line in lines if line.strip() and not line.strip().startswith("#")]
    return "\n".join([*comments, desktop_id, *(e for e in entries if e != desktop_id)]) + "\n"


def _read(path):
    try:
        with open(path) as f:
            return f.read()
    except OSError:
        return ""


def current(kind):
    if kind == "terminal":
        return first_terminal(_read(TERMINALS))
    result = subprocess.run(["xdg-mime", "query", "default", KINDS[kind][0]], capture_output=True, text=True)
    return result.stdout.strip()


def set_default(kind, desktop_id):
    if kind == "terminal":
        with open(TERMINALS, "w") as f:
            f.write(terminal_list(_read(TERMINALS), desktop_id))
    else:
        # Browser too: xdg-settings refuses while $BROWSER is set (bash/envs sets it).
        subprocess.run(["xdg-mime", "default", desktop_id, *KINDS[kind]], check=True)
    subprocess.run(["notify-send", "-a", "Defaults", f"Default {kind}", desktop_id.removesuffix(".desktop")])


def main(argv):
    if len(argv) >= 2 and argv[0] == "list" and argv[1] in KINDS:
        now = current(argv[1])
        for name, desktop_id in candidates(argv[1]):
            print(f"{name}\t{desktop_id}\t{now}")
    elif len(argv) == 3 and argv[0] == "set" and argv[1] in KINDS:
        set_default(argv[1], argv[2])
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main(sys.argv[1:])
