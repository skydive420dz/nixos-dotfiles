import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.UPower

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-osd"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: root.showing
    color: "transparent"

    mask: Region {
        item: pillMask
    }

    property bool showing: false
    property string kind: "volume"
    property string icon: "󰕾"
    property string title: "Volume"
    property int value: -1
    property color accent: Mocha.accent
    property bool initializedBattery: false
    property bool lastOnBattery: UPower.onBattery

    Item {
        id: pillMask
        x: pill.x
        y: pill.y
        width: root.showing ? pill.width : 0
        height: root.showing ? pill.height : 0
    }

    function accentFor(kindName) {
        if (kindName === "brightness")
            return Mocha.yellow;
        if (kindName === "battery")
            return UPower.onBattery ? Mocha.teal : Mocha.green;
        if (kindName === "mute")
            return Mocha.red;
        return Mocha.accent;
    }

    function show(payload) {
        kind = payload.kind || "volume";
        icon = payload.icon || "󰕾";
        title = payload.title || "";
        value = payload.value === undefined ? -1 : payload.value;
        accent = accentFor(kind);
        showing = true;
        hideTimer.restart();
    }

    function showBatteryChange(onBattery) {
        show({
            "kind": "battery",
            "icon": onBattery ? "󰁹" : "󰚥",
            "title": onBattery ? "On battery" : "Power connected",
            "value": -1
        });
    }

    FileView {
        id: osdSignal
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-osd-signal"
        watchChanges: true
        printErrors: false
        onFileChanged: readProc.running = true
    }

    Process {
        id: readProc
        command: ["bash", "-lc", "cat \"$XDG_RUNTIME_DIR/qs-osd.json\" 2>/dev/null"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            try {
                root.show(JSON.parse(stdout.buffer.trim()));
            } catch (e) {
            }
            stdout.buffer = "";
        }
    }

    Connections {
        target: UPower

        function onOnBatteryChanged() {
            if (!root.initializedBattery) {
                root.initializedBattery = true;
                root.lastOnBattery = UPower.onBattery;
                return;
            }
            if (root.lastOnBattery === UPower.onBattery)
                return;
            root.lastOnBattery = UPower.onBattery;
            root.showBatteryChange(UPower.onBattery);
        }
    }

    Component.onCompleted: {
        initializedBattery = true;
        lastOnBattery = UPower.onBattery;
    }

    Timer {
        id: hideTimer
        interval: 1200
        onTriggered: root.showing = false
    }

    Rectangle {
        id: pill
        width: Math.min(340, root.width - 48)
        height: 76
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: Style.pillRadius
        color: Mocha.panelBg
        border.color: Mocha.panelBorder
        border.width: 1
        opacity: root.showing ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Style.animPanel
                easing.type: Style.easeOut
            }
        }

        RowLayout {
            visible: root.value >= 0
            anchors.fill: parent
            anchors.leftMargin: Style.pillPadH
            anchors.rightMargin: Style.pillPadH
            spacing: 14

            Text {
                text: root.icon
                color: root.accent
                font.family: Style.font
                font.pixelSize: 28
                Layout.preferredWidth: 34
                horizontalAlignment: Text.AlignHCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 7

                Text {
                    Layout.fillWidth: true
                    text: root.title
                    color: Mocha.text
                    font.family: Style.font
                    font.pixelSize: 15
                    elide: Text.ElideRight
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 7
                    radius: 4
                    color: Mocha.rowSelected
                    visible: root.value >= 0

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * Math.max(0, Math.min(root.value, 100)) / 100
                        radius: parent.radius
                        color: root.accent

                        Behavior on width {
                            NumberAnimation {
                                duration: Style.animFast
                                easing.type: Style.easeOut
                            }
                        }
                    }
                }
            }

            Text {
                visible: root.value >= 0
                text: root.value + "%"
                color: Mocha.subtext0
                font.family: Style.font
                font.pixelSize: 14
                Layout.preferredWidth: 44
                horizontalAlignment: Text.AlignRight
            }
        }

        RowLayout {
            visible: root.value < 0
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: root.icon
                color: root.accent
                font.family: Style.font
                font.pixelSize: 28
            }

            Text {
                text: root.title
                color: Mocha.text
                font.family: Style.font
                font.pixelSize: 16
            }
        }
    }
}
