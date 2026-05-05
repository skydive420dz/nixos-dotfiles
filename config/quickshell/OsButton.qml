import QtQuick
import Quickshell.Hyprland
import "../theme"

Rectangle {
    id: root

    implicitWidth: Style.pillPadH * 2 + label.implicitWidth
    height: Style.pillHeight
    radius: Style.pillRadius
    color: hovered ? Qt.rgba(Mocha.surface0.r, Mocha.surface0.g, Mocha.surface0.b, 0.5) : Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1

    property bool hovered: false

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: ""    // nf-linux-nixos
        font.pixelSize: 18
        font.family: Style.font
        color: Mocha.blue
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        // Opens rofi app launcher — same as your keybind
        onClicked: Hyprland.dispatch("exec rofi -show drun")
    }
}
