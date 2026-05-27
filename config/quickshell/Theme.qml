pragma Singleton

import QtQuick

QtObject {
    readonly property string font: "JetBrainsMono Nerd Font"

    readonly property int barHeight: 26
    readonly property int pillHeight: 24
    readonly property int radius: 7
    readonly property int radiusSmall: 5
    readonly property int pad: 4
    readonly property int gap: 2
    readonly property int fontSize: 12
    readonly property int iconSize: 16

    readonly property color bg: Qt.rgba(0.075, 0.082, 0.114, 0.82)
    readonly property color panel: Qt.rgba(0.090, 0.098, 0.135, 0.78)
    readonly property color panelAlt: Qt.rgba(0.141, 0.153, 0.204, 0.84)
    readonly property color border: Qt.rgba(0.200, 0.224, 0.275, 0.58)
    readonly property color text: "#c9d1dd"
    readonly property color muted: "#7d8796"
    readonly property color accent: "#b4befe"
    readonly property color danger: "#f38ba8"
    readonly property color warning: "#f9e2af"
    readonly property color good: "#a6e3a1"
}
