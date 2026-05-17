import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Theme.barHeight + 1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-bar"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: "transparent"

    mask: Region {
        item: barRow
    }

    property int activeWorkspace: Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1
    property var occupiedWorkspaces: ({})
    property string activeClass: ""
    property string activeTitle: ""
    property string clockText: ""
    property int volume: 0
    property bool muted: false
    property string network: ""
    property int battery: -1
    property bool charging: false

    function refreshWorkspaces() {
        workspaceTimer.restart();
    }

    function parseKeyValue(text) {
        var rows = text.trim().split("\n");
        for (var i = 0; i < rows.length; i++) {
            var parts = rows[i].split("=");
            var key = parts[0] ?? "";
            var value = parts.slice(1).join("=");

            if (key === "volume")
                root.volume = parseInt(value) || 0;
            else if (key === "muted")
                root.muted = value === "1";
            else if (key === "network")
                root.network = value;
            else if (key === "battery")
                root.battery = parseInt(value);
            else if (key === "charging")
                root.charging = value === "1";
        }
    }

    function windowLabel() {
        if (!activeTitle)
            return "Desktop";

        var klass = activeClass.toLowerCase();
        if (klass.indexOf("firefox") >= 0)
            return activeTitle.replace(/ [—–] Mozilla Firefox$/, "").replace(/ Mozilla Firefox$/, "");
        if (klass === "kitty")
            return "Terminal";
        if (klass === "vesktop" || klass === "discord")
            return "Discord";
        return activeTitle;
    }

    function networkIcon() {
        if (network === "ethernet")
            return "󰈀";
        if (network === "wifi")
            return "󰤨";
        return "󰤮";
    }

    function volumeIcon() {
        if (muted)
            return "󰖁";
        if (volume < 35)
            return "󰕿";
        if (volume < 70)
            return "󰖀";
        return "󰕾";
    }

    function batteryIcon() {
        if (battery < 0)
            return "";
        if (charging)
            return "󰂄";
        if (battery < 20)
            return "󰂃";
        if (battery < 50)
            return "󰁾";
        if (battery < 80)
            return "󰂁";
        return "󰁹";
    }

    function updateClock() {
        var date = new Date();
        root.clockText = Qt.formatDateTime(date, "ddd HH:mm");
    }

    Component.onCompleted: {
        updateClock();
        statusProc.running = true;
        refreshWorkspaces();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "workspace")
                root.activeWorkspace = parseInt(event.data) || root.activeWorkspace;
            else if (event.name === "focusedmon") {
                var parts = event.data.split(",");
                root.activeWorkspace = parseInt(parts[1]) || root.activeWorkspace;
            } else if (event.name === "activewindow") {
                var active = event.data.split(",");
                root.activeClass = active[0] ?? "";
                root.activeTitle = active.slice(1).join(",") ?? "";
            } else if (event.name === "closewindow") {
                root.activeClass = "";
                root.activeTitle = "";
            }

            if (event.name === "openwindow" || event.name === "closewindow" || event.name === "movewindowv2")
                root.refreshWorkspaces();
        }
    }

    Timer {
        id: clockTimer
        interval: 30000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.updateClock()
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: {
            if (!statusProc.running)
                statusProc.running = true;
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

    Process {
        id: statusProc
        command: [
            "bash",
            "-lc",
            "vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true); muted=0; case \"$vol\" in *MUTED*) muted=1;; esac; level=$(awk '{ printf \"%d\", ($2+0)*100 }' <<<\"$vol\"); net=$(nmcli -t -f TYPE,STATE device status 2>/dev/null | awk -F: '$2==\"connected\"{print $1; exit}'); bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1); stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1); charging=0; [ \"$stat\" = Charging ] && charging=1; printf 'volume=%s\\nmuted=%s\\nnetwork=%s\\nbattery=%s\\ncharging=%s\\n' \"${level:-0}\" \"$muted\" \"${net:-}\" \"${bat:--1}\" \"$charging\""
        ]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            root.parseKeyValue(stdout.buffer);
            stdout.buffer = "";
        }
    }

    RowLayout {
        id: barRow
        anchors {
            fill: parent
            leftMargin: 1
            rightMargin: 1
        }
        height: Theme.barHeight
        spacing: Theme.gap

        Rectangle {
            Layout.preferredHeight: Theme.pillHeight
            Layout.preferredWidth: launcherText.implicitWidth + Theme.pad * 2
            radius: Theme.radius
            color: launcherMouse.containsMouse ? Theme.panelAlt : Theme.panel
            border.color: Theme.border
            border.width: 1

            Text {
                id: launcherText
                anchors.centerIn: parent
                text: "󱄅"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: 18
            }

            MouseArea {
                id: launcherMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        Quickshell.execDetached(["bash", "-lc", "$HOME/.config/scripts/clipboard-toggle"]);
                    else
                        Quickshell.execDetached(["bash", "-lc", "$HOME/.config/scripts/launcher-toggle"]);
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: Theme.pillHeight
            Layout.preferredWidth: workspaceRow.implicitWidth + Theme.pad * 2
            radius: Theme.radius
            color: Theme.panel
            border.color: Theme.border
            border.width: 1

            RowLayout {
                id: workspaceRow
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    model: 9
                    delegate: Rectangle {
                        required property int index
                        readonly property int workspaceId: index + 1
                        readonly property bool active: root.activeWorkspace === workspaceId
                        readonly property bool occupied: root.occupiedWorkspaces[workspaceId] ?? false

                        Layout.preferredWidth: active ? 25 : 16
                        Layout.preferredHeight: 16
                        radius: Theme.radiusSmall
                        color: active ? Theme.accent : occupied ? Theme.border : Theme.bg

                        Text {
                            anchors.centerIn: parent
                            text: parent.workspaceId
                            color: parent.active ? Theme.bg : Theme.muted
                            font.family: Theme.font
                            font.pixelSize: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "workspace", workspaceId.toString()])
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: Theme.pillHeight
            Layout.maximumWidth: 420
            Layout.preferredWidth: Math.min(titleText.implicitWidth + Theme.pad * 2, 420)
            radius: Theme.radius
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            clip: true

            Text {
                id: titleText
                anchors.centerIn: parent
                width: Math.min(implicitWidth, parent.width - Theme.pad * 2)
                text: root.windowLabel()
                elide: Text.ElideRight
                color: Theme.muted
                font.family: Theme.font
                font.pixelSize: Theme.fontSize
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.preferredHeight: Theme.pillHeight
            spacing: Theme.gap
            visible: SystemTray.items.values.length > 0

            Repeater {
                model: SystemTray.items
                delegate: Image {
                    required property SystemTrayItem modelData
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    source: modelData.icon
                    smooth: true
                    mipmap: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.activate()
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: Theme.pillHeight
            Layout.preferredWidth: statusRow.implicitWidth + Theme.pad * 2
            radius: Theme.radius
            color: Theme.panel
            border.color: Theme.border
            border.width: 1

            RowLayout {
                id: statusRow
                anchors.centerIn: parent
                spacing: 9

                Text {
                    text: root.networkIcon()
                    color: root.network ? Theme.muted : Theme.danger
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize
                }

                Text {
                    text: root.volumeIcon()
                    color: root.muted ? Theme.warning : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize
                }

                Text {
                    visible: root.battery >= 0
                    text: root.batteryIcon()
                    color: root.battery < 20 && !root.charging ? Theme.danger : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize
                }

                Text {
                    text: root.clockText
                    color: Theme.accent
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                }
            }
        }
    }
}
