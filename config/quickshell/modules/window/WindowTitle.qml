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
    color: "transparent"
    border.color: "transparent"
    border.width: 0
    clip: true

    property string activeClass: ""
    property string activeTitle: ""
    property bool activeWindowRefreshPending: false
    property int activeWindowRevision: 0

    function windowLabel() {
        if (!activeTitle)
            return "Desktop";

        var klass = activeClass.toLowerCase();
        if (klass.indexOf("firefox") >= 0)
            return activeTitle.replace(/ [—–] Mozilla Firefox$/, "").replace(/ Mozilla Firefox$/, "");
        if (klass === "ghostty" || klass.indexOf("ghostty") >= 0)
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

    function scheduleActiveWindowRefresh() {
        root.activeWindowRevision++;
        root.activeWindowRefreshPending = true;
        activeWindowRefreshTimer.restart();
    }

    Component.onCompleted: {
        activeWindowProc.requestRevision = root.activeWindowRevision;
        activeWindowProc.running = true;
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activewindow") {
                root.activeWindowRevision++;
                root.activeWindowRefreshPending = false;
                activeWindowRefreshTimer.stop();
                var active = event.data.split(",");
                root.activeClass = active[0] ?? "";
                root.activeTitle = active.slice(1).join(",") ?? "";
            } else if (event.name === "closewindow") {
                root.scheduleActiveWindowRefresh();
            }
        }
    }

    Timer {
        id: activeWindowRefreshTimer
        interval: 100
        repeat: false
        onTriggered: {
            if (activeWindowProc.running)
                return;

            root.activeWindowRefreshPending = false;
            activeWindowProc.requestRevision = root.activeWindowRevision;
            activeWindowProc.running = true;
        }
    }

    Process {
        id: activeWindowProc
        property int requestRevision: 0
        command: ["hyprctl", "activewindow", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            if (!root.activeWindowRefreshPending && requestRevision === root.activeWindowRevision)
                root.loadActiveWindow(stdout.buffer);
            stdout.buffer = "";
            if (root.activeWindowRefreshPending)
                activeWindowRefreshTimer.restart();
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
