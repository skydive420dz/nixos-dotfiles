import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

Rectangle {
    id: root

    implicitWidth: Math.min(titleText.implicitWidth + Theme.pad * 2, 360)
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.maximumWidth: 360
    Layout.alignment: Qt.AlignVCenter

    radius: Theme.radius
    color: Theme.panel
    border.color: Theme.border
    border.width: 1
    clip: true

    property string activeClass: ""
    property string activeTitle: ""

    function windowLabel() {
        if (!activeTitle)
            return "Desktop";

        var klass = activeClass.toLowerCase();
        if (klass.indexOf("firefox") >= 0)
            return activeTitle.replace(/ [—–] Mozilla Firefox$/, "").replace(/ Mozilla Firefox$/, "");
        if (klass === "kitty")
            return "Terminal";
        if (klass === "vesktop" || klass === "discord")
            return "Discord";
        return activeTitle;
    }

    function loadActiveWindow(payload) {
        try {
            var win = JSON.parse(payload.trim());
            root.activeClass = win.class ?? "";
            root.activeTitle = win.title ?? "";
        } catch (e) {
            root.activeClass = "";
            root.activeTitle = "";
        }
    }

    Component.onCompleted: activeWindowProc.running = true

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activewindow") {
                var active = event.data.split(",");
                root.activeClass = active[0] ?? "";
                root.activeTitle = active.slice(1).join(",") ?? "";
            } else if (event.name === "closewindow") {
                root.activeClass = "";
                root.activeTitle = "";
            }
        }
    }

    Process {
        id: activeWindowProc
        command: ["hyprctl", "activewindow", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            root.loadActiveWindow(stdout.buffer);
            stdout.buffer = "";
        }
    }

    Text {
        id: titleText
        anchors.centerIn: parent
        width: Math.min(implicitWidth, parent.width - Theme.pad * 2)
        text: root.windowLabel()
        elide: Text.ElideRight
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
    }
}
