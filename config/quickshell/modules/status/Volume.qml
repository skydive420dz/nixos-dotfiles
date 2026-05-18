import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Text {
    id: root

    Layout.preferredWidth: 16
    color: muted ? Theme.warning : Theme.muted
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: icon()

    property int level: 0
    property bool muted: false

    function icon() {
        if (muted)
            return "󰖁";
        if (level < 35)
            return "󰕿";
        if (level < 70)
            return "󰖀";
        return "󰕾";
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class wiremix -e wiremix"])
    }
}
