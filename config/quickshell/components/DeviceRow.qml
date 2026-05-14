import ".."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool connected: false
    property string name: ""
    property int battery: -1

    signal toggled()

    Layout.fillWidth: true
    height: 28
    radius: 8
    color: connected ? Qt.rgba(Mocha.teal.r, Mocha.teal.g, Mocha.teal.b, 0.12) : itemHover.containsMouse ? Qt.rgba(Mocha.surface0.r, Mocha.surface0.g, Mocha.surface0.b, 0.5) : "transparent"
    border.color: connected ? Qt.rgba(Mocha.teal.r, Mocha.teal.g, Mocha.teal.b, 0.35) : "transparent"
    border.width: 1

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
        }

        Text {
            text: root.connected ? "󰂱" : "󰂯"
            color: root.connected ? Mocha.teal : Mocha.overlay0
            font.pixelSize: 12
            font.family: Style.font
            Layout.preferredWidth: 14
        }

        Text {
            text: root.name
            color: Mocha.text
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        Text {
            visible: root.battery >= 0 && root.connected
            text: "󰁹 " + root.battery + "%"
            color: Mocha.overlay0
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
        }
    }

    MouseArea {
        id: itemHover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.toggled()
    }
}
