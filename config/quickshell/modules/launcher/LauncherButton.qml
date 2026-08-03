import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    Layout.preferredHeight: Theme.pillHeight
    Layout.preferredWidth: launcherText.implicitWidth + Theme.pad * 2
    radius: Theme.radius
    color: launcherMouse.containsMouse ? Theme.panelAlt : "transparent"
    border.width: 0

    Text {
        id: launcherText
        anchors.centerIn: parent
        text: "󱄅"
        color: Theme.accent
        font.family: Theme.font
        font.pixelSize: 18
    }

    MouseArea {
        id: launcherMouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                Quickshell.execDetached(["qs", "ipc", "call", "clipboard", "toggle"]);
            else
                Quickshell.execDetached(["qs", "ipc", "call", "launcher", "toggle"]);
        }
    }
}
