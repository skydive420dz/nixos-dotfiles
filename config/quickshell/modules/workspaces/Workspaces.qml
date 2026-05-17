import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Rectangle {
    id: root

    Layout.preferredHeight: Theme.pillHeight
    Layout.preferredWidth: workspaceRow.implicitWidth + Theme.pad * 2

    radius: Theme.radius
    color: Theme.panel
    border.color: Theme.border
    border.width: 1

    property int activeWorkspace: Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1
    property var occupiedWorkspaces: ({})

    function refreshWorkspaces() {
        workspaceTimer.restart();
    }

    Component.onCompleted: refreshWorkspaces()

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "workspace")
                root.activeWorkspace = parseInt(event.data) || root.activeWorkspace;
            else if (event.name === "focusedmon") {
                var parts = event.data.split(",");
                root.activeWorkspace = parseInt(parts[1]) || root.activeWorkspace;
            }

            if (event.name === "openwindow" || event.name === "closewindow" || event.name === "movewindowv2")
                root.refreshWorkspaces();
        }
    }

    Timer {
        id: workspaceTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (!workspaceProc.running)
                workspaceProc.running = true;
        }
    }

    Process {
        id: workspaceProc
        command: ["hyprctl", "workspaces", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            try {
                var workspaces = JSON.parse(stdout.buffer.trim());
                var occupied = {};
                for (var i = 0; i < workspaces.length; i++) {
                    if (workspaces[i].windows > 0)
                        occupied[workspaces[i].id] = true;
                }
                root.occupiedWorkspaces = occupied;
            } catch (e) {}
            stdout.buffer = "";
        }
    }

    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: 9
            delegate: Rectangle {
                required property int index
                readonly property int workspaceId: index + 1
                readonly property bool active: root.activeWorkspace === workspaceId
                readonly property bool occupied: root.occupiedWorkspaces[workspaceId] ?? false

                Layout.preferredWidth: active ? 25 : 16
                Layout.preferredHeight: 16
                radius: Theme.radiusSmall
                color: active ? Theme.accent : occupied ? Theme.border : Theme.bg

                Text {
                    anchors.centerIn: parent
                    text: parent.workspaceId
                    color: parent.active ? Theme.bg : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "workspace", parent.workspaceId.toString()])
                }
            }
        }
    }
}
