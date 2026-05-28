import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Rectangle {
    id: root

    visible: mediaActive
    implicitWidth: mediaActive ? Math.min(mediaRow.implicitWidth + Theme.pad * 2, 520) : 0
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: visible ? implicitWidth : 0
    Layout.preferredHeight: visible ? implicitHeight : 0
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: "transparent"
    border.color: "transparent"
    border.width: 0
    clip: true

    property var controller: null
    readonly property var mediaPlayer: controller?.mediaPlayer ?? null
    readonly property bool mediaActive: mediaPlayer !== null
    readonly property bool mediaPlaying: mediaPlayer?.playbackState === MprisPlaybackState.Playing
    readonly property string title: mediaPlayer?.trackTitle || mediaPlayer?.identity || "Media"
    readonly property string artist: mediaPlayer?.trackArtist || ""
    readonly property string artUrl: mediaPlayer?.trackArtUrl || ""
    readonly property var metadata: mediaPlayer?.metadata ?? ({})
    readonly property string mediaUrl: metadata["xesam:url"] ?? ""
    readonly property string playerSource: ((mediaPlayer?.desktopEntry || "") + " " + (mediaPlayer?.identity || "")).toLowerCase()
    readonly property bool isYoutube: mediaUrl.indexOf("youtube.com") >= 0 || mediaUrl.indexOf("youtu.be") >= 0
    readonly property bool isSpotify: playerSource.indexOf("spotify") >= 0
    readonly property bool isMpv: playerSource.indexOf("mpv") >= 0
    readonly property bool isVlc: playerSource.indexOf("vlc") >= 0
    readonly property bool isBrowserMedia: isYoutube || playerSource.indexOf("firefox") >= 0 || playerSource.indexOf("chrom") >= 0
    readonly property string contentIcon: isYoutube ? "" : isSpotify ? "󰓇" : isMpv ? "󰐹" : isVlc ? "󰕼" : isBrowserMedia ? "󰖟" : "󰝚"
    readonly property color contentColor: isYoutube ? Theme.danger : isSpotify ? Theme.good : isBrowserMedia ? Theme.accent : Theme.muted

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        id: mediaRow
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.pad
            rightMargin: Theme.pad
        }
        spacing: 8

        RowLayout {
            spacing: 6

            Text {
                Layout.preferredWidth: Theme.iconSize
                text: "󰒮"
                color: Theme.muted
                opacity: root.mediaPlayer?.canGoPrevious ? 1 : 0.30
                font.family: Theme.iconFont
                font.pixelSize: Theme.mediaIconSize
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: root.mediaPlayer?.canGoPrevious ?? false
                    onClicked: root.mediaPlayer?.previous()
                }
            }

            Text {
                Layout.preferredWidth: Theme.iconSize
                text: root.mediaPlaying ? "󰏤" : "󰐊"
                color: Theme.accent
                font.family: Theme.iconFont
                font.pixelSize: Theme.mediaIconSize
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.mediaPlayer?.togglePlaying()
                }
            }

            Text {
                Layout.preferredWidth: Theme.iconSize
                text: "󰒭"
                color: Theme.muted
                opacity: root.mediaPlayer?.canGoNext ? 1 : 0.30
                font.family: Theme.iconFont
                font.pixelSize: Theme.mediaIconSize
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: root.mediaPlayer?.canGoNext ?? false
                    onClicked: root.mediaPlayer?.next()
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: Theme.pillHeight - 14
            color: Theme.border
        }

        MediaAnalyzer {
            active: root.mediaPlaying
        }

        ColumnLayout {
            Layout.preferredWidth: 180
            Layout.maximumWidth: 180
            spacing: 0

            RowLayout {
                Layout.maximumWidth: 180
                spacing: 4

                Text {
                    visible: root.contentIcon !== ""
                    text: root.contentIcon
                    color: root.contentColor
                    font.family: Theme.iconFont
                    font.pixelSize: Theme.statusIconSize
                }

                Text {
                    Layout.fillWidth: true
                    text: root.title
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    elide: Text.ElideRight
                }
            }

            Text {
                Layout.maximumWidth: 180
                text: root.artist || root.mediaPlayer?.identity || ""
                color: Theme.muted
                font.family: Theme.font
                font.pixelSize: Theme.fontSizeSmall
                elide: Text.ElideRight
                visible: text !== ""
            }
        }

        Rectangle {
            Layout.preferredWidth: Theme.pillHeight - 8
            Layout.preferredHeight: Theme.pillHeight - 8
            radius: 5
            color: Theme.panelAlt
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
