import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire

Item {
    id: root
    implicitWidth: volText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    // ── Pipewire native binding for current volume/mute ───────────────────────
    property PwNode sink: Pipewire.defaultAudioSink
    PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property string icon: muted ? "󰖁" : volume < 0.33 ? "󰕿" : volume < 0.67 ? "󰖀" : "󰕾"

    // ── Sink list from wpctl ──────────────────────────────────────────────────
    property var sinkList: []
    property int defaultSinkId: -1

    Text {
        id: volText
        anchors.centerIn: parent
        text: root.muted ? root.icon + " muted" : root.icon + " " + Math.round(root.volume * 100) + "%"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.mauve
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (root.sink?.audio)
                root.sink.audio.muted = !root.sink.audio.muted;
        }
        onPressAndHold: wiremixToggle.toggle()
        onWheel: {
            if (!root.sink?.audio)
                return;
            var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0.0, Math.min(1.5, root.sink.audio.volume + delta));
        }
    }

    WindowToggle {
        id: wiremixToggle
        windowClass: "wiremix"
        launchCommand: ["kitty", "--class", "wiremix", "-T", "wiremix", "-e", "wiremix"]
    }

    // ── Sink list parsing ─────────────────────────────────────────────────────
    Process {
        id: sinksProc
        command: ["bash", "-c", "wpctl status | sed -n '/├─ Sinks:/,/├─ Sources:/p'"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            var lines = sinksProc.stdout.buffer.split("\n");
            var sinks = [];
            var defaultId = -1;
            for (var i = 0; i < lines.length; i++) {
                // Match: " │  *   86. Bose Mini II SoundLink              [vol: 0.73]"
                // or:    " │      52. Laptop audio out                     [vol: 1.00]"
                var m = lines[i].match(/^\s*│\s*(\*?)\s*(\d+)\.\s+(.+?)\s*\[vol:/);
                if (m) {
                    var id = parseInt(m[2]);
                    var name = m[3].trim();
                    var isDefault = m[1] === "*";
                    sinks.push({
                        id: id,
                        name: name
                    });
                    if (isDefault)
                        defaultId = id;
                }
            }
            root.sinkList = sinks;
            root.defaultSinkId = defaultId;
            sinksProc.stdout.buffer = "";
        }
    }

    // Refresh sinks every 5 seconds and on demand.
    // Pipewire doesn't expose sink list changes via the native binding,
    // so this is the simplest reliable approach.
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: sinksProc.running = true
    }

    // ── Popover ───────────────────────────────────────────────────────────────
    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 320
        popHeight: volPopCol.implicitHeight + 28

        ColumnLayout {
            id: volPopCol
            anchors.fill: parent
            spacing: 10

            // Volume header
            RowLayout {
                Text {
                    text: root.icon
                    font.pixelSize: 22
                    font.family: Style.font
                    color: root.muted ? Mocha.overlay0 : Mocha.mauve
                }
                Text {
                    text: root.muted ? "Muted" : Math.round(root.volume * 100) + "%"
                    font.pixelSize: Style.fontSize
                    font.family: Style.font
                    font.bold: true
                    color: Mocha.text
                    Layout.fillWidth: true
                }
                Rectangle {
                    width: 28
                    height: 20
                    radius: 10
                    color: root.muted ? Qt.rgba(Mocha.red.r, Mocha.red.g, Mocha.red.b, 0.3) : Mocha.surface1
                    Text {
                        anchors.centerIn: parent
                        text: root.muted ? "󰖁" : "󰕾"
                        font.pixelSize: 11
                        font.family: Style.font
                        color: Mocha.text
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.sink?.audio)
                                root.sink.audio.muted = !root.sink.audio.muted;
                        }
                    }
                }
            }

            // Volume slider
            Item {
                Layout.fillWidth: true
                height: 16
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Mocha.surface1
                    Rectangle {
                        width: parent.width * Math.min(root.volume, 1.0)
                        height: parent.height
                        radius: parent.radius
                        color: root.muted ? Mocha.overlay0 : Mocha.mauve
                        Behavior on width {
                            NumberAnimation {
                                duration: 80
                            }
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.sink?.audio)
                            root.sink.audio.volume = Math.max(0, Math.min(1.5, mouseX / width));
                    }
                    onPositionChanged: {
                        if (pressed && root.sink?.audio)
                            root.sink.audio.volume = Math.max(0, Math.min(1.5, mouseX / width));
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Mocha.pillBorder
            }

            Text {
                text: "Output devices"
                color: Mocha.subtext0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
            }

            Repeater {
                model: root.sinkList
                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    radius: 8
                    color: modelData.id === root.defaultSinkId ? Qt.rgba(Mocha.mauve.r, Mocha.mauve.g, Mocha.mauve.b, 0.2) : "transparent"
                    border.color: modelData.id === root.defaultSinkId ? Mocha.mauve : "transparent"
                    border.width: 1

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 8
                            rightMargin: 8
                        }
                        Text {
                            text: modelData.id === root.defaultSinkId ? "󰓃 " : "  "
                            color: Mocha.mauve
                            font.pixelSize: 12
                            font.family: Style.font
                        }
                        Text {
                            text: modelData.name
                            color: Mocha.text
                            font.pixelSize: Style.fontSizeS
                            font.family: Style.font
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.createQmlObject('import Quickshell.Io; Process { command: ["wpctl", "set-default", "' + modelData.id + '"]; running: true }', root);
                            root.defaultSinkId = modelData.id;
                            sinksProc.running = true;
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Mocha.pillBorder
            }

            Text {
                text: "Click — mute   •   Scroll — volume\nHold — wiremix"
                color: Mocha.overlay0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
