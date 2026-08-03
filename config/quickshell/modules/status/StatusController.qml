import QtQuick
import Quickshell
import Quickshell.Bluetooth as BluetoothApi
import Quickshell.Io
import Quickshell.Networking as NetworkApi
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Scope {
    id: root

    readonly property int volume: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100)
    readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false
    readonly property UPowerDevice batteryDevice: UPower.displayDevice
    readonly property bool batteryAvailable: batteryDevice.ready && batteryDevice.isPresent
    readonly property int battery: batteryAvailable ? Math.round(batteryDevice.percentage * 100) : -1
    readonly property bool charging: batteryAvailable && batteryDevice.state === UPowerDeviceState.Charging
    readonly property string nativeBatteryStatus: batteryAvailable ? root.batteryStatusForState(batteryDevice.state, UPower.onBattery) : ""
    readonly property bool bluetoothAvailable: BluetoothApi.Bluetooth.defaultAdapter !== null // qmllint disable unresolved-type
    readonly property bool bluetoothConnected: BluetoothApi.Bluetooth.defaultAdapter?.devices.values.some(device => device.connected) ?? false // qmllint disable unresolved-type
    readonly property NetworkApi.NetworkDevice nativeNetworkDevice: NetworkApi.Networking.devices.values.find(device => device.connected) ?? null
    readonly property NetworkApi.WifiNetwork nativeWifiNetwork: nativeNetworkDevice?.type === NetworkApi.DeviceType.Wifi ? nativeNetworkDevice.networks.values.find(network => network.connected) ?? null : null // qmllint disable unresolved-type
    readonly property string network: nativeNetworkDevice?.type === NetworkApi.DeviceType.Wifi ? "wifi" : nativeNetworkDevice?.type === NetworkApi.DeviceType.Wired ? "ethernet" : "" // qmllint disable unresolved-type
    readonly property string nativeNetworkDeviceName: nativeNetworkDevice?.name ?? ""
    property string networkDevice: ""
    property int networkDeviceRevision: 0
    readonly property int networkSignal: nativeWifiNetwork ? Math.round(nativeWifiNetwork.signalStrength * 100) : -1
    property double networkLastRxBytes: 0
    property double networkLastTxBytes: 0
    property double networkLastSampleMs: 0
    property var networkDownSamples: []
    property var networkUpSamples: []
    property string batteryStatus: ""
    property bool batteryStatusReady: false
    property string timeText: ""
    property string dateText: ""

    onNativeBatteryStatusChanged: root.updateBatteryStatus(nativeBatteryStatus)
    onNativeNetworkDeviceNameChanged: root.setNetworkDevice(nativeNetworkDeviceName)

    function batteryStatusForState(state, onBattery) {
        if (onBattery || state === UPowerDeviceState.Discharging)
            return "Discharging";

        switch (state) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.FullyCharged:
            return "Full";
        case UPowerDeviceState.PendingCharge:
        case UPowerDeviceState.PendingDischarge:
        case UPowerDeviceState.Empty:
            return "Not charging";
        case UPowerDeviceState.Unknown:
            return "Unknown";
        default:
            return "";
        }
    }

    function updateClock() {
        var date = new Date();
        root.timeText = "󱑂 " + Qt.formatTime(date, "HH:mm");
        root.dateText = Qt.formatDate(date, "ddd, MMM d");
        clockTimer.interval = 60000 - date.getSeconds() * 1000 - date.getMilliseconds();
        clockTimer.restart();
    }

    function resetNetworkTraffic() {
        networkLastRxBytes = 0;
        networkLastTxBytes = 0;
        networkLastSampleMs = 0;
        networkDownSamples = [];
        networkUpSamples = [];
    }

    function setNetworkDevice(value) {
        var nextDevice = value || "";
        if (nextDevice === networkDevice)
            return;

        networkDevice = nextDevice;
        networkDeviceRevision++;
        resetNetworkTraffic();
    }

    function applyNetworkTrafficSample(sampledDevice, sampledRevision, rxValue, txValue, sampleMs) {
        if (!sampledDevice || sampledDevice !== networkDevice || sampledRevision !== networkDeviceRevision)
            return;

        var rxBytes = Number(rxValue);
        var txBytes = Number(txValue);
        if (!Number.isFinite(rxBytes))
            rxBytes = 0;
        if (!Number.isFinite(txBytes))
            txBytes = 0;

        var now = Number(sampleMs);
        if (!Number.isFinite(now) || now <= 0)
            now = Date.now();

        if (networkLastSampleMs > 0) {
            var elapsed = Math.max((now - networkLastSampleMs) / 1000, 1);
            var rxRate = Math.max(0, rxBytes - networkLastRxBytes) / elapsed;
            var txRate = Math.max(0, txBytes - networkLastTxBytes) / elapsed;
            networkDownSamples = appendNetworkSample(networkDownSamples, rxRate);
            networkUpSamples = appendNetworkSample(networkUpSamples, txRate);
        }

        networkLastRxBytes = rxBytes;
        networkLastTxBytes = txBytes;
        networkLastSampleMs = now;
    }

    function parseNetworkTraffic(text, sampledDevice, sampledRevision) {
        var reportedDevice = "";
        var rxBytes = 0;
        var txBytes = 0;
        var rows = (text || "").trim().split("\n");

        for (var i = 0; i < rows.length; i++) {
            var parts = rows[i].split("=");
            var key = parts[0] ?? "";
            var value = parts.slice(1).join("=");

            if (key === "traffic_device")
                reportedDevice = value;
            else if (key === "rx_bytes")
                rxBytes = Number(value);
            else if (key === "tx_bytes")
                txBytes = Number(value);
        }

        if (reportedDevice !== sampledDevice)
            return;

        applyNetworkTrafficSample(sampledDevice, sampledRevision, rxBytes, txBytes, Date.now());
    }

    function startTrafficSample() {
        if (trafficProc.running || !networkDevice)
            return;

        trafficProc.sampledDevice = networkDevice;
        trafficProc.sampledRevision = networkDeviceRevision;
        trafficProc.command = ["bash", "-lc", "dev=$1; rx=0; tx=0; if [ -r \"/sys/class/net/$dev/statistics/rx_bytes\" ]; then rx=$(cat \"/sys/class/net/$dev/statistics/rx_bytes\"); tx=$(cat \"/sys/class/net/$dev/statistics/tx_bytes\"); fi; printf 'traffic_device=%s\\nrx_bytes=%s\\ntx_bytes=%s\\n' \"$dev\" \"$rx\" \"$tx\"", "quickshell-network-traffic", trafficProc.sampledDevice];
        trafficProc.running = true;
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
        Quickshell.execDetached(["qs", "ipc", "call", "osd", "show", icon, title, value.toString()]);
    }

    Component.onCompleted: {
        root.updateClock();
        root.setNetworkDevice(root.nativeNetworkDeviceName);
        root.startTrafficSample();
        root.updateBatteryStatus(root.nativeBatteryStatus);
    }

    Timer {
        id: clockTimer
        onTriggered: root.updateClock()
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: root.startTrafficSample()
    }

    Process {
        id: trafficProc
        property string sampledDevice: ""
        property int sampledRevision: -1
        command: []
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            var output = stdout.buffer;
            var device = sampledDevice;
            var revision = sampledRevision;
            stdout.buffer = "";
            sampledDevice = "";
            sampledRevision = -1;
            root.parseNetworkTraffic(output, device, revision);
        }
    }
}
