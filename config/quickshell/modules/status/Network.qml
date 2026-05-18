import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Text {
    id: root

    Layout.fillWidth: true
    Layout.minimumWidth: 80
    color: kind ? Theme.muted : Theme.danger
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
    text: icon() + (label() ? " " + label() : "")

    property string kind: ""
    property string downRate: ""
    property string upRate: ""

    function icon() {
        if (kind === "ethernet")
            return "󰈀";
        if (kind === "wifi")
            return "󰤨";
        return "󰤮";
    }

    function label() {
        if (!kind)
            return "";
        return "↓" + (downRate || "0") + " ↑" + (upRate || "0");
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class nmtui -e nmtui"])
    }
}
