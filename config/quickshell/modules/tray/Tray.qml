import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    id: root

    Layout.preferredHeight: Theme.pillHeight
    spacing: Theme.gap
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        delegate: Image {
            required property SystemTrayItem modelData

            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize
            source: modelData.icon
            smooth: true
            mipmap: true

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
            }
        }
    }
}
