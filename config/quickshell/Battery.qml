import QtQuick
import Quickshell.Io
import "../theme"

Item {
    id: root

    implicitWidth: battText.implicitWidth + 8
    implicitHeight: Style.pillHeight

    property int capacity: 100
    property string status: "Unknown"
    property bool charging: false

    readonly property string icon: {
        if (charging)
            return "󰉁";
        if (capacity >= 91)
            return "󰁹";
        if (capacity >= 81)
            return "󰂂";
        if (capacity >= 71)
            return "󰂁";
        if (capacity >= 61)
            return "󰂀";
        if (capacity >= 51)
            return "󰁿";
        if (capacity >= 41)
            return "󰁾";
        if (capacity >= 31)
            return "󰁽";
        if (capacity >= 21)
            return "󰁼";
        if (capacity >= 11)
            return "󰁻";
        return "󰂎";
    }

    readonly property color iconColor: {
        if (charging)
            return Mocha.green;
        if (capacity <= 15)
            return Mocha.red;
        if (capacity <= 30)
            return Mocha.yellow;
        return Mocha.teal;
    }

    Text {
        id: battText
        anchors.centerIn: parent
        text: root.icon + " " + root.capacity + "%"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.iconColor

        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }

        ToolTip.visible: hover.containsMouse
        ToolTip.text: root.charging ? "Charging — " + root.capacity + "%" : "Discharging — " + root.capacity + "%"
        ToolTip.delay: 400
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
    }

    // ── Data fetching ─────────────────────────────────────────────────────────
    // Reads from sysfs; BAT* glob handles BAT0, BAT1, etc.

    Process {
        id: battProc
        command: ["bash", "-c", "cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1);" + "sta=$(cat /sys/class/power_supply/BAT*/status   2>/dev/null | head -1);" + "echo ${cap:-100}:${sta:-Unknown}"]

        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(":");
                root.capacity = parseInt(parts[0]) || 100;
                root.status = parts[1] || "Unknown";
                root.charging = root.status === "Charging" || root.status === "Full";
            }
        }
    }

    Timer {
        interval: 30000   // 30s
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: battProc.running = true
    }
}
