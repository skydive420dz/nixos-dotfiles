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

    property PwNode sink: Pipewire.defaultAudioSink
    PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property string icon: muted ? "󰖁" : volume < 0.33 ? "󰕿" : volume < 0.67 ? "󰖀" : "󰕾"

    property var sinkList: []
    property string defaultSinkName: ""

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
            if (root.sink?.audio)
                root.sink.audio.volume = Math.max(0.0, Math.min(1.5, root.sink.audio.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)));
        }
    }

    WindowToggle {
        id: wiremixToggle
        windowClass: "wiremix"
        launchCommand: ["kitty", "--class", "wiremix", "-T", "wiremix", "-e", "wiremix"]
    }

    Process {
        id: sinksProc
        command: ["bash", "-c", "pactl list sinks | awk '/Name:/ {name=$2} /Description:/ {desc=substr($0,index($0,$2)); print name \"|\" desc}'"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data;
            }
        }
        onExited: {
            var lines = sinksProc.stdout.buffer.trim().split("\n");
            var result = [];
            lines.forEach(function (line) {
                var parts = line.split("|");
                if (parts.length >= 2)
                    result.push({
                        name: parts[0].trim(),
                        desc: parts[1].trim()
                    });
            });
            root.sinkList = result;
            sinksProc.stdout.buffer = "";
        }
    }

    Process {
        id: defaultSinkProc
        command: ["bash", "-c", "pactl get-default-sink"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data;
            }
        }
        onExited: {
            root.defaultSinkName = defaultSinkProc.stdout.buffer.trim();
            defaultSinkProc.stdout.buffer = "";
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            sinksProc.running = true;
            defaultSinkProc.running = true;
        }
    }

    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 280
        popHeight: volPopCol.implicitHeight + 28

        ColumnLayout {
            id: volPopCol
            anchors.fill: parent
            spacing: 10

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
                    color: modelData.name === root.defaultSinkName ? Qt.rgba(Mocha.mauve.r, Mocha.mauve.g, Mocha.mauve.b, 0.2) : "transparent"
                    border.color: modelData.name === root.defaultSinkName ? Mocha.mauve : "transparent"
                    border.width: 1
                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 8
                            rightMargin: 8
                        }
                        Text {
                            text: modelData.name === root.defaultSinkName ? "󰓃 " : "  "
                            color: Mocha.mauve
                            font.pixelSize: 12
                            font.family: Style.font
                        }
                        Text {
                            text: modelData.desc
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
                            Qt.createQmlObject('import Quickshell.Io; Process { command: ["pactl","set-default-sink","' + modelData.name + '"]; running: true }', root);
                            root.defaultSinkName = modelData.name;
                        }
                    }
                }
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
