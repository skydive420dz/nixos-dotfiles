import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Networking

Item {
    id: root

    implicitWidth: 28
    implicitHeight: Style.pillHeight

    readonly property var device: {
        if (!Networking.devices)
            return null;
        const all = Networking.devices.values;
        for (let i = 0; i < all.length; i++) {
            if (all[i].connected)
                return all[i];
        }
        return null;
    }

    readonly property var activeNetwork: {
        if (!device || device.type !== DeviceType.Wifi)
            return null;
        if (!device.networks)
            return null;
        const nets = device.networks.values;
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected)
                return nets[i];
        }
        return null;
    }

    readonly property string connType: {
        if (!device)
            return "";
        if (device.type === DeviceType.Wifi)
            return "wifi";
        if (device.type === DeviceType.Wired)
            return "ethernet";
        return "";
    }

    readonly property string iface: device?.name ?? ""
    readonly property string ipAddr: device?.address ?? ""
    readonly property string ssid: activeNetwork?.name ?? ""

    readonly property int signal: {
        if (!device)
            return 0;
        if (device.type === DeviceType.Wired)
            return 100;
        if (!activeNetwork)
            return 0;
        return Math.round(activeNetwork.signalStrength * 100);
    }

    readonly property string icon: {
        if (!device)
            return "󰤭";          // no connection
        if (connType === "ethernet")
            return "󰈁";
        if (signal >= 75)
            return "󰤨";     // full bars
        if (signal >= 50)
            return "󰤥";     // three bars
        if (signal >= 25)
            return "󰤢";     // two bars
        if (signal > 0)
            return "󰤟";     // one bar
        return "󰤯";                        // wifi but no signal
    }

    readonly property color iconColor: {
        if (!device)
            return Mocha.overlay0;
        return Mocha.blue;
    }

    Text {
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.iconColor
    }

    Process {
        id: nmtuiLauncher
        command: ["uwsm-at-cursor", "kitty", "--class=nmtui", "-e", "nmtui"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: nmtuiLauncher.running = true
    }
}
