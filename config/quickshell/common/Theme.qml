pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "Symbols Nerd Font"

    readonly property int barHeight: 34
    readonly property int pillHeight: 32
    readonly property int radius: 8
    readonly property int radiusSmall: 5
    readonly property int pad: 8
    readonly property int gap: 4
    readonly property int fontSize: 12
    readonly property int fontSizeSmall: 10
    readonly property int iconSize: 14
    readonly property int statusIconSize: 12
    readonly property int mediaIconSize: 14

    readonly property string configHome: Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")
    readonly property string themeDir: configHome + "/theme/current"

    property string styleName: "SkyDark"
    property color bg: Qt.rgba(0.102, 0.114, 0.129, 0.82)
    property color panel: Qt.rgba(0.133, 0.149, 0.169, 0.78)
    property color panelAlt: Qt.rgba(0.157, 0.173, 0.204, 0.84)
    property color border: Qt.rgba(0.239, 0.259, 0.290, 0.58)
    property color text: "#f0efeb"
    property color muted: "#676d77"
    property color accent: "#b4c0c8"
    property color danger: "#cdacac"
    property color warning: "#d4ccb4"
    property color good: "#b8c4b8"

    function colorFromHex(hex, alpha) {
        var h = String(hex || "").replace("#", "");
        var resolvedAlpha = alpha === undefined || alpha === null ? 1 : alpha;
        if (h.length !== 6)
            return Qt.rgba(1, 1, 1, resolvedAlpha);

        return Qt.rgba(
            parseInt(h.slice(0, 2), 16) / 255,
            parseInt(h.slice(2, 4), 16) / 255,
            parseInt(h.slice(4, 6), 16) / 255,
            resolvedAlpha
        );
    }

    function applyTheme(payload) {
        root.styleName = payload.name || root.styleName;
        root.bg = colorFromHex(payload.bg, payload.bgAlpha === undefined ? 0.82 : payload.bgAlpha);
        root.panel = colorFromHex(payload.panel, payload.panelAlpha === undefined ? 0.78 : payload.panelAlpha);
        root.panelAlt = colorFromHex(payload.panelAlt, payload.panelAltAlpha === undefined ? 0.84 : payload.panelAltAlpha);
        root.border = colorFromHex(payload.border, payload.borderAlpha === undefined ? 0.58 : payload.borderAlpha);
        root.text = payload.text || root.text;
        root.muted = payload.muted || root.muted;
        root.accent = payload.accent || root.accent;
        root.danger = payload.danger || root.danger;
        root.warning = payload.warning || root.warning;
        root.good = payload.good || root.good;
    }

    Component.onCompleted: loadThemeProc.running = true

    FileView {
        path: root.themeDir + "/quickshell-signal"
        watchChanges: true
        printErrors: false
        onFileChanged: loadThemeProc.running = true
    }

    Process {
        id: loadThemeProc
        command: ["bash", "-lc", "cat " + JSON.stringify(root.themeDir + "/quickshell.json") + " 2>/dev/null || true"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data
        }
        onExited: {
            try {
                var payload = JSON.parse(stdout.buffer.trim());
                root.applyTheme(payload);
            } catch (e) {}
            stdout.buffer = "";
        }
    }
}
