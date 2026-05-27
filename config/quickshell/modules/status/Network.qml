import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    Layout.preferredWidth: 61
    Layout.preferredHeight: Theme.pillHeight

    property string kind: ""
    property string downRate: ""
    property string upRate: ""
    property var downSamples: []
    property var upSamples: []

    function icon() {
        if (kind === "ethernet")
            return "󰈀";
        if (kind === "wifi")
            return "󰤨";
        return "󰤮";
    }

    RowLayout {
        anchors.fill: parent
        spacing: 9

        Text {
            Layout.preferredWidth: Theme.iconSize
            Layout.alignment: Qt.AlignVCenter
            color: root.kind ? Theme.muted : Theme.danger
            font.family: Theme.font
            font.pixelSize: Theme.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.icon()
        }

        NetworkGraph {
            downSamples: root.downSamples
            upSamples: root.upSamples
            opacity: root.kind ? 1 : 0.24
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty --class nmtui -e nmtui"])
    }
}
