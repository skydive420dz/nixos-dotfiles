import QtQuick
import Quickshell.Io

Item {
    id: root

    implicitWidth: netText.implicitWidth + 8
    implicitHeight: Style.pillHeight

    property string icon: "󰤟"
    property string tip: "Network"

    Text {
        id: netText
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.teal

        ToolTip.visible: hover.containsMouse
        ToolTip.text: root.tip
        ToolTip.delay: 400
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        // Click opens nmtui in a floating kitty window
        onClicked: nmtuiProc.running = true
    }

    // ── Data fetching ─────────────────────────────────────────────────────────

    // Step 1 — get connection type and state
    Process {
        id: netStatusProc
        command: ["bash", "-c", "nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status" + " | grep -E 'wifi|ethernet' | head -1"]

        stdout: SplitParser {
            onRead: data => {
                // Format: DEVICE:TYPE:STATE:CONNECTION
                var parts = data.trim().split(":");
                if (parts.length < 4) {
                    root.icon = "󰤯";
                    root.tip = "Disconnected";
                    return;
                }
                var type = parts[1];
                var state = parts[2];
                var conn = parts[3];

                if (state === "connected") {
                    if (type === "ethernet") {
                        root.icon = "󰈀";
                        root.tip = "Ethernet: " + conn;
                    } else {
                        wifiProc.running = true;   // get signal strength
                    }
                } else {
                    root.icon = "󰤯";
                    root.tip = "Disconnected";
                }
            }
        }
    }

    // Step 2 — get Wi-Fi SSID + signal (only runs when connected to wifi)
    Process {
        id: wifiProc
        command: ["bash", "-c", "nmcli -t -f IN-USE,SSID,SIGNAL device wifi 2>/dev/null" + " | grep '^\\*' | head -1"]

        stdout: SplitParser {
            onRead: data => {
                // Format: *:SSID:SIGNAL
                var parts = data.trim().replace(/^\*:/, "").split(":");
                var ssid = parts[0] ?? "";
                var signal = parseInt(parts[1] ?? "0");

                if (signal > 75)
                    root.icon = "󰤨";
                else if (signal > 50)
                    root.icon = "󰤥";
                else if (signal > 25)
                    root.icon = "󰤢";
                else
                    root.icon = "󰤟";

                root.tip = "Wi-Fi: " + ssid + " (" + signal + "%)";
            }
        }
    }

    Process {
        id: nmtuiProc
        command: ["kitty", "--class", "nmtui", "-T", "nmtui", "-e", "nmtui"]
        running: false
    }

    Timer {
        interval: 10000   // 10s — same as your waybar interval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netStatusProc.running = true
    }
}
