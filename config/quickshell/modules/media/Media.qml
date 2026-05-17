import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Rectangle {
    id: root

    visible: mediaActive
    implicitWidth: Math.min(mediaRow.implicitWidth + Theme.pad * 2, 360)
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: visible ? implicitWidth : 0
    Layout.preferredHeight: visible ? implicitHeight : 0
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: Theme.panel
    border.color: Theme.border
    border.width: 1
    clip: true

    property var controller: null
    readonly property var mediaPlayer: controller?.mediaPlayer ?? null
    readonly property bool mediaActive: mediaPlayer !== null
    readonly property bool mediaPlaying: mediaPlayer?.playbackState === MprisPlaybackState.Playing

    function mediaLabel() {
        if (!mediaPlayer)
            return "";
        var title = mediaPlayer.trackTitle || mediaPlayer.identity || "Media";
        var artist = mediaPlayer.trackArtist || "";
        return artist ? title + " - " + artist : title;
    }

    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: "󰒮"
            color: root.mediaPlayer?.canGoPrevious ? Theme.muted : Theme.border
            font.family: Theme.font
            font.pixelSize: Theme.iconSize

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.mediaPlayer?.canGoPrevious ?? false
                onClicked: root.mediaPlayer?.previous()
            }
        }

        Text {
            text: root.mediaPlaying ? "󰏤" : "󰐊"
            color: Theme.accent
            font.family: Theme.font
            font.pixelSize: Theme.iconSize

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                onClicked: root.mediaPlayer?.togglePlaying()
            }
        }

        Text {
            text: "󰒭"
            color: root.mediaPlayer?.canGoNext ? Theme.muted : Theme.border
            font.family: Theme.font
            font.pixelSize: Theme.iconSize

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.mediaPlayer?.canGoNext ?? false
                onClicked: root.mediaPlayer?.next()
            }
        }

        Text {
            Layout.maximumWidth: 230
            text: root.mediaLabel()
            color: Theme.muted
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
            elide: Text.ElideRight
        }
    }
}
