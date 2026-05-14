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
    readonly property bool hasProgress: player !== null && player.length > 0
    property real progress: 0

    function refreshProgress() {
        if (!hasProgress) {
            progress = 0;
            return;
        }

        progress = Math.max(0, Math.min(player.position / player.length, 1.0));
    }

    onPlayerChanged: refreshProgress()
    onPlayingChanged: refreshProgress()

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

    Timer {
        interval: 1000
        running: root.playing
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshProgress()
    }

    // Progress bar — sits flush under the pill, same width, peeks out like an underline
    Rectangle {
        anchors.bottom: pill.bottom
        anchors.left: pill.left
        anchors.right: pill.right
        height: pill.height
        radius: Style.pillRadius
        color: "transparent"
        opacity: root.hasProgress ? 1 : 0
        z: 0   // behind pill

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Style.pillRadius
            anchors.rightMargin: Style.pillRadius
            height: 2
            color: Mocha.surface1

            Rectangle {
                width: parent.width * root.progress
                height: parent.height
                radius: 1
                color: Mocha.mauve
                Behavior on width {
                    NumberAnimation {
                        duration: 900
                    }
                }
            }
        }
    }

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
        z: 1   // above progress bar

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

            // Track info
            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: root.trackWidth
                Layout.maximumWidth: root.trackWidth
                implicitWidth: root.trackWidth
                implicitHeight: Style.pillHeight
                clip: true

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 1

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 4
                        Layout.maximumWidth: root.trackWidth

                        Text {
                            visible: root.contentIcon !== ""
                            text: root.contentIcon
                            color: root.isYoutube ? Mocha.red : Mocha.mauve
                            font.pixelSize: Style.fontSizeS + 1
                            font.family: Style.font
                        }

                        Text {
                            text: root.title
                            color: Mocha.text
                            font.pixelSize: Style.fontSizeS + 1
                            font.family: Style.font
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.maximumWidth: root.trackWidth - (root.contentIcon !== "" ? 18 : 0)
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.artist
                        color: Mocha.subtext0
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        elide: Text.ElideRight
                        Layout.maximumWidth: root.trackWidth
                        visible: text !== ""
                    }
                }
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
