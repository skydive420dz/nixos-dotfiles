import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

PopoverPanel {
    id: root

    property var volModule
    moduleName: "volume"
    spacing: 10

    RowLayout {
        Text {
            text: root.volModule.icon
            font.pixelSize: 22
            font.family: Style.font
            color: root.volModule.muted ? Mocha.overlay0 : Mocha.accent
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
            radius: Style.pillRadius
            color: root.volModule.muted ? Mocha.statusMutedBg : Mocha.iconBg
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
            color: Mocha.rowSelected
            Rectangle {
                width: parent.width * Math.min(root.volModule.volume, 1.0)
                height: parent.height
                radius: parent.radius
                color: root.volModule.muted ? Mocha.overlay0 : Mocha.accent
                Behavior on width {
                    NumberAnimation {
                        duration: Style.animFast
                        easing.type: Style.easeOut
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

    Divider {}

    SectionLabel {
        label: "Output devices"
    }

    Repeater {
        model: Pipewire.nodes.values.filter(n => n.isSink && n.audio !== null && !n.isStream)
        delegate: SelectableRow {
            id: sinkDelegate
            required property PwNode modelData
            readonly property bool isDefault: modelData.id === Pipewire.defaultAudioSink?.id

            selected: isDefault
            icon: isDefault ? "󰓃" : ""
            label: modelData.description || modelData.name
            accent: Mocha.accent
            onActivated: Pipewire.preferredDefaultAudioSink = sinkDelegate.modelData
        }
    }
}
