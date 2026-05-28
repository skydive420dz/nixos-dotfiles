import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    implicitWidth: StatusMetrics.statusClusterWidth
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: "transparent"
    border.color: "transparent"
    border.width: 0
    clip: true

    property int volume: 0
    property bool muted: false
    property string network: ""
    property string networkDevice: ""
    property int networkSignal: -1
    property double networkRxBytes: 0
    property double networkTxBytes: 0
    property double networkLastRxBytes: 0
    property double networkLastTxBytes: 0
    property double networkLastSampleMs: 0
    property string networkDownRate: ""
    property string networkUpRate: ""
    property var networkDownSamples: []
    property var networkUpSamples: []
    property bool bluetoothAvailable: false
    property bool bluetoothConnected: false
    property int battery: -1
    property bool charging: false
    property string batteryStatus: ""
    property bool batteryStatusReady: false

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
            else if (key === "network_signal") {
                var signalValue = parseInt(value);
                root.networkSignal = Number.isFinite(signalValue) ? signalValue : -1;
            }
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
            return "0000";

        if (bytesPerSecond < 1024 * 1024) {
            var kib = Math.min(Math.round(bytesPerSecond / 1024), 999);
            return ("00" + kib).slice(-3) + "K";
        }

        var mib = bytesPerSecond / 1024 / 1024;
        if (mib < 9.95)
            return mib.toFixed(1) + "M";
        if (mib < 100) {
            var roundedMib = Math.min(Math.round(mib), 99);
            return ("00" + roundedMib).slice(-3) + "M";
        }
        return "99M+";
    }

    function updateNetworkRate(kind, value) {
        var now = Date.now();
        if (!Number.isFinite(value))
            value = 0;

        if (kind === "rx") {
            if (networkLastSampleMs > 0 && networkLastRxBytes > 0) {
                var rxElapsed = Math.max((now - networkLastSampleMs) / 1000, 1);
                var rxRate = Math.max(0, value - networkLastRxBytes) / rxElapsed;
                networkDownRate = formatRate(rxRate);
                networkDownSamples = appendNetworkSample(networkDownSamples, rxRate);
            }
            networkRxBytes = value;
            networkLastRxBytes = value;
        } else {
            if (networkLastSampleMs > 0 && networkLastTxBytes > 0) {
                var txElapsed = Math.max((now - networkLastSampleMs) / 1000, 1);
                var txRate = Math.max(0, value - networkLastTxBytes) / txElapsed;
                networkUpRate = formatRate(txRate);
                networkUpSamples = appendNetworkSample(networkUpSamples, txRate);
            }
            networkTxBytes = value;
            networkLastTxBytes = value;
            networkLastSampleMs = now;
        }
    }

    function appendNetworkSample(samples, value) {
        var nextSamples = samples.slice();
        nextSamples.push(Math.max(0, Number(value) || 0));

        while (nextSamples.length > 32)
            nextSamples.shift();

        return nextSamples;
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

    Component.onCompleted: {
        volumeProc.running = true;
        networkInfoProc.running = true;
        trafficProc.running = true;
        bluetoothProc.running = true;
        batteryProc.running = true;
    }

    Timer {
        id: volumeTimer
        interval: 2000
        repeat: true
        running: true
        onTriggered: {
            if (!volumeProc.running)
                volumeProc.running = true;
        }
    }

    Timer {
        id: trafficTimer
        interval: 2000
        repeat: true
        running: true
        onTriggered: {
            if (!trafficProc.running)
                trafficProc.running = true;
        }
    }

    Timer {
        id: networkInfoTimer
        interval: 15000
        repeat: true
        running: true
        onTriggered: {
            if (!networkInfoProc.running)
                networkInfoProc.running = true;
        }
    }

    Timer {
        id: batteryTimer
        interval: 10000
        repeat: true
        running: true
        onTriggered: {
            if (!batteryProc.running)
                batteryProc.running = true;
        }
    }

    Timer {
        id: bluetoothTimer
        interval: 30000
        repeat: true
        running: true
        onTriggered: {
            if (!bluetoothProc.running)
                bluetoothProc.running = true;
        }
    }

    Process {
        id: volumeProc
        command: [
            "bash",
            "-lc",
            "vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true); muted=0; case \"$vol\" in *MUTED*) muted=1;; esac; level=$(awk '{ printf \"%d\", ($2+0)*100 }' <<<\"$vol\"); printf 'volume=%s\\nmuted=%s\\n' \"${level:-0}\" \"$muted\""
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
        id: networkInfoProc
        command: [
            "bash",
            "-lc",
            "netrow=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$3==\"connected\"{print $1\":\"$2; exit}'); netdev=${netrow%%:*}; net=${netrow#*:}; signal=-1; if [ \"$netdev\" = \"$net\" ]; then netdev=; net=; fi; if [ \"$net\" = wifi ]; then signal=$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | awk -F: '$1==\"*\" || $1==\"yes\"{print $2; exit}'); fi; printf 'network=%s\\nnetwork_device=%s\\nnetwork_signal=%s\\n' \"${net:-}\" \"${netdev:-}\" \"${signal:--1}\""
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
        id: trafficProc
        command: [
            "bash",
            "-lc",
            "dev=" + JSON.stringify(root.networkDevice) + "; rx=0; tx=0; if [ -n \"$dev\" ] && [ -r \"/sys/class/net/$dev/statistics/rx_bytes\" ]; then rx=$(cat \"/sys/class/net/$dev/statistics/rx_bytes\"); tx=$(cat \"/sys/class/net/$dev/statistics/tx_bytes\"); fi; printf 'rx_bytes=%s\\ntx_bytes=%s\\n' \"$rx\" \"$tx\""
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
        id: bluetoothProc
        command: [
            "bash",
            "-lc",
            "bt=0; btconn=0; if command -v bluetoothctl >/dev/null 2>&1 && bluetoothctl show >/dev/null 2>&1; then bt=1; bluetoothctl devices Connected 2>/dev/null | grep -q . && btconn=1; fi; printf 'bluetooth=%s\\nbluetooth_connected=%s\\n' \"$bt\" \"$btconn\""
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
        id: batteryProc
        command: [
            "bash",
            "-lc",
            "bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1); stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1); charging=0; [ \"$stat\" = Charging ] && charging=1; printf 'battery=%s\\ncharging=%s\\nbattery_status=%s\\n' \"${bat:--1}\" \"$charging\" \"${stat:-}\""
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
        id: statusRow
        anchors.fill: parent
        anchors.leftMargin: StatusMetrics.statusClusterLeftMargin
        anchors.rightMargin: StatusMetrics.statusClusterRightMargin
        spacing: StatusMetrics.statusClusterSpacing

        Network {
            kind: root.network
            signal: root.networkSignal
            downRate: root.networkDownRate
            upRate: root.networkUpRate
            downSamples: root.networkDownSamples
            upSamples: root.networkUpSamples
        }

        Bluetooth {
            available: root.bluetoothAvailable
            connected: root.bluetoothConnected
        }

        RowLayout {
            spacing: StatusMetrics.statusRightGroupSpacing

            Volume {
                level: root.volume
                muted: root.muted
            }

            Battery {
                level: root.battery
                charging: root.charging
                status: root.batteryStatus
            }

            Clock {}
        }
    }
}
