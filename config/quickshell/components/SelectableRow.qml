import ".."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool selected: false
    property string icon: ""
    property string label: ""
    property color accent: Mocha.blue

    signal activated()

    Layout.fillWidth: true
    height: 28
    radius: 8
    color: selected ? Qt.rgba(accent.r, accent.g, accent.b, 0.2) : itemHover.containsMouse ? Qt.rgba(Mocha.surface0.r, Mocha.surface0.g, Mocha.surface0.b, 0.5) : "transparent"
    border.color: selected ? accent : "transparent"
    border.width: 1

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
        }

        Text {
            text: root.icon
            color: root.accent
            font.pixelSize: 12
            font.family: Style.font
            Layout.preferredWidth: 14
        }

        Text {
            text: root.label
            color: Mocha.text
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: itemHover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.activated()
    }
}
