import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    Layout.preferredWidth: 76
    Layout.preferredHeight: Theme.pillHeight
    Layout.leftMargin: 4

    property string timeText: ""
    property string dateText: ""

    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Text {
            width: parent.width
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            text: root.timeText
        }

        Text {
            width: parent.width
            color: Theme.muted
            font.family: Theme.font
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignHCenter
            text: root.dateText
        }
    }
}
