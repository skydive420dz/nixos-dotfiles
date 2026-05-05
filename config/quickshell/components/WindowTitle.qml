import QtQuick
import Quickshell.Io

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

    // Poll hyprctl for the active window every 500ms.
    // Once we confirm the working Hyprland API we can switch this to
    // a reactive Connections { target: Hyprland } block instead.
    Process {
        id: winProc
        command: ["hyprctl", "activewindow", "-j"]

        stdout: SplitParser {
            onRead: data => {
                try {
                    var obj = JSON.parse(data.trim());
                    root.windowClass = obj.class || "";
                    root.windowTitle = obj.title || "";
                } catch (_) {
                    root.windowClass = "";
                    root.windowTitle = "";
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: winProc.running = true
    }
}
