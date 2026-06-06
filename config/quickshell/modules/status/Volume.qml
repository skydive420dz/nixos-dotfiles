import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Text {
    id: root

    Layout.preferredWidth: 16
    color: muted ? Theme.warning : Theme.muted
    font.family: Theme.iconFont
    font.pixelSize: Theme.statusIconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: icon()

    property int level: 0
    property bool muted: false

    function icon() {
        if (muted)
            return "󰖁";
        if (level <= 0)
            return "󰖁";
        if (level < 20)
            return "󰕿";
        if (level < 50)
            return "󰖀";
        return "󰕾";
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- ghostty --gtk-single-instance=false --class=wiremix --title=wiremix -e wiremix"])
    }
}
