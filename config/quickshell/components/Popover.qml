import ".."
import QtQuick
import Quickshell
import Quickshell.Wayland

// Usage:
//   Popover {
//       id: pop
//       showing: root.hovered
//       side: "right"          // "right" | "left"
//       popWidth: 280
//       popHeight: content.implicitHeight + 24
//       Item { id: content; ... }
//   }

PanelWindow {
    id: popWin

    default property alias content: inner.children
    property bool showing: false
    property string side: "right"    // which side of bar to anchor to
    property int popWidth: 260
    property int popHeight: 200
    property int rightMargin: 13
    property int leftMargin: 5

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.namespace: "qs-popover"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors.top: true
    anchors.right: side === "right"
    anchors.left: side === "left"

    margins.top: Style.popoverTop
    margins.right: side === "right" ? rightMargin : 0
    margins.left: side === "left" ? leftMargin : 0

    implicitWidth: popWidth
    implicitHeight: popHeight

    // Keep the window alive during the fade-out animation
    visible: panel.opacity > 0.01
    color: "transparent"

    Rectangle {
        id: panel
        anchors.fill: parent

        color: Qt.rgba(0.118, 0.118, 0.180, 0.85)
        radius: Style.pillRadius
        border.color: Mocha.pillBorder
        border.width: 1

        // Slide + fade animation
        opacity: popWin.showing ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        transform: Translate {
            y: panel.opacity < 0.5 ? -8 : 0
            Behavior on y {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
        }
        // Content slot
        Item {
            id: inner
            anchors {
                fill: parent
                margins: 14
            }
        }
    }
}
