pragma Singleton

import QtQuick

QtObject {
    // Status cluster geometry. Tune these first when the right pill drifts.
    readonly property int statusClusterWidth: 240
    readonly property int statusClusterLeftMargin: 8
    readonly property int statusClusterRightMargin: 8
    readonly property int statusClusterSpacing: 6
    readonly property int statusRightGroupSpacing: 3

    // Network module geometry.
    readonly property int networkSlotWidth: 61
    readonly property int networkGraphWidth: 38
    readonly property int networkGraphHeightOffset: 8
    readonly property int networkIconGraphGap: 9
    readonly property int networkIconWidth: 14

    // Network graph dot geometry.
    readonly property int networkGraphDotSize: 2
    readonly property int networkGraphPitch: 4
}
