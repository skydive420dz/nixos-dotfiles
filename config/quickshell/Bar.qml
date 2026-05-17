import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris
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
    property string networkDevice: ""
    property double networkRxBytes: 0
    property double networkTxBytes: 0
    property double networkLastRxBytes: 0
    property double networkLastTxBytes: 0
    property double networkLastSampleMs: 0
    property string networkDownRate: ""
    property string networkUpRate: ""
    property bool bluetoothAvailable: false
    property bool bluetoothConnected: false
    property int battery: -1
    property bool charging: false
    property MprisPlayer mediaPlayer: {
        var players = Mpris.players.values;
        for (var i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing)
                return players[i];
        }
        for (var j = 0; j < players.length; j++) {
            if (players[j].playbackState === MprisPlaybackState.Paused)
                return players[j];
        }
        return null;
    }
    readonly property bool mediaActive: mediaPlayer !== null
    readonly property bool mediaPlaying: mediaPlayer?.playbackState === MprisPlaybackState.Playing

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
            else if (key === "network_device")
                root.networkDevice = value;
            else if (key === "rx_bytes")
                root.updateNetworkRate("rx", Number(value));
            else if (key === "tx_bytes")
                root.updateNetworkRate("tx", Number(value));
            else if (key === "bluetooth")
                root.bluetoothAvailable = value === "1";
            else if (key === "bluetooth_connected")
                root.bluetoothConnected = value === "1";
            else if (key === "battery")
                root.battery = parseInt(value);
            else if (key === "charging")
                root.charging = value === "1";
        }
    }

    function formatRate(bytesPerSecond) {
        if (!Number.isFinite(bytesPerSecond) || bytesPerSecond < 1)
            return "0";
        if (bytesPerSecond < 1024)
            return Math.round(bytesPerSecond) + "B";
        if (bytesPerSecond < 1024 * 1024)
            return Math.round(bytesPerSecond / 1024) + "K";
        return (bytesPerSecond / 1024 / 1024).toFixed(1) + "M";
    }

    function updateNetworkRate(kind, value) {
        var now = Date.now();
        if (!Number.isFinite(value))
            value = 0;

        if (kind === "rx") {
            if (networkLastSampleMs > 0 && networkLastRxBytes > 0) {
                var rxElapsed = Math.max((now - networkLastSampleMs) / 1000, 1);
                networkDownRate = formatRate(Math.max(0, value - networkLastRxBytes) / rxElapsed);
            }
            networkRxBytes = value;
            networkLastRxBytes = value;
        } else {
            if (networkLastSampleMs > 0 && networkLastTxBytes > 0) {
                var txElapsed = Math.max((now - networkLastSampleMs) / 1000, 1);
                networkUpRate = formatRate(Math.max(0, value - networkLastTxBytes) / txElapsed);
            }
            networkTxBytes = value;
            networkLastTxBytes = value;
            networkLastSampleMs = now;
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

    function networkIcon() {
        if (network === "ethernet")
            return "󰈀";
        if (network === "wifi")
            return "󰤨";
        return "󰤮";
    }

    function networkLabel() {
        if (!network)
            return "";
        return "↓" + (networkDownRate || "0") + " ↑" + (networkUpRate || "0");
    }

    function bluetoothIcon() {
        if (!bluetoothAvailable)
            return "󰂲";
        if (bluetoothConnected)
            return "󰂱";
        return "󰂯";
    }

    function bluetoothLabel() {
        if (!bluetoothAvailable)
            return "Off";
        if (bluetoothConnected)
            return "On";
        return "Idle";
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

    function volumeLabel() {
        return muted ? "Mute" : volume + "%";
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

    function batteryLabel() {
        if (battery < 0)
            return "";
        return battery + "%";
    }

    function mediaLabel() {
        if (!mediaPlayer)
            return "";
        var title = mediaPlayer.trackTitle || mediaPlayer.identity || "Media";
        var artist = mediaPlayer.trackArtist || "";
        return artist ? title + " - " + artist : title;
    }

    function updateClock() {
        var date = new Date();
        root.clockText = Qt.formatDateTime(date, "ddd MMM d  HH:mm");
    }

    Component.onCompleted: {
        updateClock();
        statusProc.running = true;
        activeWindowProc.running = true;
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
        interval: 2000
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
            "vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true); muted=0; case \"$vol\" in *MUTED*) muted=1;; esac; level=$(awk '{ printf \"%d\", ($2+0)*100 }' <<<\"$vol\"); netrow=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$3==\"connected\"{print $1\":\"$2; exit}'); netdev=${netrow%%:*}; net=${netrow#*:}; rx=0; tx=0; if [ -n \"$netdev\" ] && [ -r \"/sys/class/net/$netdev/statistics/rx_bytes\" ]; then rx=$(cat \"/sys/class/net/$netdev/statistics/rx_bytes\"); tx=$(cat \"/sys/class/net/$netdev/statistics/tx_bytes\"); fi; bt=0; btconn=0; if command -v bluetoothctl >/dev/null 2>&1 && bluetoothctl show >/dev/null 2>&1; then bt=1; bluetoothctl devices Connected 2>/dev/null | grep -q . && btconn=1; fi; bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1); stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1); charging=0; [ \"$stat\" = Charging ] && charging=1; printf 'volume=%s\\nmuted=%s\\nnetwork=%s\\nnetwork_device=%s\\nrx_bytes=%s\\ntx_bytes=%s\\nbluetooth=%s\\nbluetooth_connected=%s\\nbattery=%s\\ncharging=%s\\n' \"${level:-0}\" \"$muted\" \"${net:-}\" \"${netdev:-}\" \"$rx\" \"$tx\" \"$bt\" \"$btconn\" \"${bat:--1}\" \"$charging\""
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

    Process {
        id: activeWindowProc
        command: ["hyprctl", "activewindow", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            root.loadActiveWindow(stdout.buffer);
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
            Layout.maximumWidth: 360
            Layout.preferredWidth: Math.min(titleText.implicitWidth + Theme.pad * 2, 360)
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

        Rectangle {
            visible: root.mediaActive
            Layout.preferredHeight: Theme.pillHeight
            Layout.preferredWidth: Math.min(mediaRow.implicitWidth + Theme.pad * 2, 360)
            radius: Theme.radius
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            clip: true

            RowLayout {
                id: mediaRow
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: "󰒮"
                    color: root.mediaPlayer?.canGoPrevious ? Theme.muted : Theme.border
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.mediaPlayer?.previous()
                    }
                }

                Text {
                    text: root.mediaPlaying ? "󰏤" : "󰐊"
                    color: Theme.accent
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.mediaPlayer?.togglePlaying()
                    }
                }

                Text {
                    text: "󰒭"
                    color: root.mediaPlayer?.canGoNext ? Theme.muted : Theme.border
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.mediaPlayer?.next()
                    }
                }

                Text {
                    Layout.maximumWidth: 230
                    text: root.mediaLabel()
                    color: Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                    elide: Text.ElideRight
                }
            }
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
                    text: root.networkIcon() + (root.networkLabel() ? " " + root.networkLabel() : "")
                    color: root.network ? Theme.muted : Theme.danger
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class nmtui -e nmtui"])
                    }
                }

                Text {
                    text: root.bluetoothIcon()
                    color: root.bluetoothConnected ? Theme.accent : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class bluetui -e bluetui"])
                    }
                }

                Text {
                    text: root.volumeIcon() + " " + root.volumeLabel()
                    color: root.muted ? Theme.warning : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class wiremix -e wiremix"])
                    }
                }

                Text {
                    visible: root.battery >= 0
                    text: root.batteryIcon() + " " + root.batteryLabel()
                    color: root.battery < 20 && !root.charging ? Theme.danger : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
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
