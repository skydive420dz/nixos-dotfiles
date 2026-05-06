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
    property string deviceAddr: ""
    property int deviceBatt: -1
    property var pairedDevices: []

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

    // ── Refresh trigger ───────────────────────────────────────────────────────
    function refresh() {
        powerProc.running = true;
        connectedProc.running = true;
        pairedProc.running = true;
    }

    // ── Power state ───────────────────────────────────────────────────────────
    Process {
        id: powerProc
        command: ["bash", "-c", "echo -e 'show\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            var match = powerProc.stdout.buffer.match(/PowerState:\s*(\S+)/);
            root.powerState = match ? match[1] : "off";
            powerProc.stdout.buffer = "";
            updateIcon();
        }
    }

    // ── Connected device ──────────────────────────────────────────────────────
    Process {
        id: connectedProc
        command: ["bash", "-c", "echo -e 'devices Connected\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            // Find first "Device <addr> <name>" line
            var match = connectedProc.stdout.buffer.match(/^Device\s+(\S+)\s+(.+)$/m);
            if (match) {
                root.deviceAddr = match[1];
                root.deviceName = match[2].trim();
                battProc.running = true;
            } else {
                root.deviceAddr = "";
                root.deviceName = "";
                root.deviceBatt = -1;
            }
            connectedProc.stdout.buffer = "";
            updateIcon();
        }
    }

    // ── Battery for connected device ──────────────────────────────────────────
    Process {
        id: battProc
        command: ["bash", "-c", "echo -e 'info " + root.deviceAddr + "\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            // Format: "Battery Percentage: 0x5a (90)"
            var match = battProc.stdout.buffer.match(/Battery Percentage:[^(]*\((\d+)\)/);
            root.deviceBatt = match ? parseInt(match[1]) : -1;
            battProc.stdout.buffer = "";
        }
    }

    // ── Paired devices list ───────────────────────────────────────────────────
    Process {
        id: pairedProc
        command: ["bash", "-c", "echo -e 'devices Paired\\nexit' | bluetoothctl"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }
        onExited: {
            var lines = pairedProc.stdout.buffer.split("\n");
            var devices = [];
            for (var i = 0; i < lines.length; i++) {
                var m = lines[i].match(/^Device\s+(\S+)\s+(.+)$/);
                if (m)
                    devices.push({
                        addr: m[1],
                        name: m[2].trim()
                    });
            }
            root.pairedDevices = devices;
            pairedProc.stdout.buffer = "";
        }
    }

    function updateIcon() {
        if (root.powerState !== "on")
            root.icon = "󰂲";
        else if (root.deviceName)
            root.icon = "󰂱";
        else
            root.icon = "󰂰";
    }

    // ── Event-driven — bluetoothctl monitor ───────────────────────────────────
    Process {
        id: btMonitor
        command: ["bluetoothctl", "monitor"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim();
                if (line.includes("Connected") || line.includes("PowerState") || line.includes("Battery")) {
                    root.refresh();
                }
            }
        }
    }

    Process {
        id: rfkillProc
        command: ["rfkill", "toggle", "bluetooth"]
        running: false
        onExited: root.refresh()
    }

    Component.onCompleted: root.refresh()

    // ── Popover ───────────────────────────────────────────────────────────────
    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 260
        popHeight: btPopCol.implicitHeight + 28

        ColumnLayout {
            id: btPopCol
            anchors.fill: parent
            spacing: 8

            // Header
            RowLayout {
                Text {
                    text: root.icon
                    font.pixelSize: 20
                    font.family: Style.font
                    color: root.powerState !== "on" ? Mocha.overlay0 : Mocha.teal
                }
                Text {
                    text: root.powerState !== "on" ? "Bluetooth Off" : root.deviceName ? root.deviceName : "No device connected"
                    font.pixelSize: Style.fontSize
                    font.family: Style.font
                    font.bold: true
                    color: Mocha.text
                }
            }

            // Connected device battery
            RowLayout {
                visible: root.deviceBatt >= 0
                Text {
                    text: "🔋 Battery"
                    color: Mocha.subtext0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.preferredWidth: 70
                }
                Text {
                    text: root.deviceBatt + "%"
                    color: Mocha.text
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
            }

            Rectangle {
                visible: root.pairedDevices.length > 0
                Layout.fillWidth: true
                height: 1
                color: Mocha.pillBorder
            }

            Text {
                visible: root.pairedDevices.length > 0
                text: "Paired devices"
                color: Mocha.subtext0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
            }

            Repeater {
                model: root.pairedDevices
                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    radius: 8
                    color: modelData.addr === root.deviceAddr ? Qt.rgba(Mocha.teal.r, Mocha.teal.g, Mocha.teal.b, 0.2) : "transparent"
                    border.color: modelData.addr === root.deviceAddr ? Mocha.teal : "transparent"
                    border.width: 1

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 8
                            rightMargin: 8
                        }
                        Text {
                            text: modelData.addr === root.deviceAddr ? "󰂱 " : "󰂯 "
                            color: Mocha.teal
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
                            var action = modelData.addr === root.deviceAddr ? "disconnect" : "connect";
                            Qt.createQmlObject('import Quickshell.Io; Process { command: ["bluetoothctl", "' + action + '", "' + modelData.addr + '"]; running: true }', root);
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
