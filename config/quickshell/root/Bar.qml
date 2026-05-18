import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
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

        Rectangle {
            Layout.preferredHeight: Theme.pillHeight
            Layout.preferredWidth: launcherText.implicitWidth + Theme.pad * 2
            radius: Theme.radius
            color: launcherMouse.containsMouse ? Theme.panelAlt : Theme.panel
            border.color: Theme.border
            border.width: 1

            Text {
                id: launcherText
                anchors.centerIn: parent
                text: "󱄅"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: 18
            }

            MouseArea {
                id: launcherMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        Quickshell.execDetached(["bash", "-lc", "$HOME/.config/scripts/clipboard-toggle"]);
                    else
                        Quickshell.execDetached(["bash", "-lc", "$HOME/.config/scripts/launcher-toggle"]);
                }
            }
        }

        Workspaces {}

        WindowTitle {}

        Item {
            Layout.fillWidth: true
        }

        Media {
            controller: root.mediaController
        }

        Tray {}

        StatusCluster {}
    }
}
