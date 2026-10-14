import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import omenu  # noqa: E402

SAMPLE = """{
  // a comment with "quotes" and a url https://x.y
  "apps": {"icon":"A","label":"Apps","aliases":["app"],"provider":"apps"},
  "system": {"icon":"S","label":"System","aliases":["power-menu"]},
  /* block
     comment */
  "system.lock": {"icon":"L","label":"Lock","action":"echo 'https://not-a-comment'"},
  "system.gone": {"label":"Gone","when":"false","action":"true"},
  "system.on": {"label":"On","checked":"true","action":"true"},
  "trigger": {"label":"Trigger"},
  "trigger.link": {"label":"Go system","target":"system"},
  "trigger.empty": {"label":"Nothing inside"},
}
"""


class ParseTest(unittest.TestCase):
    def test_strips_comments_and_trailing_commas_but_not_strings(self):
        items = omenu.parse_jsonc(SAMPLE)
        self.assertEqual(items["system.lock"]["action"], "echo 'https://not-a-comment'")
        self.assertEqual(list(items)[0], "apps")

    def test_own_menu_parses_with_a_system_section(self):
        with open(omenu.MENU) as f:
            items = omenu.parse_jsonc(f.read())
        self.assertIn("system", items)
        self.assertTrue(omenu.children(items, "root"))

    def test_own_menu_providers_all_exist(self):
        with open(omenu.MENU) as f:
            items = omenu.parse_jsonc(f.read())
        for key, entry in items.items():
            if "provider" in entry:
                self.assertIn(entry["provider"], [*omenu.PROVIDERS, "apps"], key)


class TreeTest(unittest.TestCase):
    def setUp(self):
        self.items = omenu.parse_jsonc(SAMPLE)

    def test_children_follow_dotted_ids_in_file_order(self):
        self.assertEqual(omenu.children(self.items, "root"), ["apps", "system", "trigger"])
        self.assertEqual(
            omenu.children(self.items, "system"), ["system.lock", "system.gone", "system.on"]
        )

    def test_resolve_route_by_id_alias_and_root(self):
        self.assertEqual(omenu.resolve(self.items, "root"), "root")
        self.assertEqual(omenu.resolve(self.items, "system.lock"), "system.lock")
        self.assertEqual(omenu.resolve(self.items, "power-menu"), "system")
        self.assertEqual(omenu.resolve(self.items, "nope"), "root")

    def test_rows_hide_failed_when_mark_checked_and_drop_empty_submenus(self):
        rows = omenu.rows(self.items, "system")
        self.assertEqual([r.id for r in rows], ["system.lock", "system.on"])
        self.assertTrue(rows[1].checked)
        self.assertEqual(omenu.rows(self.items, "trigger")[0].id, "trigger.link")
        self.assertEqual(len(omenu.rows(self.items, "trigger")), 1)

    def test_target_and_parent_navigation(self):
        self.assertEqual(omenu.destination(self.items, "trigger.link"), "system")
        self.assertEqual(omenu.parent("system.lock"), "system")
        self.assertEqual(omenu.parent("system"), "root")


class LoadTest(unittest.TestCase):
    def test_load_reads_the_given_menu(self):
        with tempfile.TemporaryDirectory() as d:
            own = os.path.join(d, "menu.jsonc")
            with open(own, "w") as f:
                f.write('{"mine": {"label": "Mine"}}')
            self.assertEqual(list(omenu.load(own)), ["mine"])

    def test_load_without_a_menu_is_empty(self):
        self.assertEqual(omenu.load("/nonexistent/menu.jsonc"), {})

    def test_menu_lives_in_config_omenu(self):
        self.assertEqual(omenu.MENU, os.path.expanduser("~/.config/omenu/menu.jsonc"))


class ArgsTest(unittest.TestCase):
    def test_bare_route_means_toggle(self):
        self.assertEqual(omenu.parse_args(["apps"]), ("toggle", "apps"))

    def test_verb_and_route(self):
        self.assertEqual(omenu.parse_args(["summon", "system"]), ("summon", "system"))
        self.assertEqual(omenu.parse_args(["close"]), ("close", "root"))

    def test_no_args_toggles_root(self):
        self.assertEqual(omenu.parse_args([]), ("toggle", "root"))


class ProviderTest(unittest.TestCase):
    def test_rows_turn_into_commands_and_tick_the_current_value(self):
        saved = dict(omenu.PROVIDERS)
        omenu.PROVIDERS["fake"] = ("printf 'A\\ta\\tb\\nB\\tb\\tb\\n'", "set-it")
        try:
            rows = omenu.provider_rows("fake")
        finally:
            omenu.PROVIDERS.clear()
            omenu.PROVIDERS.update(saved)
        self.assertEqual([r.id for r in rows], ["set-it a", "set-it b"])
        self.assertEqual([r.checked for r in rows], [False, True])


class StyleTest(unittest.TestCase):
    def test_config_uses_caelestia_colours(self):
        with tempfile.TemporaryDirectory() as d:
            scheme = os.path.join(d, "scheme.json")
            with open(scheme, "w") as f:
                f.write('{"colours": {"surface": "111111", "surfaceContainerHigh": "222222", '
                        '"onSurface": "eeeeee", "onSurfaceVariant": "cccccc", "primary": "abcdef", "outline": "999999"}}')
            text = omenu.fuzzel_config(scheme, "Papirus-Dark")
        self.assertIn("background=111111f2", text)
        self.assertIn("selection=222222ff", text)
        self.assertIn("match=abcdefff", text)
        self.assertIn("icon-theme=Papirus-Dark", text)

    def test_config_falls_back_without_caelestia(self):
        text = omenu.fuzzel_config("/nonexistent/scheme.json", "hicolor")
        self.assertIn("background=", text)
        self.assertIn("[border]", text)


class PickTest(unittest.TestCase):
    def test_selected_index_maps_dmenu_text_back(self):
        options = ["A  Apps", "S  System", "  Back"]
        self.assertEqual(omenu.selected_index(options, "S  System\n"), 1)

    def test_selected_index_none_on_cancel_or_unknown(self):
        self.assertIsNone(omenu.selected_index(["a"], ""))
        self.assertIsNone(omenu.selected_index(["a"], "typed text\n"))


if __name__ == "__main__":
    unittest.main()
