import "."
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        right: 1
    }

    implicitWidth: Style.connectivityPillWidth
    implicitHeight: pill.implicitHeight
    color: "transparent"

    mask: Region {
        item: pill
    }

    ConnectivityPill {
        id: pill

        anchors.top: parent.top
        anchors.right: parent.right
    }
}
