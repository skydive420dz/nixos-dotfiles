import QtQuick
import Quickshell.Io
import "../theme"

Item {
    id: root

    implicitWidth: weatherText.implicitWidth + 8
    implicitHeight: Style.pillHeight

    property string display: "󰖐 --"
    property string tip: "Loading weather..."

    Text {
        id: weatherText
        anchors.centerIn: parent
        text: root.display
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.sky

        ToolTip.visible: hover.containsMouse
        ToolTip.text: root.tip
        ToolTip.delay: 400
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
    }

    // ── Data fetching ─────────────────────────────────────────────────────────

    Process {
        id: weatherProc
        // Reuses your existing weather script at its symlinked location
        command: ["bash", "-c", "$HOME/.config/scripts/weather"]

        stdout: SplitParser {
            onRead: data => {
                try {
                    var json = JSON.parse(data.trim());
                    root.display = json.text ?? "󰖐 --";
                    root.tip = json.tooltip ?? "No data";
                } catch (_) {}
            }
        }
    }

    Timer {
        interval: 1800000   // 30 min — same as your waybar interval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProc.running = true
    }
}
