import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import "modules/media"
import "modules/window"
import "modules/workspaces"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Theme.barHeight - 1
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
    property string batteryStatus: ""
    property bool batteryStatusReady: false
    property var mediaController: null

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
            else if (key === "battery_status")
                root.updateBatteryStatus(value);
        }
    }

    function formatRate(bytesPerSecond) {
        if (!Number.isFinite(bytesPerSecond) || bytesPerSecond < 1024)
            return "0";
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

    function updateBatteryStatus(value) {
        var nextStatus = value || "";
        if (nextStatus === batteryStatus)
            return;

        var previousStatus = batteryStatus;
        batteryStatus = nextStatus;

        if (!batteryStatusReady) {
            batteryStatusReady = true;
            return;
        }

        if (!previousStatus || !nextStatus)
            return;

        if (nextStatus === "Discharging")
            showOsd("󰁹", "On battery", battery);
        else if (previousStatus === "Discharging" && nextStatus === "Charging")
            showOsd("󱐋", "Charging", battery);
        else if (previousStatus === "Discharging")
            showOsd("󱐥", nextStatus === "Full" ? "Charged" : "Plugged in", battery);
        else if (nextStatus === "Full")
            showOsd("󱐥", "Charged", battery);
    }

    function showOsd(icon, title, value) {
        var runtimeDir = Quickshell.env("XDG_RUNTIME_DIR") || "/run/user/" + Quickshell.env("UID");
        var payload = JSON.stringify({ icon: icon, title: title, value: value });
        Quickshell.execDetached([
            "bash",
            "-lc",
            "printf '%s\\n' " + JSON.stringify(payload) + " > " + JSON.stringify(runtimeDir + "/qs-osd.json") + " && printf '%s\\n' \"$(date +%s%N)\" > " + JSON.stringify(runtimeDir + "/qs-osd-signal")
        ]);
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
        if (batteryStatus === "Charging")
            return "󱐋";
        if (batteryStatus === "Full" || batteryStatus === "Not charging")
            return "󱐥";
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

    function updateClock() {
        var date = new Date();
        root.clockText = Qt.formatDateTime(date, "ddd MMM d  HH:mm");
    }

    Component.onCompleted: {
        updateClock();
        statusProc.running = true;
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

    Process {
        id: statusProc
        command: [
            "bash",
            "-lc",
            "vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true); muted=0; case \"$vol\" in *MUTED*) muted=1;; esac; level=$(awk '{ printf \"%d\", ($2+0)*100 }' <<<\"$vol\"); netrow=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$3==\"connected\"{print $1\":\"$2; exit}'); netdev=${netrow%%:*}; net=${netrow#*:}; rx=0; tx=0; if [ -n \"$netdev\" ] && [ -r \"/sys/class/net/$netdev/statistics/rx_bytes\" ]; then rx=$(cat \"/sys/class/net/$netdev/statistics/rx_bytes\"); tx=$(cat \"/sys/class/net/$netdev/statistics/tx_bytes\"); fi; bt=0; btconn=0; if command -v bluetoothctl >/dev/null 2>&1 && bluetoothctl show >/dev/null 2>&1; then bt=1; bluetoothctl devices Connected 2>/dev/null | grep -q . && btconn=1; fi; bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1); stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1); charging=0; [ \"$stat\" = Charging ] && charging=1; printf 'volume=%s\\nmuted=%s\\nnetwork=%s\\nnetwork_device=%s\\nrx_bytes=%s\\ntx_bytes=%s\\nbluetooth=%s\\nbluetooth_connected=%s\\nbattery=%s\\ncharging=%s\\nbattery_status=%s\\n' \"${level:-0}\" \"$muted\" \"${net:-}\" \"${netdev:-}\" \"$rx\" \"$tx\" \"$bt\" \"$btconn\" \"${bat:--1}\" \"$charging\" \"${stat:-}\""
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

        Workspaces {}

        WindowTitle {}

        Item {
            Layout.fillWidth: true
        }

        Media {
            controller: root.mediaController
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
            Layout.preferredWidth: 324
            radius: Theme.radius
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            clip: true

            RowLayout {
                id: statusRow
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 6

                Text {
                    text: root.networkIcon() + (root.networkLabel() ? " " + root.networkLabel() : "")
                    Layout.fillWidth: true
                    Layout.minimumWidth: 64
                    color: root.network ? Theme.muted : Theme.danger
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class nmtui -e nmtui"])
                    }
                }

                Text {
                    text: root.bluetoothIcon()
                    Layout.preferredWidth: 10
                    color: root.bluetoothConnected ? Theme.accent : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class bluetui -e bluetui"])
                    }
                }

                RowLayout {
                    spacing: 3

                    Text {
                        text: root.volumeIcon()
                        Layout.preferredWidth: 16
                        color: root.muted ? Theme.warning : Theme.muted
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class wiremix -e wiremix"])
                        }
                    }

                    Text {
                        visible: root.battery >= 0
                        text: root.batteryIcon() + " " + root.batteryLabel()
                        Layout.preferredWidth: 48
                        color: root.battery < 20 && !root.charging ? Theme.danger : Theme.muted
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSize
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        text: root.clockText
                        Layout.preferredWidth: 124
                        color: Theme.accent
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSize
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
