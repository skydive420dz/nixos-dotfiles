import ".."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string hoveredModule: ""

    implicitWidth: connectRow.implicitWidth + Style.pillPadH * 2
    implicitHeight: root.hoveredModule !== "" ? Style.pillHeight + 300 : Style.pillHeight

    radius: Style.pillRadius
    color: Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1
    clip: true

    function show(moduleName) {
        hideTimer.stop();
        hoveredModule = moduleName;
    }

    function hideSoon() {
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 120
        repeat: false
        onTriggered: root.hoveredModule = ""
    }

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
            HoverHandler {
                onHoveredChanged: hovered ? root.show("clock") : root.hideSoon()
            }
        }
        Weather {
            id: weatherModule
            HoverHandler {
                onHoveredChanged: hovered ? root.show("weather") : root.hideSoon()
            }
        }
        Network {
            id: netModule
            HoverHandler {
                onHoveredChanged: hovered ? root.show("network") : root.hideSoon()
            }
        }
        Bluetooth {
            id: btModule
            HoverHandler {
                onHoveredChanged: hovered ? root.show("bluetooth") : root.hideSoon()
            }
        }
        Volume {
            id: volModule
            HoverHandler {
                onHoveredChanged: hovered ? root.show("volume") : root.hideSoon()
            }
        }
        Battery {
            id: battModule
            HoverHandler {
                onHoveredChanged: hovered ? root.show("battery") : root.hideSoon()
            }
        }
    }

    Item {
        id: popoverArea
        anchors {
            top: connectRow.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 12
            topMargin: 10
        }

        HoverHandler {
            onHoveredChanged: hovered ? hideTimer.stop() : root.hideSoon()
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
}
