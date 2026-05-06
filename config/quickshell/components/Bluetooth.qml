import ".."
import QtQuick
import Quickshell.Io
import QtQuick.Controls

Item {
    id: root

    implicitWidth: btText.implicitWidth + 8
    implicitHeight: Style.pillHeight

    property string icon: "󰂯"
    property string tip: "Bluetooth"

    Text {
        id: btText
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
        // Left click  → open bluetui
        onClicked: bluetuiProc.running = true
        // Right click  → toggle bluetooth power (matches your waybar on-click-right)
        onPressAndHold: rfkillProc.running = true
    }

    // ── Data fetching ─────────────────────────────────────────────────────────

    Process {
        id: btProc
        command: ["bash", "-c", ["power=$(bluetoothctl show | awk '/PowerState/ {print $2}')", "device=$(bluetoothctl devices Connected | awk '{$1=$2=\"\"; print $0}' | head -1 | xargs)", "echo $power:$device"].join("; ")]

        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(":");
                var power = parts[0];
                var device = parts.slice(1).join(":").trim();

                if (power === "off" || power === "off-blocked") {
                    root.icon = "󰂲";
                    root.tip = "Bluetooth Off";
                } else if (device) {
                    root.icon = "󰂱";
                    root.tip = "Connected: " + device;
                } else {
                    root.icon = "󰂰";
                    root.tip = "Bluetooth On";
                }
            }
        }
    }

    Process {
        id: bluetuiProc
        command: ["kitty", "--class", "bluetui", "-T", "bluetui", "-e", "bluetui"]
        running: false
    }

    Process {
        id: rfkillProc
        command: ["rfkill", "toggle", "bluetooth"]
        running: false
        onExited: btProc.running = true   // refresh status after toggle
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: btProc.running = true
    }
}
