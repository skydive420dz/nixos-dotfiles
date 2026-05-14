import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

ColumnLayout {
    id: root

    property string hoveredModule: ""
    property var volModule

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    spacing: 10
    opacity: hoveredModule === "volume" ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    RowLayout {
        Text {
            text: root.volModule.icon
            font.pixelSize: 22
            font.family: Style.font
            color: root.volModule.muted ? Mocha.overlay0 : Mocha.mauve
        }
        Text {
            text: root.volModule.muted ? "Muted" : Math.round(root.volModule.volume * 100) + "%"
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
            color: root.volModule.muted ? Qt.rgba(Mocha.red.r, Mocha.red.g, Mocha.red.b, 0.3) : Mocha.surface1
            Text {
                anchors.centerIn: parent
                text: root.volModule.muted ? "󰖁" : "󰕾"
                font.pixelSize: 11
                font.family: Style.font
                color: Mocha.text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (root.volModule.sink?.audio)
                        root.volModule.sink.audio.muted = !root.volModule.sink.audio.muted;
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
                width: parent.width * Math.min(root.volModule.volume, 1.0)
                height: parent.height
                radius: parent.radius
                color: root.volModule.muted ? Mocha.overlay0 : Mocha.mauve
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
                if (root.volModule.sink?.audio)
                    root.volModule.sink.audio.volume = Math.max(0, Math.min(1.5, mouseX / width));
            }
            onPositionChanged: {
                if (pressed && root.volModule.sink?.audio)
                    root.volModule.sink.audio.volume = Math.max(0, Math.min(1.5, mouseX / width));
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
        model: Pipewire.nodes.values.filter(n => n.isSink && n.audio !== null && !n.isStream)
        delegate: Rectangle {
            id: sinkDelegate
            required property PwNode modelData
            readonly property bool isDefault: modelData.id === Pipewire.defaultAudioSink?.id

            Layout.fillWidth: true
            height: 28
            radius: 8
            color: isDefault ? Qt.rgba(Mocha.mauve.r, Mocha.mauve.g, Mocha.mauve.b, 0.2) : "transparent"
            border.color: isDefault ? Mocha.mauve : "transparent"
            border.width: 1

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                }
                Text {
                    text: sinkDelegate.isDefault ? "󰓃 " : "  "
                    color: Mocha.mauve
                    font.pixelSize: 12
                    font.family: Style.font
                }
                Text {
                    text: sinkDelegate.modelData.description || sinkDelegate.modelData.name
                    color: Mocha.text
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Pipewire.preferredDefaultAudioSink = sinkDelegate.modelData
            }
        }
    }
}
