pragma Singleton

import QtQuick

QtObject {
    readonly property string font: "JetBrainsMono Nerd Font Mono"

    readonly property int barHeight: 30
    readonly property int pillHeight: 24
    readonly property int radius: 7
    readonly property int radiusSmall: 5
    readonly property int pad: 9
    readonly property int gap: 5
    readonly property int fontSize: 12
    readonly property int iconSize: 13

    readonly property color bg: "#17191d"
    readonly property color panel: "#1d2026"
    readonly property color panelAlt: "#232731"
    readonly property color border: "#333946"
    readonly property color text: "#c9d1dd"
    readonly property color muted: "#7d8796"
    readonly property color accent: "#7aa2f7"
    readonly property color danger: "#f38ba8"
    readonly property color warning: "#f9e2af"
    readonly property color good: "#a6e3a1"
}
