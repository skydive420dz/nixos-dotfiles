import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    implicitWidth: battText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    property int capacity: 100
    property string status: "Unknown"
    property bool charging: false
    property bool plugged: false
    property int cycleCount: 0
    property int health: 100

    readonly property string icon: {
        if (charging)
            return "󰉁";
        if (plugged)
            return "󰚥";
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

    readonly property color iconColor: charging || plugged ? Mocha.green : capacity <= 15 ? Mocha.red : capacity <= 30 ? Mocha.yellow : Mocha.teal

    readonly property string statusLabel: {
        if (charging)
            return "Charging";
        if (status === "Full")
            return "Full";
        if (status === "Not charging")
            return "Plugged in";
        if (status === "Discharging")
            return "Discharging";
        return status;
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
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
    }

    // ── Single-file sysfs reads ───────────────────────────────────────────────
    function refresh() {
        capProc.running = true;
        statusProc.running = true;
    }

    Process {
        id: capProc
        command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
        stdout: SplitParser {
            onRead: data => {
                root.capacity = parseInt(data.trim()) || 100;
            }
        }
    }

    Process {
        id: statusProc
        command: ["cat", "/sys/class/power_supply/BAT1/status"]
        stdout: SplitParser {
            onRead: data => {
                root.status = data.trim();
                root.charging = root.status === "Charging";
                root.plugged = root.status === "Full" || root.status === "Not charging";
            }
        }
    }

    Process {
        id: cycleProc
        command: ["cat", "/sys/class/power_supply/BAT1/cycle_count"]
        stdout: SplitParser {
            onRead: data => {
                root.cycleCount = parseInt(data.trim()) || 0;
            }
        }
    }

    Process {
        id: healthProc
        command: ["bash", "-c", "full=$(cat /sys/class/power_supply/BAT1/charge_full); " + "design=$(cat /sys/class/power_supply/BAT1/charge_full_design); " + "echo $full $design"]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(" ");
                var full = parseInt(p[0]);
                var design = parseInt(p[1]);
                if (full > 0 && design > 0)
                    root.health = Math.round((full / design) * 100);
            }
        }
    }

    // ── Event-driven via udev — fires instantly on plug/unplug ────────────────
    Process {
        id: udevMonitor
        command: ["udevadm", "monitor", "--kernel", "--subsystem-match=power_supply"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("power_supply"))
                    root.refresh();
            }
        }
    }

    // ── Initial load + slow refresh for cycles/health ─────────────────────────
    Component.onCompleted: {
        root.refresh();
        cycleProc.running = true;
        healthProc.running = true;
    }

    Timer {
        interval: 300000   // 5 min for cycles/health
        running: true
        repeat: true
        onTriggered: {
            cycleProc.running = true;
            healthProc.running = true;
        }
    }

    // ── Popover ───────────────────────────────────────────────────────────────
    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 240
        popHeight: battPopCol.implicitHeight + 28

        ColumnLayout {
            id: battPopCol
            anchors.fill: parent
            spacing: 8

            RowLayout {
                Text {
                    text: root.icon
                    font.pixelSize: 22
                    font.family: Style.font
                    color: root.iconColor
                }
                ColumnLayout {
                    spacing: 1
                    Text {
                        text: root.capacity + "%  " + root.statusLabel
                        font.pixelSize: Style.fontSize
                        font.family: Style.font
                        font.bold: true
                        color: Mocha.text
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: 10
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Mocha.surface1
                    Rectangle {
                        width: parent.width * (root.capacity / 100)
                        height: parent.height
                        radius: parent.radius
                        color: root.iconColor
                        Behavior on width {
                            NumberAnimation {
                                duration: 500
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Mocha.pillBorder
            }

            Repeater {
                model: [
                    {
                        label: "🔋 Health",
                        value: root.health + "%"
                    },
                    {
                        label: "🔄 Cycles",
                        value: root.cycleCount.toString()
                    }
                ]
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: modelData.label
                        color: Mocha.subtext0
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        Layout.preferredWidth: 80
                    }
                    Text {
                        text: modelData.value
                        color: Mocha.text
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                    }
                }
            }
        }
    }
}
