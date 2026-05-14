import ".."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string hoveredModule: ""

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
