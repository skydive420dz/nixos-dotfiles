import ".."
import QtQuick
import Quickshell

Rectangle {
    id: root

    implicitWidth: Style.pillPadH * 1 + label.implicitWidth
    height: Style.pillHeight
    radius: Style.pillRadius
    color: hovered ? Mocha.rowHover : Mocha.pillBg
    border.color: Mocha.panelBorder
    border.width: 1

    property bool hovered: false
    property var targetScreen: null

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: " 󱄅 "
        font.pixelSize: 26
        font.family: Style.font
        color: Mocha.accent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: Quickshell.execDetached([
            "bash",
            "-lc",
            "$HOME/.config/scripts/launcher-toggle \"$1\"",
            "launcher-toggle",
            root.targetScreen?.name ?? ""
        ])
    }
}
