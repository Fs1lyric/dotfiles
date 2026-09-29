import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "lyric.launchers"

  // Left click launches or focuses the app; right click opens a new window.
  readonly property var apps: [
    {
      name: "Firefox",
      icon: "firefox.svg",
      focus: ["omarchy-launch-or-focus", "firefox", "uwsm-app -- firefox"],
      fresh: ["uwsm-app", "--", "firefox", "--new-window"]
    },
    {
      name: "Codex",
      icon: "codex.svg",
      focus: ["omarchy-launch-or-focus-tui", "codex"],
      fresh: ["omarchy-launch-tui", "--app-id=org.omarchy.codex-new", "codex"]
    },
    {
      name: "VS Code",
      icon: "vscode.png",
      focus: ["omarchy-launch-or-focus", "^code$", "uwsm-app -- code"],
      fresh: ["uwsm-app", "--", "code", "--new-window"]
    },
    {
      name: "Obsidian",
      icon: "obsidian.png",
      focus: ["omarchy-launch-or-focus", "md.obsidian.Obsidian", "uwsm-app -- obsidian"],
      fresh: ["uwsm-app", "--", "obsidian"]
    },
    {
      name: "Notion",
      icon: "notion.png",
      focus: ["omarchy-launch-or-focus-webapp", "Notion", "https://www.notion.so"],
      fresh: ["omarchy-launch-webapp", "https://www.notion.so"]
    },
    {
      name: "Claude Code",
      icon: "claude.svg",
      focus: ["omarchy-launch-or-focus-tui", "claude"],
      fresh: ["omarchy-launch-tui", "--app-id=org.omarchy.claude-new", "claude"]
    }
  ]

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Row {
    id: row
    anchors.fill: parent

    Repeater {
      model: root.apps

      BarIconButton {
        required property var modelData
        bar: root.bar
        tooltipText: modelData.name

        iconComponent: Component {
          Image {
            source: Qt.resolvedUrl(modelData.icon)
            sourceSize.width: width * 2
            sourceSize.height: height * 2
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
          }
        }

        onPressed: function(buttonCode) {
          Quickshell.execDetached(buttonCode === Qt.RightButton ? modelData.fresh : modelData.focus)
        }
      }
    }
  }
}
