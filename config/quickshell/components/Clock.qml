import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    implicitWidth: col.implicitWidth + 8
    implicitHeight: Style.pillHeight

    function updateClock() {
        const now = new Date();
        const nextMinute = 60000 - (now.getSeconds() * 1000 + now.getMilliseconds());
        const nextTime = "󱑂 " + Qt.formatTime(now, "hh:mm");
        const nextDate = Qt.formatDate(now, "ddd, MMM d");

        if (timeText.text !== nextTime)
            timeText.text = nextTime;
        if (dateText.text !== nextDate)
            dateText.text = nextDate;

        refreshTimer.interval = Math.max(250, nextMinute + 50);
        refreshTimer.restart();
    }

    Component.onCompleted: updateClock()

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
        id: refreshTimer
        repeat: false
        onTriggered: root.updateClock()
    }
}
