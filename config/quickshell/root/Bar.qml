import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../modules/launcher"
import "../modules/media"
import "../modules/status"
import "../modules/tray"
import "../modules/window"
import "../modules/workspaces"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Theme.barHeight - 1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-bar"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: "transparent"

    mask: Region {
        item: barRow
    }

    required property var mediaController

    RowLayout {
        id: barRow
        anchors {
            fill: parent
            leftMargin: 1
            rightMargin: 1
        }
        height: Theme.barHeight
        spacing: Theme.gap

        LauncherButton {}

        Workspaces {}

        WindowTitle {}

        Item {
            Layout.fillWidth: true
        }

        Media {
            controller: root.mediaController
        }

        Tray {
            panelWindow: root
        }

        StatusCluster {}
    }
}
