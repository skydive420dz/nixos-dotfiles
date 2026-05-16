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
        color: root.player?.canGoPrevious ? Mocha.text : Mocha.overlay0

        MouseArea {
            anchors.fill: parent
            onClicked: root.player?.previous()
        }
    }

    Text {
        text: root.playing ? "󰏤" : "󰐊"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.blue

        MouseArea {
            anchors.fill: parent
            onClicked: root.player?.togglePlaying()
        }
    }

    Text {
        text: "󰒭"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.player?.canGoNext ? Mocha.text : Mocha.overlay0

        MouseArea {
            anchors.fill: parent
            onClicked: root.player?.next()
        }
    }
}
