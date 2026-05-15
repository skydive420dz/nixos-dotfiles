import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell.Services.UPower

Item {
    id: root
    implicitWidth: 28
    implicitHeight: Style.pillHeight

    readonly property var adapter: Bluetooth.defaultAdapter

    readonly property var activeDevice: {
        if (!Bluetooth.devices)
            return null;
        return Bluetooth.devices.values.find(d => d.connected) ?? null;
    }

    readonly property string powerState: (adapter?.enabled ?? false) ? "on" : "off"

    readonly property string icon: {
        if (!adapter?.enabled)
            return "󰂲";
        if (activeDevice)
            return "󰂱";
        return "󰂯";
    }

    readonly property string deviceName: activeDevice?.name ?? ""
    readonly property string deviceAddr: activeDevice?.address ?? ""
    readonly property int deviceBatt: -1

    readonly property var pairedDevices: {
        if (!Bluetooth.devices)
            return [];
        return Bluetooth.devices.values.filter(d => d.paired).map(d => ({
                    name: d.name || d.deviceName || d.address,
                    addr: d.address,
                    device: d,
                    battery: findBatteryForAddress(d.address, d.icon)
                }));
    }

    function findBatteryForAddress(addr, btIcon) {
        if (!addr || !UPower.devices)
            return -1;
        const wantedTypes = upowerTypesForBluetoothIcon(btIcon);
        if (wantedTypes.length === 0)
            return -1;
        const all = UPower.devices.values;
        for (let i = 0; i < all.length; i++) {
            const d = all[i];
            if (wantedTypes.indexOf(d.type) >= 0 && d.percentage > 0) {
                return Math.round(d.percentage * 100);
            }
        }
        return -1;
    }

    function upowerTypesForBluetoothIcon(icon) {
        if (!icon)
            return [];
        if (icon === "audio-card" || icon === "audio-speakers")
            return [UPowerDeviceType.Speakers];
        if (icon === "audio-headphones")
            return [UPowerDeviceType.Headphones, UPowerDeviceType.Headset];
        if (icon === "audio-headset")
            return [UPowerDeviceType.Headset, UPowerDeviceType.Headphones];
        if (icon === "input-mouse")
            return [UPowerDeviceType.Mouse];
        if (icon === "input-keyboard")
            return [UPowerDeviceType.Keyboard];
        if (icon === "input-gaming")
            return [UPowerDeviceType.GamingInput];
        if (icon === "phone")
            return [UPowerDeviceType.Phone];
        return [UPowerDeviceType.Headset, UPowerDeviceType.Headphones, UPowerDeviceType.Speakers, UPowerDeviceType.Mouse, UPowerDeviceType.Keyboard, UPowerDeviceType.BluetoothGeneric];
    }

    Text {
        id: btIcon
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.adapter?.enabled ? Mocha.blue : Mocha.overlay0
    }

    Process {
        id: bluetuiLauncher
        command: ["uwsm-at-cursor", "kitty", "--class=bluetui", "-e", "bluetui"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: bluetuiLauncher.running = true
        onPressAndHold: {
            if (root.adapter)
                root.adapter.enabled = !root.adapter.enabled;
        }
    }
}
