import ".."
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property var player
    property bool playing: false

    spacing: 8

    Text {
        text: "󰒮"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.player?.canGoPrevious ? (prevHover.containsMouse ? Mocha.text : Mocha.subtext0) : Mocha.overlay0

        MouseArea {
            id: prevHover
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.player?.previous()
        }
    }

    Text {
        text: root.playing ? "󰏤" : "󰐊"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.accent

        MouseArea {
            anchors.fill: parent
            onClicked: root.player?.togglePlaying()
        }
    }

    Text {
        text: "󰒭"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.player?.canGoNext ? (nextHover.containsMouse ? Mocha.text : Mocha.subtext0) : Mocha.overlay0

        MouseArea {
            id: nextHover
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.player?.next()
        }
    }
}
