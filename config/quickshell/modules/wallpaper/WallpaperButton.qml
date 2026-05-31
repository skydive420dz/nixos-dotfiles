pragma ComponentBehavior: Bound

import "../.."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    Layout.preferredHeight: Theme.pillHeight
    Layout.preferredWidth: Theme.pillHeight
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: wallpaperMouse.containsMouse || WallpaperStore.selectorOpen ? Theme.panelAlt : "transparent"
    border.color: "transparent"
    border.width: 0

    Text {
        anchors.centerIn: parent
        text: "󰸉"
        color: Theme.accent
        font.family: Theme.iconFont
        font.pixelSize: Theme.mediaIconSize
    }

    MouseArea {
        id: wallpaperMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: WallpaperStore.toggleSelector()
    }
}
