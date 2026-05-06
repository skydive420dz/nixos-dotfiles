import ".."
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

Rectangle {
    id: root

    implicitWidth: Style.pillPadH * 1 + label.implicitWidth
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
        text: " 󱄅 "
        font.pixelSize: 26
        font.family: Style.font
        color: Mocha.blue
    }

    Process {
        id: rofiProc
        command: ["sh", "-c", "pkill rofi || uwsm app -- rofi -show drun"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: rofiProc.running = true
    }
}
