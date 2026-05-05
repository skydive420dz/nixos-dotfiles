import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../theme"

Rectangle {
    id: root

    height: Style.pillHeight
    radius: Style.pillRadius
    color: Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1
    implicitWidth: wsRow.implicitWidth + 12

    // Active workspace id on the focused monitor
    readonly property int activeId: Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1

    // Ids of workspaces that currently have windows
    readonly property var occupiedIds: {
        var ids = {};
        var ws = Hyprland.workspaces.values;
        for (var i = 0; i < ws.length; i++)
            ids[ws[i].id] = true;
        return ids;
    }

    RowLayout {
        id: wsRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: 9   // persistent workspaces 1-9

            delegate: Rectangle {
                required property int index
                readonly property int wsId: index + 1
                readonly property bool isActive: wsId === root.activeId
                readonly property bool isOccupied: root.occupiedIds[wsId] ?? false

                height: 20
                radius: 50
                color: isActive ? Mocha.lavender : isOccupied ? Mocha.surface1 : Mocha.mantle

                implicitWidth: isActive ? 55 : 20

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: wsId.toString()
                    font.pixelSize: 11
                    font.family: Style.font
                    font.bold: true
                    color: parent.isActive ? Mocha.crust : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + wsId)
                }
            }
        }
    }
}
