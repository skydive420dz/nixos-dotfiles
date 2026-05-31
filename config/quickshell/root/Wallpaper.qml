pragma ComponentBehavior: Bound

import ".."
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../common"
import "../modules/wallpaper"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Background
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

    Image {
        anchors.fill: parent
        visible: !WallpaperStore.isAnimated(WallpaperStore.currentPath)
        source: WallpaperStore.fileUrl(WallpaperStore.currentPath)
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        smooth: true
        mipmap: true
    }

    AnimatedImage {
        anchors.fill: parent
        visible: WallpaperStore.isAnimated(WallpaperStore.currentPath)
        source: WallpaperStore.fileUrl(WallpaperStore.currentPath)
        fillMode: Image.PreserveAspectCrop
        cache: false
        playing: visible
        smooth: true
    }
}
