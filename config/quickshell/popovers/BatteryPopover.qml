import ".."
import QtQuick
import QtQuick.Layouts

PopoverPanel {
    id: root

    property var battModule
    moduleName: "battery"
    spacing: 8

    RowLayout {
        Text {
            text: root.battModule.icon
            font.pixelSize: 22
            font.family: Style.font
            color: root.battModule.iconColor
        }
        ColumnLayout {
            spacing: 1
            Text {
                text: root.battModule.capacity + "%  " + root.battModule.statusLabel
                font.pixelSize: Style.fontSize
                font.family: Style.font
                font.bold: true
                color: Mocha.text
            }
            Text {
                visible: root.battModule.timeRemaining !== ""
                text: root.battModule.charging ? "Full in " + root.battModule.timeRemaining : root.battModule.timeRemaining + " remaining"
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
                color: Mocha.subtext0
            }
        }
    }

    Item {
        Layout.fillWidth: true
        height: 10
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 6
            radius: 3
            color: Mocha.surface1
            Rectangle {
                width: parent.width * (root.battModule.capacity / 100)
                height: parent.height
                radius: parent.radius
                color: root.battModule.iconColor
                Behavior on width {
                    NumberAnimation {
                        duration: 500
                    }
                }
            }
        }
    }

    Divider {}

    Repeater {
        model: [
            {
                label: "🔋 Health",
                value: root.battModule.health + "%"
            },
        ]
        InfoRow {
            label: modelData.label
            value: modelData.value
            labelWidth: 80
            valueFills: false
        }
    }
}
