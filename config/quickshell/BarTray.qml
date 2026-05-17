import "."
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    readonly property int trayOffset: Style.connectivityPillWidth + Style.groupSpacing + 1

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.namespace: "qs-tray"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        right: root.trayOffset
    }

    implicitWidth: Math.max(trayModule.implicitWidth, 1)
    implicitHeight: Math.max(Style.barHeight, trayModule.implicitHeight)
    color: "transparent"

    mask: Region {
        item: trayModule
    }

    Tray {
        id: trayModule

        anchors.top: parent.top
        anchors.right: parent.right
    }
}
