pragma ComponentBehavior: Bound

import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: root

    required property var controller
    required property var screen

    implicitWidth: workspaceRow.implicitWidth + Theme.pad * 2
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: "transparent"
    border.color: "transparent"
    border.width: 0
    clip: true

    readonly property var monitor: Hyprland.monitors.values.length > 0 ? Hyprland.monitorFor(screen) : null
    readonly property int activeWorkspace: monitor?.activeWorkspace?.id ?? 1
    readonly property var occupiedWorkspaces: controller.occupiedWorkspaces

    function switchWorkspace(workspaceId) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = \"" + workspaceId + "\" })");
        controller.refreshWorkspaces();
    }

    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: 9
            delegate: Rectangle {
                id: workspaceButton

                required property int index
                readonly property int workspaceId: index + 1
                readonly property bool active: root.activeWorkspace === workspaceId
                readonly property bool occupied: root.occupiedWorkspaces[workspaceId] ?? false

                implicitWidth: active ? 25 : 16
                implicitHeight: 16
                Layout.preferredWidth: active ? 25 : 16
                Layout.preferredHeight: 16
                radius: Theme.radiusSmall
                color: active ? Theme.accent : occupied ? Theme.border : Theme.bg
                clip: true

                Text {
                    anchors.centerIn: parent
                    text: workspaceButton.workspaceId
                    color: workspaceButton.active ? Theme.bg : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    onPressed: mouse => {
                        root.switchWorkspace(workspaceButton.workspaceId);
                        mouse.accepted = true;
                    }
                }
            }
        }
    }
}
