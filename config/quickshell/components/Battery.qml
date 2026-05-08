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
    property int chargeNow: 0
    property int currentNow: 0

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

    readonly property string timeRemaining: {
        if (currentNow <= 0)
            return "";
        var hours;
        if (charging)
            hours = (health / 100 * 4253000 - chargeNow) / currentNow;
        else if (!plugged)
            hours = chargeNow / currentNow;
        else
            return "";
        if (hours < 0)
            return "";
        var h = Math.floor(hours);
        var m = Math.round((hours - h) * 60);
        if (h === 0)
            return m + "m";
        return h + "h " + m + "m";
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

    // ── Refresh function ──────────────────────────────────────────────────────
    function refresh() {
        capProc.running = true;
        statusProc.running = true;
        chargeNowProc.running = true;
        currentNowProc.running = true;
    }

    // ── sysfs reads ───────────────────────────────────────────────────────────
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
        id: chargeNowProc
        command: ["cat", "/sys/class/power_supply/BAT1/charge_now"]
        stdout: SplitParser {
            onRead: data => {
                root.chargeNow = parseInt(data.trim()) || 0;
            }
        }
    }

    Process {
        id: currentNowProc
        command: ["cat", "/sys/class/power_supply/BAT1/current_now"]
        stdout: SplitParser {
            onRead: data => {
                root.currentNow = parseInt(data.trim()) || 0;
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

    // ── udev monitor — instant plug/unplug events ─────────────────────────────
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

    // ── Initial load ──────────────────────────────────────────────────────────
    Component.onCompleted: {
        root.refresh();
        cycleProc.running = true;
        healthProc.running = true;
    }

    // ── 60s timer for capacity during discharge ───────────────────────────────
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    // ── 5 min timer for cycles/health (barely change) ─────────────────────────
    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: {
            cycleProc.running = true;
            healthProc.running = true;
        }
    }

    // ── Popover ───────────────────────────────────────────────────────────────
}
