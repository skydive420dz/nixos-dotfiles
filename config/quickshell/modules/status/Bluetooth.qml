import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Text {
    id: root

    Layout.preferredWidth: 10
    color: connected ? Theme.accent : Theme.muted
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: icon()

    property bool available: false
    property bool connected: false

    function icon() {
        if (!available)
            return "󰂲";
        if (connected)
            return "󰂱";
        return "󰂯";
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class bluetui -e bluetui"])
    }
}
