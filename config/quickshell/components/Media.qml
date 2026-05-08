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
    property real progress: 0

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
        onTriggered: {
            if (!root.player || root.player.length <= 0)
                return;
            root.progress = Math.min(root.player.position / root.player.length, 1.0);
        }
    }

    // Progress bar — sits flush under the pill, same width, peeks out like an underline
    Rectangle {
        anchors.bottom: pill.bottom
        anchors.left: pill.left
        anchors.right: pill.right
        height: pill.height
        radius: Style.pillRadius
        color: "transparent"
        z: 0   // behind pill

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

            // Prev
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

            // Play / Pause
            Text {
                text: root.playing ? "󰏤" : "󰐊"
                font.pixelSize: Style.fontSize
                font.family: Style.font
                color: Mocha.mauve
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.player?.togglePlaying()
                }
            }

            // Next
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

            Rectangle {
                width: 1
                height: 16
                color: Mocha.pillBorder
            }

            // Track info
            Item {
                Layout.fillWidth: true
                implicitWidth: 180
                implicitHeight: Style.pillHeight
                clip: true

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 1

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.player?.trackTitle || "Unknown"
                        color: Mocha.text
                        font.pixelSize: Style.fontSizeS + 1
                        font.family: Style.font
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.maximumWidth: 180
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.player?.trackArtist || ""
                        color: Mocha.subtext0
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        elide: Text.ElideRight
                        Layout.maximumWidth: 180
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
                visible: (root.player?.trackArtUrl ?? "") !== ""

                Image {
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }
        }
    }
}
