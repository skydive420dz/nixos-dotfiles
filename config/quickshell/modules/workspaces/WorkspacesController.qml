import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Scope {
    id: root

    property var occupiedWorkspaces: ({})

    function refreshWorkspaces() {
        workspaceTimer.restart();
    }

    Component.onCompleted: refreshWorkspaces()

    Connections {
        target: Hyprland

        function onRawEvent(event) {
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
}
