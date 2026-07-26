import "../.."
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var controller

    implicitWidth: StatusMetrics.statusClusterWidth
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: "transparent"
    border.color: "transparent"
    border.width: 0
    clip: true

    RowLayout {
        id: statusRow
        anchors.fill: parent
        anchors.leftMargin: StatusMetrics.statusClusterLeftMargin
        anchors.rightMargin: StatusMetrics.statusClusterRightMargin
        spacing: StatusMetrics.statusClusterSpacing

        Network {
            kind: root.controller.network
            signal: root.controller.networkSignal
            downRate: root.controller.networkDownRate
            upRate: root.controller.networkUpRate
            downSamples: root.controller.networkDownSamples
            upSamples: root.controller.networkUpSamples
        }

        Bluetooth {
            available: root.controller.bluetoothAvailable
            connected: root.controller.bluetoothConnected
        }

        RowLayout {
            spacing: StatusMetrics.statusRightGroupSpacing

            Volume {
                level: root.controller.volume
                muted: root.controller.muted
            }

            Battery {
                level: root.controller.battery
                charging: root.controller.charging
                status: root.controller.batteryStatus
            }

            Clock {}
        }
    }
}
