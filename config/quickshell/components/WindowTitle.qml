import ".."
import QtQuick
import Quickshell.Hyprland

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

    // Reactive — responds to Hyprland socket events instantly, no polling
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activewindow") {
                // payload: "class,title" — title may contain commas
                var parts = event.data.split(",");
                root.windowClass = parts[0] ?? "";
                root.windowTitle = parts.slice(1).join(",") ?? "";
            }
            if (event.name === "closewindow") {
                root.windowClass = "";
                root.windowTitle = "";
            }
        }
    }
}
