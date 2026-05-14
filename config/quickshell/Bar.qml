import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Style.barHeight + 5
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 5
        left: 5
        right: 5
        bottom: 0
    }

    implicitHeight: Style.barHeight + 320
    color: "transparent"

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

    property string hoveredModule: ""

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

    // ── Connectivity pill ─────────────────────────────────────────────────────
    Rectangle {
        id: pill

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
        anchors.rightMargin: 5

        implicitWidth: connectRow.implicitWidth + Style.pillPadH * 2
        implicitHeight: root.hoveredModule !== "" ? Style.pillHeight + 300 : Style.pillHeight
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        radius: Style.pillRadius
        color: Mocha.pillBg
        border.color: Mocha.pillBorder
        border.width: 1
        clip: true

        RowLayout {
            id: connectRow
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: Style.pillPadH
                rightMargin: Style.pillPadH
            }
            height: Style.pillHeight
            spacing: Style.pillSpacing

            Clock {
                id: clockModule
            }
            Weather {
                id: weatherModule
            }
            Network {
                id: netModule
            }
            Bluetooth {
                id: btModule
            }
            Volume {
                id: volModule
            }
            Battery {
                id: battModule
            }
        }

        Item {
            anchors {
                top: connectRow.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 12
                topMargin: 10
            }

            ClockPopover {
                hoveredModule: root.hoveredModule
            }

            WeatherPopover {
                hoveredModule: root.hoveredModule
            }

            NetworkPopover {
                hoveredModule: root.hoveredModule
                netModule: netModule
            }

            BluetoothPopover {
                hoveredModule: root.hoveredModule
                btModule: btModule
            }

            VolumePopover {
                hoveredModule: root.hoveredModule
                volModule: volModule
            }

            BatteryPopover {
                hoveredModule: root.hoveredModule
                battModule: battModule
            }
        }

        MouseArea {
            z: 1
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            onPositionChanged: {
                if (mouseY > Style.pillHeight)
                    return;
                var localX = mouseX - Style.pillPadH;
                var modules = [clockModule, weatherModule, netModule, btModule, volModule, battModule];
                var names = ["clock", "weather", "network", "bluetooth", "volume", "battery"];
                var cx = 0;
                for (var i = 0; i < modules.length; i++) {
                    if (i > 0)
                        cx += Style.pillSpacing;
                    cx += modules[i].implicitWidth;
                    if (localX < cx) {
                        root.hoveredModule = names[i];
                        return;
                    }
                }
                root.hoveredModule = "";
            }
            onExited: root.hoveredModule = ""
            onClicked: mouse => mouse.accepted = false
            onPressed: mouse => mouse.accepted = false
            onReleased: mouse => mouse.accepted = false
        }
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
        anchors.rightMargin: Style.groupSpacing
    }

    // ── Bar row ───────────────────────────────────────────────────────────────
    RowLayout {
        id: barRow
        anchors {
            top: parent.top
            left: parent.left
            right: trayModule.left
            leftMargin: 4
            rightMargin: Style.groupSpacing
        }
        height: Style.barHeight
        spacing: 0

        OsButton {}
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
