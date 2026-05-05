import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: col.implicitWidth + 8
    implicitHeight: Style.pillHeight

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

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            // "󱑂" is the Nerd Font clock icon matching your waybar format
            timeText.text = "󱑂 " + Qt.formatTime(now, "hh:mm");
            dateText.text = Qt.formatDate(now, "ddd, MMM d");
        }
    }
}
