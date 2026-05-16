pragma Singleton
import QtQuick

QtObject {
    // ── Base ──────────────────────────────────────────────────────────────────
    readonly property color base: "#171923"
    readonly property color mantle: "#13151d"
    readonly property color crust: "#0d0f15"

    // ── Surface ───────────────────────────────────────────────────────────────
    readonly property color surface0: "#242734"
    readonly property color surface1: "#303442"
    readonly property color surface2: "#3d4252"

    // ── Overlay ───────────────────────────────────────────────────────────────
    readonly property color overlay0: "#5d6374"
    readonly property color overlay1: "#737a8b"
    readonly property color overlay2: "#8991a0"

    // ── Text ──────────────────────────────────────────────────────────────────
    readonly property color text: "#d6d9e3"
    readonly property color subtext0: "#a2a8b6"
    readonly property color subtext1: "#bbc0cb"

    // ── Accent ────────────────────────────────────────────────────────────────
    readonly property color lavender: "#9da8cf"
    readonly property color blue: "#8ca6c9"
    readonly property color sapphire: "#7fa8b6"
    readonly property color sky: "#8bb9c2"
    readonly property color teal: "#8fb9aa"
    readonly property color green: "#9abf9d"
    readonly property color yellow: "#d4be86"
    readonly property color peach: "#d1a07b"
    readonly property color maroon: "#c08a95"
    readonly property color red: "#c98795"
    readonly property color mauve: "#b59ac7"
    readonly property color pink: "#c5a4bd"
    readonly property color flamingo: "#c9aaa7"
    readonly property color rosewater: "#d7b8ad"

    // ── Derived / utility ─────────────────────────────────────────────────────
    readonly property color accent: blue
    readonly property color pillBg: Qt.rgba(0.090, 0.098, 0.135, 0.58)
    readonly property color pillBorder: Qt.rgba(0.616, 0.659, 0.812, 0.10)
    readonly property color panelBg: Qt.rgba(base.r, base.g, base.b, 0.92)
    readonly property color panelBorder: pillBorder
    readonly property color controlBg: Qt.rgba(surface0.r, surface0.g, surface0.b, 0.58)
    readonly property color iconBg: Qt.rgba(surface0.r, surface0.g, surface0.b, 0.55)
    readonly property color rowHover: Qt.rgba(surface0.r, surface0.g, surface0.b, 0.50)
    readonly property color rowSelected: Qt.rgba(surface1.r, surface1.g, surface1.b, 0.72)
    readonly property color statusMutedBg: Qt.rgba(red.r, red.g, red.b, 0.30)
}
