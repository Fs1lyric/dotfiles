#!/usr/bin/env python3
"""omenu: a menu tree from ~/.config/omenu/menu.jsonc, drawn with fuzzel.

Usage: omenu [toggle|summon|close] [route]   or   omenu <route>
A route is a menu id ("system", "capture") or one of its aliases ("power-menu").
"""
import glob
import json
import os
import shlex
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass

HOME = os.path.expanduser("~")
MENU = os.path.join(HOME, ".config/omenu/menu.jsonc")
VERBS = ("toggle", "summon", "close")
BACK = "  Back"
SCHEME = os.path.join(HOME, ".local/state/caelestia/scheme.json")
CONFIG = os.path.join(HOME, ".cache/omenu/fuzzel.ini")
APPS = "noctalia msg panel-toggle launcher"

FALLBACK_COLOURS = {"surface": "131317", "surfaceContainerHigh": "2a292e", "onSurface": "e5e1e7",
                    "onSurfaceVariant": "c8c5d1", "primary": "c2c1ff", "outline": "918f9a"}

STYLE = """[main]
font=Adwaita Sans:size=13,JetBrainsMono Nerd Font:size=13
icon-theme={icon_theme}
prompt="  "
layer=overlay
anchor=center
width=32
lines=11
line-height=34
horizontal-pad=20
vertical-pad=18
inner-pad=12
match-counter=no

[colors]
background={surface}f2
text={onSurfaceVariant}ff
prompt={primary}ff
placeholder={outline}ff
input={onSurface}ff
match={primary}ff
selection={surfaceContainerHigh}ff
selection-text={onSurface}ff
selection-match={primary}ff
border={outline}33

[border]
radius=20
width=1
"""

# Dynamic submenus: a bash script printing `label	value	current` rows, and the
# command a picked value is passed to.
PROVIDERS = {
    "power-profiles": ("current=$(powerprofilesctl get 2>/dev/null); powerprofilesctl list 2>/dev/null"
                       " | sed -n 's/^[* ] *\\([a-z-]*\\):$/\\1/p'"
                       " | while read -r p; do printf '%s\\t%s\\t%s\\n' \"$p\" \"$p\" \"$current\"; done",
                       "powerprofilesctl set"),
}


@dataclass
class Row:
    id: str
    text: str
    checked: bool = False


def parse_jsonc(text):
    """JSON with // and /* */ comments and trailing commas."""
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if c == '"':
            j = i + 1
            while j < n and text[j] != '"':
                j += 2 if text[j] == "\\" else 1
            out.append(text[i:j + 1])
            i = j + 1
        elif text.startswith("//", i):
            i = text.find("\n", i)
            i = n if i == -1 else i
        elif text.startswith("/*", i):
            i = text.find("*/", i + 2)
            i = n if i == -1 else i + 2
        elif c == ",":
            j = i + 1
            while j < n and text[j] in " \t\r\n":
                j += 1
            if j < n and text[j] in "}]":
                i += 1
            else:
                out.append(c)
                i += 1
        else:
            out.append(c)
            i += 1
    return json.loads("".join(out))


def load(path=MENU):
    if not os.path.exists(path):
        return {}
    with open(path) as f:
        return parse_jsonc(f.read())


def parent(item_id):
    return item_id.rsplit(".", 1)[0] if "." in item_id else "root"


def children(items, menu_id):
    return [key for key in items if parent(key) == menu_id]


def resolve(items, route):
    if route in items or route == "root":
        return route
    for key, entry in items.items():
        if route in entry.get("aliases", []):
            return key
    return "root"


def destination(items, item_id):
    return items[item_id].get("target", item_id)


def _succeeds(command):
    if not command:
        return True
    try:
        return subprocess.run(["bash", "-c", command], stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                              stderr=subprocess.DEVNULL, timeout=3).returncode == 0
    except subprocess.TimeoutExpired:
        return False


def _usable(items, key):
    entry = items[key]
    if entry.get("action") or entry.get("target") or entry.get("provider"):
        return True
    return any(_usable(items, child) for child in children(items, key))


