import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

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
            return "󰂲";  // bluetooth disabled
        if (activeDevice)
            return "󰂱";  // connected
        return "󰂯";                          // enabled, no connection
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
                    device: d
                }));
    }
    Text {
        id: btIcon
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.adapter?.enabled ? Mocha.teal : Mocha.overlay0
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Qt.createQmlObject('import Quickshell.Io; Process { command: ["uwsm", "app", "--", "kitty", "-e, bluetui"]; running: true}', root);
            } else if (mouse.button === Qt.RightButton && root.adapter) {
                root.adapter.enabled = !root.adapter.enabled;
            }
        }
    }
}
