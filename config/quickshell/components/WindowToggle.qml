import ".."
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

// Drop this as a child of any component that needs to toggle a floating window.
// Usage:
//   WindowToggle { id: toggle; windowClass: "bluetui"; launchCommand: ["kitty", ...] }
//   onClicked: toggle.toggle()

QtObject {
    id: root

    property string windowClass: ""
    property var launchCommand: []

    function toggle() {
        _checkProc.running = true;
    }

    property var _checkProc: Process {
        command: ["bash", "-c", "hyprctl clients -j | jq -e --arg c \"" + root.windowClass + "\" 'any(.[]; .class == $c)' > /dev/null 2>&1 && echo exists || echo absent"]

        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "exists") {
                    Hyprland.dispatch("closewindow class:" + root.windowClass);
                } else {
                    _launchProc.running = true;
                }
            }
        }
    }

    property var _launchProc: Process {
        command: root.launchCommand
        running: false
    }
}
