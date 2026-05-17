import "."
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    readonly property bool open: ConnectivityHover.hoveredModule !== ""
    readonly property int panelOverlap: 1
    readonly property int contentMargin: 12
    readonly property int panelHeight: Math.min(300, Math.max(80, (contentLoader.item?.implicitHeight ?? 0) + contentMargin * 2))

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.namespace: "qs-connectivity-popover"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    visible: root.open

    anchors {
        top: true
        right: true
    }

    margins {
        top: Style.pillHeight - root.panelOverlap
        right: 1
    }

    implicitWidth: Style.connectivityPillWidth
    implicitHeight: root.panelHeight
    color: "transparent"

    mask: Region {
        item: panel
    }

    Rectangle {
        id: panel

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: root.panelHeight
        radius: Style.pillRadius
        color: Mocha.pillBg
        border.color: Mocha.pillBorder
        border.width: 1
        clip: true

        HoverHandler {
            onHoveredChanged: hovered ? ConnectivityHover.show(ConnectivityHover.hoveredModule) : ConnectivityHover.hideSoon()
        }

        Loader {
            id: contentLoader
            anchors.fill: parent
            active: root.open
            sourceComponent: popoverContent
        }
    }

    Component {
        id: popoverContent

        Item {
            readonly property real activeHeight: {
                switch (ConnectivityHover.hoveredModule) {
                case "clock":
                    return clockPanel.implicitHeight;
                case "weather":
                    return weatherPanel.implicitHeight;
                case "network":
                    return networkPanel.implicitHeight;
                case "bluetooth":
                    return bluetoothPanel.implicitHeight;
                case "volume":
                    return volumePanel.implicitHeight;
                case "battery":
                    return batteryPanel.implicitHeight;
                default:
                    return 0;
                }
            }

            implicitHeight: activeHeight

            Network {
                id: netModule
                visible: false
            }
            Bluetooth {
                id: btModule
                visible: false
            }
            Volume {
                id: volModule
                visible: false
            }
            Battery {
                id: battModule
                visible: false
            }

            Item {
                anchors {
                    fill: parent
                    margins: root.contentMargin
                    topMargin: 10
                }

                ClockPopover {
                    id: clockPanel
                    hoveredModule: ConnectivityHover.hoveredModule
                }

                WeatherPopover {
                    id: weatherPanel
                    hoveredModule: ConnectivityHover.hoveredModule
                }

                NetworkPopover {
                    id: networkPanel
                    hoveredModule: ConnectivityHover.hoveredModule
                    netModule: netModule
                }

                BluetoothPopover {
                    id: bluetoothPanel
                    hoveredModule: ConnectivityHover.hoveredModule
                    btModule: btModule
                }

                VolumePopover {
                    id: volumePanel
                    hoveredModule: ConnectivityHover.hoveredModule
                    volModule: volModule
                }

                BatteryPopover {
                    id: batteryPanel
                    hoveredModule: ConnectivityHover.hoveredModule
                    battModule: battModule
                }
            }
        }
    }
}
