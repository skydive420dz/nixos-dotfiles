import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import "../modules/media"
import "../modules/status"
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

        RowLayout {
            Layout.preferredHeight: Theme.pillHeight
            spacing: Theme.gap
            visible: SystemTray.items.values.length > 0

            Repeater {
                model: SystemTray.items
                delegate: Image {
                    required property SystemTrayItem modelData
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    source: modelData.icon
                    smooth: true
                    mipmap: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.activate()
                    }
                }
            }
        }

        StatusCluster {}
    }
}
