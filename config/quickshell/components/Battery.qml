import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Item {
    id: root
    implicitWidth: 60
    implicitHeight: Style.pillHeight

    readonly property var device: {
        if (!UPower.devices)
            return null;
        const all = UPower.devices.values;
        for (let i = 0; i < all.length; i++) {
            if (all[i].type === UPowerDeviceType.Battery)
                return all[i];
        }
        return null;
    }
    readonly property bool plugged: !UPower.onBattery

    readonly property int capacity: Math.round((device?.percentage ?? 0) * 100)

    readonly property bool charging: {
        if (!device)
            return false;
        const s = device.state;
        return s === UPowerDeviceState.Charging;
    }

    readonly property string statusLabel: {
        if (!device)
            return "";
        if (root.plugged && !root.charging)
            return "Plugged in";
        switch (device.state) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.Empty:
            return "Empty";
        case UPowerDeviceState.FullyCharged:
            return "Full";
        case UPowerDeviceState.PendingCharge:
            return "Plugged in";
        case UPowerDeviceState.PendingDischarge:
            return "Plugged in";
        default:
            if (root.plugged)
                return "Plugged in";
            return "";
        }
    }

    readonly property string timeRemaining: {
        if (!device)
            return "";
        const seconds = root.charging ? device.timeToFull : device.timeToEmpty;
        if (seconds <= 0)
            return "";
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        if (hours > 0)
            return hours + "h " + minutes + "m";
        return minutes + "m";
    }

    readonly property int health: {
        if (!device || !device.energyCapacity || device.energyCapacity === 0)
            return 100;
        return Math.round((device.energy / device.energyCapacity) * 100);
    }

    readonly property string icon: {
        const cap = root.capacity;
        const isCharging = root.charging;
        if (isCharging) {
            if (cap >= 90)
                return "󰂅";
            if (cap >= 70)
                return "󰂋";
            if (cap >= 50)
                return "󰂉";
            if (cap >= 30)
                return "󰂇";
            return "󰢜";
        }
        if (cap >= 90)
            return "󰁹";
        if (cap >= 70)
            return "󰂀";
        if (cap >= 50)
            return "󰁾";
        if (cap >= 30)
            return "󰁼";
        if (cap >= 10)
            return "󰁺";
        return "󰂃";
    }

    readonly property color iconColor: {
        const cap = root.capacity;
        if (root.plugged || root.charging)
            return Mocha.green;
        if (cap <= 15)
            return Mocha.red;
        if (cap <= 30)
            return Mocha.yellow;
        return Mocha.teal;
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: root.icon
            font.pixelSize: Style.fontSize
            font.family: Style.font
            color: root.iconColor
        }
        Text {
            text: root.capacity + "%"
            font.pixelSize: Style.fontSize
            font.family: Style.font
            color: Mocha.text
        }
    }
}
