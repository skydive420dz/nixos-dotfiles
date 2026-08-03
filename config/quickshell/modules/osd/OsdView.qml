import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    anchors.fill: parent

    property alias maskItem: card
    property bool showing: false
    property string icon: ""
    property string title: ""
    property int value: -1

    FileView {
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-osd-signal"
        watchChanges: true
        printErrors: false
        onFileChanged: loadProc.running = true
    }

    Process {
        id: loadProc
        command: ["bash", "-lc", "cat \"${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/qs-osd.json\" 2>/dev/null || true"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data
        }
        onExited: {
            try {
                var payload = JSON.parse(stdout.buffer.trim());
                root.icon = payload.icon ?? "";
                root.title = payload.title ?? "";
                root.value = payload.value ?? -1;
                root.showing = true;
                hideTimer.restart();
            } catch (e) {}
            stdout.buffer = "";
        }
    }

    Timer {
        id: hideTimer
        interval: 900
        repeat: false
        onTriggered: root.showing = false
    }

    Rectangle {
        id: card
        width: 260
        height: root.value >= 0 ? 88 : 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Theme.barHeight + 10
        radius: Theme.radius
        color: Theme.panel
        border.color: Theme.border
        border.width: 1
        opacity: root.showing ? 1 : 0

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Text {
                    text: root.icon
                    color: Theme.accent
                    font.family: Theme.font
                    font.pixelSize: 22
                }

                Text {
                    Layout.preferredWidth: Math.min(implicitWidth, 180)
                    text: root.title
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize + 2
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                visible: root.value >= 0
                Layout.fillWidth: true
                Layout.preferredHeight: 5
                radius: 3
                color: Theme.bg

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(root.value, 100)) / 100
                    height: parent.height
                    radius: parent.radius
                    color: Theme.accent
                }
            }
        }
    }
}
