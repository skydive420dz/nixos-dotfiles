import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    implicitWidth: netText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    property string icon: "󰤟"
    property string ssid: ""
    property string ipAddr: ""
    property string iface: ""
    property int signal: 0
    property string connType: ""

    Text {
        id: netText
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
        onClicked: nmtuiToggle.toggle()
    }

    WindowToggle {
        id: nmtuiToggle
        windowClass: "nmtui"
        launchCommand: ["kitty", "--class", "nmtui", "-T", "nmtui", "-e", "nmtui"]
    }

    // ── Status fetch — runs on demand ─────────────────────────────────────────
    function refresh() {
        netStatusProc.running = true;
    }

    Process {
        id: netStatusProc
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "device", "status"]
        stdout: SplitParser {
            // Track whether we found a connected interface across all lines
            property bool anyConnected: false

            onRead: data => {
                var line = data.trim();
                var parts = line.split(":");
                if (parts.length < 4)
                    return;

                // Strict match — only "wifi" or "ethernet", not "wifi-p2p" etc.
                if (parts[1] !== "wifi" && parts[1] !== "ethernet")
                    return;

                // Skip interfaces that aren't actually connected
                if (parts[2] !== "connected")
                    return;

                // Found a connected interface — populate state
                anyConnected = true;
                root.iface = parts[0];
                root.connType = parts[1];
                if (parts[1] === "ethernet") {
                    root.icon = "󰈀";
                    ipProc.running = true;
                } else {
                    wifiProc.running = true;
                }
            }
        }

        // After process exits, if no connected interface was found, set disconnected
        onExited: {
            if (!netStatusProc.stdout.anyConnected) {
                root.icon = "󰤯";
                root.connType = "disconnected";
                root.iface = "";
                root.ipAddr = "";
                root.ssid = "";
                root.signal = 0;
            }
            netStatusProc.stdout.anyConnected = false;
        }
    }

    Process {
        id: wifiProc
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL", "device", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.startsWith("*"))
                    return;
                var parts = data.trim().replace(/^\*:/, "").split(":");
                root.ssid = parts[0] ?? "";
                root.signal = parseInt(parts[1] ?? "0");
                root.icon = root.signal > 75 ? "󰤨" : root.signal > 50 ? "󰤥" : root.signal > 25 ? "󰤢" : "󰤟";
                ipProc.running = true;
            }
        }
    }

    Process {
        id: ipProc
        command: ["bash", "-c", "ip -4 addr show " + root.iface + " 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -1"]
        stdout: SplitParser {
            onRead: data => {
                root.ipAddr = data.trim();
            }
        }
    }

    // ── Event-driven — nmcli monitor reacts to connection changes ─────────────
    Process {
        id: nmMonitor
        command: ["nmcli", "monitor"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                // Any line from nmcli monitor means something changed
                if (data.trim().length > 0)
                    root.refresh();
            }
        }
    }

    Component.onCompleted: root.refresh()

    // ── Popover ───────────────────────────────────────────────────────────────
}
