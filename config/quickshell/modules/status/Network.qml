import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    Layout.preferredWidth: StatusMetrics.networkSlotWidth
    Layout.preferredHeight: Theme.pillHeight

    property string kind: ""
    property int signal: -1
    property string downRate: ""
    property string upRate: ""
    property var downSamples: []
    property var upSamples: []

    function icon() {
        if (kind === "ethernet")
            return "󰈀";
        if (kind === "wifi") {
            if (signal >= 80)
                return "󰤨";
            if (signal >= 60)
                return "󰤥";
            if (signal >= 40)
                return "󰤢";
            if (signal >= 20)
                return "󰤟";
            return "󰤯";
        }
        return "󰱟";
    }

    function launcherCommand() {
        if (kind === "wifi")
            return "if command -v wlctl >/dev/null 2>&1; then uwsm app -- ghostty --gtk-single-instance=false --class=wlctl --title=wlctl -e wlctl; else uwsm app -- ghostty --gtk-single-instance=false --class=nmtui --title=nmtui -e nmtui; fi";
        return "uwsm app -- ghostty --gtk-single-instance=false --class=nmtui --title=nmtui -e nmtui";
    }

    RowLayout {
        anchors.fill: parent
        spacing: StatusMetrics.networkIconGraphGap

        Text {
            Layout.preferredWidth: StatusMetrics.networkIconWidth
            Layout.alignment: Qt.AlignVCenter
            color: root.kind ? Theme.muted : Theme.danger
            font.family: Theme.iconFont
            font.pixelSize: Theme.mediaIconSize
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
        onClicked: Quickshell.execDetached(["bash", "-lc", root.launcherCommand()])
    }
}
