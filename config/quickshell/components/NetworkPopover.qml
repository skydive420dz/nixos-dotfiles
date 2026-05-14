import ".."
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string hoveredModule: ""
    property var netModule

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    spacing: 8
    opacity: hoveredModule === "network" ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    RowLayout {
        Text {
            text: root.netModule.connType === "wifi" ? "󰤨" : root.netModule.connType === "ethernet" ? "󰈀" : "󰤯"
            font.pixelSize: 20
            font.family: Style.font
            color: Mocha.teal
        }

        Text {
            text: root.netModule.connType === "wifi" ? root.netModule.ssid : root.netModule.connType === "ethernet" ? "Ethernet" : "Disconnected"
            font.pixelSize: Style.fontSize
            font.family: Style.font
            font.bold: true
            color: Mocha.text
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Mocha.pillBorder
    }

    Repeater {
        model: {
            var rows = [];
            if (root.netModule.ipAddr)
                rows.push({
                    label: "IP",
                    value: root.netModule.ipAddr
                });
            if (root.netModule.iface)
                rows.push({
                    label: "Interface",
                    value: root.netModule.iface
                });
            if (root.netModule.connType === "wifi")
                rows.push({
                    label: "Signal",
                    value: root.netModule.signal + "%"
                });
            return rows;
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: modelData.label
                color: Mocha.subtext0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
                Layout.preferredWidth: 70
            }

            Text {
                text: modelData.value
                color: Mocha.text
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
                Layout.fillWidth: true
            }
        }
    }
}
