import QtQuick
import Quickshell
import Quickshell.Wayland
import "../modules/osd"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-osd"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: osdView.showing
    color: "transparent"

    mask: Region {
        item: osdView.maskItem
    }

    OsdView {
        id: osdView
    }
}
