import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    // ── Layer shell ───────────────────────────────────────────────────────────
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: height + 5   // reserve bar + top margin
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
        right: 13
        bottom: 0
    }

    height: Style.barHeight
    color: "transparent"

    // ── Layout ───────────────────────────────────────────────────────────────
    RowLayout {
        anchors {
            fill: parent
            leftMargin: 4
            rightMargin: 4
        }
        spacing: 0

        // ── Left ─────────────────────────────────────────────────────────────
        OsButton {}

        Item {
            width: 8
        }

        Workspaces {}

        // ── Center ───────────────────────────────────────────────────────────
        Item {
            Layout.fillWidth: true
        }

        WindowTitle {}

        Item {
            Layout.fillWidth: true
        }

        // ── Right ────────────────────────────────────────────────────────────
        Tray {}

        Item {
            width: Style.groupSpacing
        }

        // Connectivity pill: Clock → Weather → Network → BT → Volume → Battery
        Rectangle {
            height: Style.pillHeight
            radius: Style.pillRadius
            color: Mocha.pillBg
            border.color: Mocha.pillBorder
            border.width: 1
            implicitWidth: connectRow.implicitWidth + Style.pillPadH * 2

            RowLayout {
                id: connectRow
                anchors {
                    fill: parent
                    leftMargin: Style.pillPadH
                    rightMargin: Style.pillPadH
                }
                spacing: Style.pillSpacing

                Clock {}
                Weather {}
                Network {}
                Bluetooth {}
                Volume {}
                Battery {}
            }
        }
    }
}
