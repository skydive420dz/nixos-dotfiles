import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
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
    property var occupiedIds: ({})

    function refreshOccupied() {
        wsListProc.running = true;
    }

    // ── Initial state via hyprctl one-shot ────────────────────────────────────
    Process {
        id: wsListProc
        command: ["hyprctl", "workspaces", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            try {
                var ws = JSON.parse(wsListProc.stdout.buffer.trim());
                var ids = {};
                for (var i = 0; i < ws.length; i++)
                    if (ws[i].windows > 0)
                        ids[ws[i].id] = true;
                root.occupiedIds = {};
                root.occupiedIds = ids;
            } catch (e) {}
            wsListProc.stdout.buffer = "";
        }
    }

    Component.onCompleted: {
        activeId = Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1;
        refreshOccupied();
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            switch (event.name) {
            case "workspace":
                root.activeId = parseInt(event.data) || root.activeId;
                break;
            case "focusedmon":
                {
                    var p = event.data.split(",");
                    root.activeId = parseInt(p[1]) || root.activeId;
                    break;
                }
            case "openwindow":
            case "closewindow":
            case "movewindow":
            case "movewindowv2":
                root.refreshOccupied();
                break;
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
