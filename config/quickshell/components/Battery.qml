import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    implicitWidth: battText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    property int capacity: 100
    property string status: "Unknown"
    property bool charging: false
    property string timeRemain: ""
    property string powerDraw: ""
    property string cycleCount: ""

    readonly property string icon: {
        if (charging)
            return "󰉁";
        if (capacity >= 91)
            return "󰁹";
        if (capacity >= 81)
            return "󰂂";
        if (capacity >= 71)
            return "󰂁";
        if (capacity >= 61)
            return "󰂀";
        if (capacity >= 51)
            return "󰁿";
        if (capacity >= 41)
            return "󰁾";
        if (capacity >= 31)
            return "󰁽";
        if (capacity >= 21)
            return "󰁼";
        if (capacity >= 11)
            return "󰁻";
        return "󰂎";
    }

    readonly property color iconColor: charging ? Mocha.green : capacity <= 15 ? Mocha.red : capacity <= 30 ? Mocha.yellow : Mocha.teal

    Text {
        id: battText
        anchors.centerIn: parent
        text: root.icon + " " + root.capacity + "%"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: root.iconColor
        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
    }

    Process {
        id: battProc
        command: ["bash", "$HOME/.config/scripts/battery-status"]

        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data;
            }
        }

        onExited: {
            try {
                var j = JSON.parse(battProc.stdout.buffer.trim());
                root.capacity = j.cap ?? 100;
                root.status = j.sta ?? "Unknown";
                root.cycleCount = j.cyc ?? "";
                root.powerDraw = j.pwr ?? "";
                root.timeRemain = j.tim ?? "";
                root.charging = root.status === "Charging" || root.status === "Full";
            } catch (e) {}
            battProc.stdout.buffer = "";
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: battProc.running = true
    }

    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 240
        popHeight: battPopCol.implicitHeight + 28

        ColumnLayout {
            id: battPopCol
            anchors.fill: parent
            spacing: 8

            RowLayout {
                Text {
                    text: root.icon
                    font.pixelSize: 22
                    font.family: Style.font
                    color: root.iconColor
                }
                ColumnLayout {
                    spacing: 1
                    Text {
                        text: root.capacity + "%  " + root.status
                        font.pixelSize: Style.fontSize
                        font.family: Style.font
                        font.bold: true
                        color: Mocha.text
                    }
                    Text {
                        visible: root.timeRemain !== ""
                        text: root.charging ? "Full in " + root.timeRemain : root.timeRemain + " remaining"
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        color: Mocha.subtext0
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: 10
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Mocha.surface1
                    Rectangle {
                        width: parent.width * (root.capacity / 100)
                        height: parent.height
                        radius: parent.radius
                        color: root.iconColor
                        Behavior on width {
                            NumberAnimation {
                                duration: 500
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Mocha.pillBorder
            }

            Repeater {
                model: {
                    var rows = [];
                    if (root.powerDraw)
                        rows.push({
                            label: "⚡ Power",
                            value: root.powerDraw
                        });
                    if (root.cycleCount)
                        rows.push({
                            label: "🔄 Cycles",
                            value: root.cycleCount
                        });
                    return rows;
                }
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: modelData.label
                        color: Mocha.subtext0
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        Layout.preferredWidth: 80
                    }
                    Text {
                        text: modelData.value
                        color: Mocha.text
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                    }
                }
            }
        }
    }
}
