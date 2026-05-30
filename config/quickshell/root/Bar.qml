import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../common"
import "../modules/launcher"
import "../modules/media"
import "../modules/status"
import "../modules/theme"
import "../modules/tray"
import "../modules/window"
import "../modules/workspaces"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Theme.barHeight + frameWidth - 1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-bar"

    anchors {
        top: true
        left: true
        right: true
    }

    readonly property int frameWidth: 3
    readonly property int frameRadius: 10

    implicitHeight: root.screen?.height ?? Theme.barHeight + frameRadius + frameWidth
    color: "transparent"

    mask: Region {
        item: barRow
    }

    required property var mediaController

    BarFrame {
        id: unifiedBarBackground

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: parent.height
        barHeight: Theme.barHeight
        frameWidth: root.frameWidth
        frameRadius: root.frameRadius
        borderWidth: 2
    }

    RowLayout {
        id: barRow
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
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

        ThemeToggle {}

        Tray {
            panelWindow: root
        }

        StatusCluster {}
    }
}
