import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Item {
    id: root
    implicitHeight: Style.pillHeight

    property MprisPlayer player: {
        var players = Mpris.players.values;
        for (var i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing)
                return players[i];
        }
        for (var j = 0; j < players.length; j++) {
            if (players[j].playbackState === MprisPlaybackState.Paused)
                return players[j];
        }
        return null;
    }

    readonly property bool active: player !== null
    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing
    readonly property string title: player?.trackTitle || "Unknown"
    readonly property string artist: player?.trackArtist || ""
    readonly property string artUrl: player?.trackArtUrl || ""
    readonly property var metadata: player?.metadata ?? ({})
    readonly property string mediaUrl: metadata["xesam:url"] ?? ""
    readonly property string playerSource: ((player?.desktopEntry || "") + " " + (player?.identity || "")).toLowerCase()
    readonly property bool isYoutube: mediaUrl.indexOf("youtube.com") >= 0 || mediaUrl.indexOf("youtu.be") >= 0
    readonly property bool isBrowserMedia: isYoutube || playerSource.indexOf("firefox") >= 0
    readonly property string contentIcon: isYoutube ? "" : isBrowserMedia ? "󰕧" : ""
    readonly property real trackWidth: 180

    implicitWidth: active ? pill.implicitWidth : 0
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    opacity: active ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }
    visible: opacity > 0

    Rectangle {
        id: pill
        layer.enabled: true
        anchors.fill: parent
        implicitWidth: mediaRow.implicitWidth + Style.pillPadH * 2
        height: Style.pillHeight
        radius: Style.pillRadius
        color: Mocha.pillBg
        border.color: Mocha.pillBorder
        border.width: 1
        clip: false

        RowLayout {
            id: mediaRow
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: Style.pillPadH
                rightMargin: Style.pillPadH
            }
            spacing: 8

            MediaControls {
                player: root.player
                playing: root.playing
            }

            Rectangle {
                width: 1
                height: 16
                color: Mocha.pillBorder
            }

            MediaTrack {
                title: root.title
                artist: root.artist
                contentIcon: root.contentIcon
                isYoutube: root.isYoutube
                trackWidth: root.trackWidth
            }

            Rectangle {
                width: 1
                height: 16
                color: Mocha.pillBorder
            }

            // Album art
            Rectangle {
                width: Style.pillHeight - 8
                height: Style.pillHeight - 8
                radius: 4
                color: Mocha.surface1
                clip: true
                visible: root.artUrl !== ""

                Image {
                    anchors.fill: parent
                    source: root.artUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }
        }
    }
}
