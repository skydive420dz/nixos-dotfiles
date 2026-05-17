import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property var launcher: null

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
    }

    margins {
        left: 1
    }

    implicitWidth: barRow.implicitWidth
    implicitHeight: Style.barHeight
    color: "transparent"

    mask: Region {
        item: barRow
    }

    RowLayout {
        id: barRow
        height: Style.barHeight
        spacing: 0

        OsButton {
            launcher: root.launcher
            targetScreen: root.screen
        }
        Item {
            width: 6
        }
        Workspaces {}
        Item {
            width: Style.groupSpacing
        }
        WindowTitle {}
    }
}
