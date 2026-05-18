import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    id: trayRoot

    Layout.preferredHeight: Theme.pillHeight
    spacing: Theme.gap
    visible: SystemTray.items.values.length > 0

    required property var panelWindow

    Repeater {
        model: SystemTray.items

        delegate: Image {
            id: trayIcon

            required property SystemTrayItem modelData

            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize
            source: modelData.icon
            smooth: true
            mipmap: true

            function showMenu() {
                if (!modelData.hasMenu)
                    return false;

                const pos = trayIcon.mapToItem(null, trayIcon.width / 2, trayIcon.height);
                modelData.display(trayRoot.panelWindow, pos.x, pos.y);
                return true;
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        if (!trayIcon.showMenu())
                            modelData.secondaryActivate();
                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate();
                    } else if (modelData.onlyMenu) {
                        trayIcon.showMenu();
                    } else {
                        modelData.activate();
                    }
                }
            }
        }
    }
}
