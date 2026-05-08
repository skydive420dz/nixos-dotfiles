import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    implicitWidth: col.implicitWidth + 8
    implicitHeight: Style.pillHeight

    property bool hovered: hover.containsMouse
    property bool popupHovered: false

    ColumnLayout {
        id: col
        anchors.centerIn: parent
        spacing: 1

        Text {
            id: timeText
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.fontSize
            font.family: Style.font
            font.bold: true
            color: Mocha.blue
        }
        Text {
            id: dateText
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
            color: Mocha.subtext0
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onExited: root.popupHovered = false
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            timeText.text = "󱑂 " + Qt.formatTime(now, "hh:mm");
            dateText.text = Qt.formatDate(now, "ddd, MMM d");
        }
    }
}
