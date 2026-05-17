import ".."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: Style.connectivityPillWidth
    implicitHeight: Style.pillHeight

    radius: Style.pillRadius
    color: Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1
    clip: true

    function show(moduleName) {
        ConnectivityHover.show(moduleName);
    }

    function hideSoon() {
        ConnectivityHover.hideSoon();
    }

    RowLayout {
        id: connectRow
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
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
}
