import QtQuick
import Quickshell.Hyprland
import "../theme"

Rectangle {
    id: root

    height: Style.pillHeight
    radius: Style.pillRadius
    color: Mocha.pillBg
    border.color: Mocha.pillBorder
    border.width: 1
    implicitWidth: Math.min(label.implicitWidth + Style.pillPadH * 2, 320)
    clip: true

    property string windowClass: ""
    property string windowTitle: ""

    // Rewrite rules matching your waybar config
    readonly property string displayTitle: {
        if (!windowTitle)
            return "   Desktop";
        var c = windowClass.toLowerCase();
        var t = windowTitle;
        if (c === "firefox")
            return "  " + t.replace(/ [—–] Mozilla Firefox$/, "").replace(/ Mozilla Firefox$/, "");
        if (c === "kitty" || c === "alacritty")
            return "  Terminal";
        if (c === "vesktop" || c === "discord")
            return "  Discord";
        if (c.includes("zsh") || c.includes("bash"))
            return "  " + t;
        return "  " + t;
    }

    Text {
        id: label
        anchors.centerIn: parent
        width: Math.min(implicitWidth, root.width - Style.pillPadH * 2)
        text: root.displayTitle
        color: Mocha.lavender
        font.pixelSize: Style.fontSize
        font.family: Style.font
        elide: Text.ElideRight
    }

    // React to focus changes via Hyprland socket events.
    // activewindow event payload: "class,title"
    HyprlandIpc {
        onEvent: event => {
            if (event.type === "activewindow") {
                var parts = event.data.split(",");
                root.windowClass = parts[0] ?? "";
                root.windowTitle = parts.slice(1).join(",") ?? "";
            }
            if (event.type === "closewindow" || event.type === "openwindow") {
                root.windowClass = "";
                root.windowTitle = "";
            }
        }
    }
}
