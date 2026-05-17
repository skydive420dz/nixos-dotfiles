import "."
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Style.barHeight + 1
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
    }

    implicitWidth: Math.max(mediaModule.implicitWidth, 1)
    implicitHeight: Style.barHeight
    color: "transparent"

    mask: Region {
        item: mediaModule
    }

    Media {
        id: mediaModule
        anchors.centerIn: parent
    }
}
