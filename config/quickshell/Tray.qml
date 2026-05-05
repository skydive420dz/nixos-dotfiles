import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import "../theme"

Rectangle {
    id: root

    height: Style.pillHeight
    radius: Style.pillRadius
    color: Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1
    implicitWidth: trayRow.implicitWidth + Style.pillPadH * 2
    // Hide the entire pill when there are no tray items
    visible: SystemTray.items.values.length > 0

    RowLayout {
        id: trayRow
        anchors {
            centerIn: parent
        }
        spacing: 8

        Repeater {
            model: SystemTray.items

            delegate: Item {
                required property SystemTrayItem modelData

                width: 20
                height: 20

                Image {
                    anchors.fill: parent
                    source: modelData.icon
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    ToolTip.visible: hover.containsMouse
                    ToolTip.text: modelData.tooltip?.title ?? modelData.tooltip?.description ?? ""
                    ToolTip.delay: 400
                }

                MouseArea {
                    id: hover
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            modelData.activate();
                    }
                }
            }
        }
    }
}
