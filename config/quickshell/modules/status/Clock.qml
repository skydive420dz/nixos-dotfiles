import "../.."
import QtQuick
import QtQuick.Layouts

Text {
    id: root

    Layout.preferredWidth: 124
    color: Theme.accent
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    text: clockText

    property string clockText: ""

    function updateClock() {
        var date = new Date();
        root.clockText = Qt.formatDateTime(date, "ddd MMM d  HH:mm");
    }

    Component.onCompleted: updateClock()

    Timer {
        interval: 30000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.updateClock()
    }
}