def rows(items, menu_id):
    keys = [key for key in children(items, menu_id) if _usable(items, key)]
    with ThreadPoolExecutor(max_workers=16) as pool:
        shown = list(pool.map(lambda key: _succeeds(items[key].get("when")), keys))
        keys = [key for key, ok in zip(keys, shown) if ok]
        checked = list(pool.map(lambda key: "checked" in items[key] and _succeeds(items[key]["checked"]), keys))
    return [Row(key, _label(items[key], ticked), ticked) for key, ticked in zip(keys, checked)]


def _label(entry, ticked):
    icon = entry.get("icon", "")
    text = f"{icon}  {entry.get('label', '')}" if icon else entry.get("label", "")
    return text + ("  ✓" if ticked else "")


def provider_rows(name):
    script, command = PROVIDERS[name]
    output = subprocess.run(["bash", "-c", script], capture_output=True, text=True).stdout
    result = []
    for line in output.splitlines():
        label, value, current = (line.split("\t") + ["", ""])[:3]
        ticked = value == current or label == current
        result.append(Row(f"{command} {shlex.quote(value)}", label + ("  ✓" if ticked else ""), ticked))
    return result


def fuzzel_config(scheme_path=SCHEME, icon_theme="Papirus-Dark"):
    """A fuzzel config coloured from Caelestia's current scheme (dark fallback without it)."""
    colours = dict(FALLBACK_COLOURS)
    try:
        with open(scheme_path) as f:
            colours.update(json.load(f).get("colours", {}))
    except (OSError, ValueError):
        pass
    return STYLE.format(icon_theme=icon_theme, **colours)


def _icon_theme():
    result = subprocess.run(["gsettings", "get", "org.gnome.desktop.interface", "icon-theme"],
                            capture_output=True, text=True)
    return result.stdout.strip().strip("'") or "hicolor"


def _write_config():
    os.makedirs(os.path.dirname(CONFIG), exist_ok=True)
    with open(CONFIG, "w") as f:
        f.write(fuzzel_config(SCHEME, _icon_theme()))
    return CONFIG


def selected_index(options, output):
    """Index of the option a dmenu printed, or None on cancel or free text."""
    choice = output.rstrip("\n")
    return options.index(choice) if choice in options else None


def _noctalia_running():
    runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    return bool(glob.glob(os.path.join(runtime, "noctalia-dmenu-*.sock")))


def pick(prompt, options):
    """Show options in Noctalia's launcher (fuzzel without it); return the chosen index or None."""
    if _noctalia_running():
        result = subprocess.run(["noctalia", "dmenu", "--prompt", prompt],
                                input="\n".join(options), capture_output=True, text=True)
        return selected_index(options, result.stdout)
    result = subprocess.run(["fuzzel", "--config", _write_config(), "--dmenu", "--index",
                             "--placeholder", prompt],
                            input="\n".join(options), capture_output=True, text=True)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return int(result.stdout.strip())


def run(command):
    subprocess.Popen(["bash", "-c", command], start_new_session=True, stdin=subprocess.DEVNULL,
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def show(items, menu_id):
    while True:
        entry = items.get(menu_id, {})
        if entry.get("action"):
            return run(entry["action"])
        if entry.get("provider") == "apps":
            return run(APPS)
        if entry.get("provider") in PROVIDERS:
            options = provider_rows(entry["provider"])
            texts = [row.text for row in options]
            commands = [row.id for row in options]
        else:
            options = rows(items, menu_id)
            texts = [row.text for row in options]
            commands = None
        if menu_id != "root":
            texts.append(BACK)
        choice = pick(entry.get("label", "Menu"), texts)
        if choice is None:
            return
        if choice == len(options):
            menu_id = parent(menu_id)
        elif commands:
            return run(commands[choice])
        else:
            menu_id = destination(items, options[choice].id)


def parse_args(argv):
    if argv and argv[0] in VERBS:
        return argv[0], (argv[1] if len(argv) > 1 else "root")
    return "toggle", (argv[0] if argv else "root")


def main(argv):
    verb, route = parse_args(argv)
    running = subprocess.run(["pgrep", "-x", "fuzzel"], stdout=subprocess.DEVNULL).returncode == 0
    if verb == "close" or (verb == "toggle" and running):
        subprocess.run(["pkill", "-x", "fuzzel"])
        return
    if running:
        subprocess.run(["pkill", "-x", "fuzzel"])
    items = load()
    show(items, resolve(items, route))


if __name__ == "__main__":
    main(sys.argv[1:])
