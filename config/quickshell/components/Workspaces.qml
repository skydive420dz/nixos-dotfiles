import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: root

    height: Style.pillHeight
    radius: Style.pillRadius
    color: Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1
    implicitWidth: wsRow.implicitWidth + 12

    property int activeId: 1

    // Track which workspaces have windows
    property var occupiedIds: ({})

    function refreshOccupied() {
        var ids = {};
        var ws = Hyprland.workspaces.values;
        for (var i = 0; i < ws.length; i++)
            ids[ws[i].id] = true;
        occupiedIds = {};       // force change detection
        occupiedIds = ids;
    }

    Component.onCompleted: {
        activeId = Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1;
    }

    Timer {
        id: refreshTimer
        interval: 300
        repeat: false
        running: true
        onTriggered: {
            refreshOccupied();
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "workspace") {
                root.activeId = parseInt(event.data) || root.activeId;
                root.refreshOccupied();   // refresh every time you switch
            }
            if (event.name === "focusedmon") {
                var parts = event.data.split(",");
                root.activeId = parseInt(parts[1]) || root.activeId;
                root.refreshOccupied();
            }
            if (event.name === "openwindow" || event.name === "closewindow" || event.name === "movewindow") {
                root.refreshOccupied();
            }
        }
    }

    RowLayout {
        id: wsRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: 9

            delegate: Rectangle {
                required property int index
                readonly property int wsId: index + 1
                readonly property bool isActive: wsId === root.activeId
                readonly property bool isOccupied: root.occupiedIds[wsId] ?? false

                height: 20
                radius: 50
                implicitWidth: isActive ? 55 : 20
                color: isActive ? Mocha.lavender : isOccupied ? Mocha.surface1 : Mocha.mantle

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
