import "."
import QtQuick
import QtQuick.Layouts
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
        left: true
        right: true
    }
    margins {
        top: 0
        left: 0
        right: 0
        bottom: 0
    }

    implicitHeight: Style.barHeight + ((trayModule.menuOpen || pill.hoveredModule !== "") ? 320 : 0)
    color: "transparent"

    property var launcher: null

    // The mask defines which pixels of the surface accept mouse input.
    // We add clickCatcher conditionally — when the tray menu is open,
    // it covers the full panel so any click outside the tray pill closes it.
    mask: Region {
        item: pill
        Region {
            item: barRow
        }
        Region {
            item: mediaModule
        }
        Region {
            item: trayModule
        }
        Region {
            item: clickCatcher
        }
    }

    // ── Click catcher ─────────────────────────────────────────────────────────
    // Sits on top of everything when the tray menu is open. Catches every
    // click anywhere in the panel, closes the tray menu if the click was
    // outside the tray pill, then lets the click propagate to whatever is
    // beneath so workspaces, the right pill, etc. still respond normally.
    MouseArea {
        id: clickCatcher
        // Geometry is zero-sized when the menu isn't open, so the mask doesn't
        // include the full panel during normal operation.
        width: trayModule.menuOpen ? root.width : 0
        height: trayModule.menuOpen ? root.height : 0
        x: 0
        y: 0
        z: 1000   // above all other elements
        visible: trayModule.menuOpen
        propagateComposedEvents: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: mouse => {
            var inside = mapToItem(trayModule, mouse.x, mouse.y);
            var hitTray = inside.x >= 0 && inside.x <= trayModule.width && inside.y >= 0 && inside.y <= trayModule.height;

            if (!hitTray)
                trayModule.activeItem = null;
            // Always let the event propagate so the underlying handler runs.
            mouse.accepted = false;
        }
        onClicked: mouse => mouse.accepted = false
        onReleased: mouse => mouse.accepted = false
    }

    ConnectivityPill {
        id: pill

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
        anchors.rightMargin: 1
    }

    // ── Media — truly centered in the full bar ────────────────────────────────
    Media {
        id: mediaModule
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
    }

    // ── Tray — sibling of barRow so it can expand downward freely ─────────────
    Tray {
        id: trayModule
        anchors.top: parent.top
        anchors.right: pill.left
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
        anchors.rightMargin: implicitWidth > 0 ? Style.groupSpacing : 0
    }

    // ── Bar row ───────────────────────────────────────────────────────────────
    RowLayout {
        id: barRow
        anchors {
            top: parent.top
            left: parent.left
            right: trayModule.left
            leftMargin: 1
            rightMargin: trayModule.implicitWidth > 0 ? Style.groupSpacing : 0
        }
        height: Style.barHeight
        spacing: 0

        OsButton {
            launcher: launcher
            targetScreen: root.screen
        }
        Item {
            width: 6
        }
        Workspaces {}
        Item {
            width: Style.groupSpacing
        }
        WindowTitle {}
        Item {
            Layout.fillWidth: true
        }
    }
}
