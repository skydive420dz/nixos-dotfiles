pragma ComponentBehavior: Bound

import ".."
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../modules/wallpaper"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: WallpaperStore.selectorOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-wallpaper-picker"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: WallpaperStore.selectorOpen
    color: "transparent"

    mask: Region {
        item: selector.maskItem
    }

    WallpaperSelector {
        id: selector
    }
}
