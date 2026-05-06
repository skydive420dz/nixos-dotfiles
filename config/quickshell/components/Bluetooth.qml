import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    implicitWidth: btText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    property string icon: "󰂯"
    property string powerState: "off"
    property string deviceName: ""
    property string deviceBatt: ""

    Text {
        id: btText
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
        onClicked: bluetuiToggle.toggle()
        onPressAndHold: rfkillProc.running = true
    }

    WindowToggle {
        id: bluetuiToggle
        windowClass: "bluetui"
        launchCommand: ["kitty", "--class", "bluetui", "-T", "bluetui", "-e", "bluetui"]
    }

    Process {
        id: btProc
        command: ["bash", "-c", ["power=$(bluetoothctl show | awk '/PowerState/ {print $2}')", "addr=$(bluetoothctl devices Connected | awk '{print $2}' | head -1)", "name=$(bluetoothctl devices Connected | cut -d' ' -f3- | head -1)", "batt=$([ -n \"$addr\" ] && bluetoothctl info \"$addr\" 2>/dev/null | awk '/Battery Percentage/ {gsub(/[()]/,\"\"); print $NF}' || echo '')", "echo \"$power|$name|$batt\""].join("; ")]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split("|");
                root.powerState = p[0] ?? "off";
                root.deviceName = (p[1] ?? "").trim();
                root.deviceBatt = (p[2] ?? "").trim();
                root.icon = root.powerState === "off" || root.powerState === "off-blocked" ? "󰂲" : root.deviceName ? "󰂱" : "󰂰";
            }
        }
    }

    Process {
        id: rfkillProc
        command: ["rfkill", "toggle", "bluetooth"]
        running: false
        onExited: btProc.running = true
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: btProc.running = true
    }

    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 240
        popHeight: btPopCol.implicitHeight + 28

        ColumnLayout {
            id: btPopCol
            anchors.fill: parent
            spacing: 8

            RowLayout {
                Text {
                    text: root.icon
                    font.pixelSize: 20
                    font.family: Style.font
                    color: root.powerState === "off" ? Mocha.overlay0 : Mocha.teal
                }
                Text {
                    text: root.powerState === "off" ? "Bluetooth Off" : root.deviceName ? root.deviceName : "No device connected"
                    font.pixelSize: Style.fontSize
                    font.family: Style.font
                    font.bold: true
                    color: Mocha.text
                }
            }

            RowLayout {
                visible: root.deviceBatt !== ""
                Text {
                    text: "🔋 Device battery"
                    color: Mocha.subtext0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.preferredWidth: 110
                }
                Text {
                    text: root.deviceBatt + "%"
                    color: Mocha.text
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Mocha.pillBorder
            }

            Text {
                text: "Click — bluetui   •   Hold — toggle power"
                color: Mocha.overlay0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
