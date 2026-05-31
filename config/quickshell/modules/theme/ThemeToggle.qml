import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    Layout.preferredHeight: Theme.pillHeight
    Layout.preferredWidth: Theme.mediaIconSize + Theme.gap * 2
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: themeMouse.containsMouse ? Theme.panelAlt : "transparent"
    border.color: "transparent"
    border.width: 0

    readonly property bool light: Theme.styleName === "SkyLight"

    Text {
        anchors.centerIn: parent
        text: root.light ? "󰖨" : "󰖔"
        color: Theme.accent
        font.family: Theme.iconFont
        font.pixelSize: Theme.mediaIconSize
    }

    MouseArea {
        id: themeMouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            Quickshell.execDetached(["bash", "-lc", "$HOME/.config/scripts/theme-select toggle"]);
        }
    }
}
