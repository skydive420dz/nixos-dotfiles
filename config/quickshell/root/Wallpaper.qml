pragma ComponentBehavior: Bound

import ".."
import QtQuick
import Quickshell
import QtMultimedia
import Quickshell.Wayland
import "../common"
import "../modules/wallpaper"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-wallpaper"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: Theme.bg

    Repeater {
        model: WallpaperStore.mediaKind(WallpaperStore.currentPath) === "image" ? [WallpaperStore.currentPath] : []

        delegate: Image {
            required property string modelData

            anchors.fill: parent
            source: WallpaperStore.fileUrl(modelData)
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
            smooth: true
            mipmap: true
        }
    }

    Repeater {
        model: WallpaperStore.mediaKind(WallpaperStore.currentPath) === "animated" ? [WallpaperStore.currentPath] : []

        delegate: AnimatedImage {
            required property string modelData

            anchors.fill: parent
            source: WallpaperStore.fileUrl(modelData)
            fillMode: Image.PreserveAspectCrop
            cache: false
            playing: true
            paused: false
            speed: 1.0
            smooth: true
        }
    }

    Repeater {
        model: WallpaperStore.mediaKind(WallpaperStore.currentPath) === "video" ? [WallpaperStore.currentPath] : []

        delegate: Video {
            required property string modelData

            anchors.fill: parent
            source: WallpaperStore.fileUrl(modelData)
            fillMode: VideoOutput.PreserveAspectCrop
            loops: MediaPlayer.Infinite
            muted: true
            volume: 0
            autoPlay: true

            Component.onCompleted: play()
        }
    }
}
