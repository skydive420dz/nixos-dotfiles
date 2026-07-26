import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Scope {
    id: root

    property string activeClass: ""
    property string activeTitle: ""
    property bool activeWindowRefreshPending: false
    property int activeWindowRevision: 0

    function loadActiveWindow(payload) {
        try {
            var win = JSON.parse(payload.trim());
            root.activeClass = win.class ?? "";
            root.activeTitle = win.title ?? "";
        } catch (e) {
            root.activeClass = "";
            root.activeTitle = "";
        }
    }

    function scheduleActiveWindowRefresh() {
        root.activeWindowRevision++;
        root.activeWindowRefreshPending = true;
        activeWindowRefreshTimer.restart();
    }

    Component.onCompleted: {
        activeWindowProc.requestRevision = root.activeWindowRevision;
        activeWindowProc.running = true;
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activewindow") {
                root.activeWindowRevision++;
                root.activeWindowRefreshPending = false;
                activeWindowRefreshTimer.stop();
                var active = event.data.split(",");
                root.activeClass = active[0] ?? "";
                root.activeTitle = active.slice(1).join(",") ?? "";
            } else if (event.name === "closewindow") {
                root.scheduleActiveWindowRefresh();
            }
        }
    }

    Timer {
        id: activeWindowRefreshTimer
        interval: 100
        repeat: false
        onTriggered: {
            if (activeWindowProc.running)
                return;

            root.activeWindowRefreshPending = false;
            activeWindowProc.requestRevision = root.activeWindowRevision;
            activeWindowProc.running = true;
        }
    }

    Process {
        id: activeWindowProc
        property int requestRevision: 0
        command: ["hyprctl", "activewindow", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            if (!root.activeWindowRefreshPending && requestRevision === root.activeWindowRevision)
                root.loadActiveWindow(stdout.buffer);
            stdout.buffer = "";
            if (root.activeWindowRefreshPending)
                activeWindowRefreshTimer.restart();
        }
    }
}
