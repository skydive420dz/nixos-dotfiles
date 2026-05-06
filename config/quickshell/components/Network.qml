import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    implicitWidth: netText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    property string icon: "󰤟"
    property string ssid: ""
    property string ipAddr: ""
    property string iface: ""
    property int signal: 0
    property string connType: ""

    Text {
        id: netText
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.teal
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: nmtuiToggle.toggle()
    }

    WindowToggle {
        id: nmtuiToggle
        windowClass: "nmtui"
        launchCommand: ["kitty", "--class", "nmtui", "-T", "nmtui", "-e", "nmtui"]
    }

    Process {
        id: netProc
        command: ["bash", "$HOME/.config/scripts/net-status"]

        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data;
            }
        }

        onExited: {
            try {
                var j = JSON.parse(netProc.stdout.buffer.trim());
                root.iface = j.iface ?? "";
                root.connType = j.type ?? "";
                root.ipAddr = j.ip ?? "";
                root.ssid = j.ssid ?? "";
                root.signal = j.signal ?? 0;
                if (j.state !== "connected") {
                    root.icon = "󰤯";
                    root.connType = "disconnected";
                } else if (j.type === "ethernet") {
                    root.icon = "󰈀";
                } else {
                    root.icon = root.signal > 75 ? "󰤨" : root.signal > 50 ? "󰤥" : root.signal > 25 ? "󰤢" : "󰤟";
                }
            } catch (e) {}
            netProc.stdout.buffer = "";
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 240
        popHeight: netPopCol.implicitHeight + 28

        ColumnLayout {
            id: netPopCol
            anchors.fill: parent
            spacing: 8

            RowLayout {
                Text {
                    text: root.connType === "wifi" ? "󰤨" : root.connType === "ethernet" ? "󰈀" : "󰤯"
                    font.pixelSize: 20
                    font.family: Style.font
                    color: Mocha.teal
                }
                Text {
                    text: root.connType === "wifi" ? root.ssid : root.connType === "ethernet" ? "Ethernet" : "Disconnected"
                    font.pixelSize: Style.fontSize
                    font.family: Style.font
                    font.bold: true
                    color: Mocha.text
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
                    if (root.ipAddr)
                        rows.push({
                            label: "IP",
                            value: root.ipAddr
                        });
                    if (root.iface)
                        rows.push({
                            label: "Interface",
                            value: root.iface
                        });
                    if (root.connType === "wifi")
                        rows.push({
                            label: "Signal",
                            value: root.signal + "%"
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
                        Layout.preferredWidth: 70
                    }
                    Text {
                        text: modelData.value
                        color: Mocha.text
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        Layout.fillWidth: true
                    }
                }
            }

            Text {
                text: "Click to open nmtui"
                color: Mocha.overlay0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
