import ".."
import QtQuick
import QtQuick.Layouts

PopoverPanel {
    id: root

    property var btModule
    moduleName: "bluetooth"
    spacing: 8

    RowLayout {
        Text {
            text: root.btModule.icon
            font.pixelSize: 20
            font.family: Style.font
            color: root.btModule.powerState !== "on" ? Mocha.overlay0 : Mocha.accent
        }

        Text {
            text: root.btModule.powerState !== "on" ? "Bluetooth Off" : root.btModule.deviceName ? root.btModule.deviceName : "No device connected"
            font.pixelSize: Style.fontSize
            font.family: Style.font
            font.bold: true
            color: Mocha.text
        }
    }

    InfoRow {
        visible: root.btModule.deviceBatt >= 0
        label: "🔋 Battery"
        value: root.btModule.deviceBatt + "%"
        valueFills: false
    }

    Divider {
        visible: root.btModule.pairedDevices.length > 0
    }

    SectionLabel {
        visible: root.btModule.pairedDevices.length > 0
        label: "Paired devices"
    }

    Repeater {
        model: root.btModule.pairedDevices

        DeviceRow {
            connected: modelData.device.connected
            name: modelData.name
            battery: modelData.battery
            onToggled: {
                if (modelData.device)
                    modelData.device.connected = !modelData.device.connected;
            }
        }
    }

    Divider {}
}
