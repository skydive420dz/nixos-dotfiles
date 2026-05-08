import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    implicitWidth: btText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    property string icon: "󰂯"
    property string powerState: "off"
    property string deviceName: ""
    property string deviceAddr: ""
    property int deviceBatt: -1
    property var pairedDevices: []

    Text {
        id: btText
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.teal
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: bluetuiToggle.toggle()
        onPressAndHold: rfkillProc.running = true
    }

    WindowToggle {
        id: bluetuiToggle
        windowClass: "bluetui"
        launchCommand: ["kitty", "--class", "bluetui", "-T", "bluetui", "-e", "bluetui"]
    }

    // ── Refresh trigger ───────────────────────────────────────────────────────
    function refresh() {
        powerProc.running = true;
        connectedProc.running = true;
        pairedProc.running = true;
    }

    // ── Power state ───────────────────────────────────────────────────────────
    Process {
        id: powerProc
        command: ["bash", "-c", "echo -e 'show\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            var match = powerProc.stdout.buffer.match(/PowerState:\s*(\S+)/);
            root.powerState = match ? match[1] : "off";
            powerProc.stdout.buffer = "";
            updateIcon();
        }
    }

    // ── Connected device ──────────────────────────────────────────────────────
    Process {
        id: connectedProc
        command: ["bash", "-c", "echo -e 'devices Connected\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            // Find first "Device <addr> <name>" line
            var match = connectedProc.stdout.buffer.match(/^Device\s+(\S+)\s+(.+)$/m);
            if (match) {
                root.deviceAddr = match[1];
                root.deviceName = match[2].trim();
                battProc.running = true;
            } else {
                root.deviceAddr = "";
                root.deviceName = "";
                root.deviceBatt = -1;
            }
            connectedProc.stdout.buffer = "";
            updateIcon();
        }
    }

    // ── Battery for connected device ──────────────────────────────────────────
    Process {
        id: battProc
        command: ["bash", "-c", "echo -e 'info " + root.deviceAddr + "\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            // Format: "Battery Percentage: 0x5a (90)"
            var match = battProc.stdout.buffer.match(/Battery Percentage:[^(]*\((\d+)\)/);
            root.deviceBatt = match ? parseInt(match[1]) : -1;
            battProc.stdout.buffer = "";
        }
    }

    // ── Paired devices list ───────────────────────────────────────────────────
    Process {
        id: pairedProc
        command: ["bash", "-c", "echo -e 'devices Paired\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            var lines = pairedProc.stdout.buffer.split("\n");
            var devices = [];
            for (var i = 0; i < lines.length; i++) {
                var m = lines[i].match(/^Device\s+(\S+)\s+(.+)$/);
                if (m)
                    devices.push({
                        addr: m[1],
                        name: m[2].trim()
                    });
            }
            root.pairedDevices = devices;
            pairedProc.stdout.buffer = "";
        }
    }

    function updateIcon() {
        if (root.powerState !== "on")
            root.icon = "󰂲";
        else if (root.deviceName)
            root.icon = "󰂱";
        else
            root.icon = "󰂰";
    }

    // ── Event-driven — bluetoothctl monitor ───────────────────────────────────
    Process {
        id: btMonitor
        command: ["bluetoothctl", "monitor"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim();
                if (line.includes("Connected") || line.includes("PowerState") || line.includes("Battery")) {
                    root.refresh();
                }
            }
        }
    }

    Process {
        id: rfkillProc
        command: ["rfkill", "toggle", "bluetooth"]
        running: false
        onExited: root.refresh()
    }

    Component.onCompleted: root.refresh()

    // ── Popover ───────────────────────────────────────────────────────────────
}
