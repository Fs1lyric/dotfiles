import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import defaults  # noqa: E402

DESKTOPS = {
    "firefox.desktop": "[Desktop Entry]\nName=Firefox\nMimeType=text/html;x-scheme-handler/https;\n",
    "hidden.desktop": "[Desktop Entry]\nName=Hidden\nNoDisplay=true\nMimeType=x-scheme-handler/https;\n",
    "kitty.desktop": "[Desktop Entry]\nName=kitty\nCategories=System;TerminalEmulator;\n",
    "imv.desktop": "[Desktop Entry]\nName=imv\nMimeType=image/png;\n\n[Desktop Action x]\nName=Other name\n",
}


class CandidatesTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        for name, body in DESKTOPS.items():
            with open(os.path.join(self.tmp.name, name), "w") as f:
                f.write(body)
        self.dirs = [self.tmp.name]

    def tearDown(self):
        self.tmp.cleanup()

    def test_browser_candidates_skip_hidden_apps(self):
        self.assertEqual(defaults.candidates("browser", self.dirs), [("Firefox", "firefox.desktop")])

    def test_terminal_candidates_come_from_category(self):
        self.assertEqual(defaults.candidates("terminal", self.dirs), [("kitty", "kitty.desktop")])

    def test_name_comes_from_main_entry_not_actions(self):
        self.assertEqual(defaults.candidates("images", self.dirs), [("imv", "imv.desktop")])

    def test_earlier_dirs_shadow_later_ones(self):
        with tempfile.TemporaryDirectory() as user:
            with open(os.path.join(user, "firefox.desktop"), "w") as f:
                f.write("[Desktop Entry]\nName=Firefox\nHidden=true\n")
            self.assertEqual(defaults.candidates("browser", [user, *self.dirs]), [])


class TerminalListTest(unittest.TestCase):
    def test_chosen_terminal_moves_to_the_top(self):
        text = "# comment\nkitty.desktop\nfoot.desktop\n"
        self.assertEqual(defaults.terminal_list(text, "foot.desktop"),
                         "# comment\nfoot.desktop\nkitty.desktop\n")

    def test_current_terminal_is_first_entry(self):
        self.assertEqual(defaults.first_terminal("# c\n\nkitty.desktop\nfoot.desktop\n"), "kitty.desktop")


class SetDefaultTest(unittest.TestCase):
    def test_browser_is_set_through_xdg_mime_not_xdg_settings(self):
        from unittest import mock
        with mock.patch.object(defaults.subprocess, "run") as run:
            defaults.set_default("browser", "zen.desktop")
        commands = [call.args[0][0] for call in run.call_args_list]
        self.assertNotIn("xdg-settings", commands)
        run.assert_any_call(["xdg-mime", "default", "zen.desktop", *defaults.KINDS["browser"]], check=True)


class MenuTest(unittest.TestCase):
    def test_every_kind_has_a_menu_row_and_provider(self):
        import omenu
        items = omenu.load()
        for kind in defaults.KINDS:
            self.assertIn(f"defaults.{kind}", items)
            self.assertIn(items[f"defaults.{kind}"]["provider"], omenu.PROVIDERS)


if __name__ == "__main__":
    unittest.main()
