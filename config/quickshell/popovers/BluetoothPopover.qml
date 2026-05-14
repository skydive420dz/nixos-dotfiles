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
            color: root.btModule.powerState !== "on" ? Mocha.overlay0 : Mocha.teal
        }

        Text {
            text: root.btModule.powerState !== "on" ? "Bluetooth Off" : root.btModule.deviceName ? root.btModule.deviceName : "No device connected"
            font.pixelSize: Style.fontSize
            font.family: Style.font
            font.bold: true
            color: Mocha.text
        }
    }

    RowLayout {
        visible: root.btModule.deviceBatt >= 0

        Text {
            text: "🔋 Battery"
            color: Mocha.subtext0
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
            Layout.preferredWidth: 70
        }

        Text {
            text: root.btModule.deviceBatt + "%"
            color: Mocha.text
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
        }
    }

    Divider {
        visible: root.btModule.pairedDevices.length > 0
    }

    Text {
        visible: root.btModule.pairedDevices.length > 0
        text: "Paired devices"
        color: Mocha.subtext0
        font.pixelSize: Style.fontSizeS
        font.family: Style.font
    }

    Repeater {
        model: root.btModule.pairedDevices

        Rectangle {
            Layout.fillWidth: true
            height: 28
            radius: 8
            color: "transparent"
            border.color: "transparent"
            border.width: 0

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                }

                Text {
                    text: modelData.device.connected ? "󰂱 " : "󰂯 "
                    color: Mocha.teal
                    font.pixelSize: 12
                    font.family: Style.font
                }

                Text {
                    text: modelData.name
                    color: Mocha.text
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    visible: modelData.battery >= 0 && modelData.device.connected
                    text: "󰁹 " + modelData.battery + "%"
                    color: Mocha.overlay0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (modelData.device)
                        modelData.device.connected = !modelData.device.connected;
                }
            }
        }
    }

    Divider {}
}
