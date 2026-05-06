import ".."
import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick.Controls

Item {
    id: root

    implicitWidth: volText.implicitWidth + 8
    implicitHeight: Style.pillHeight

    // ── Pipewire binding ──────────────────────────────────────────────────────
    property PwNode sink: Pipewire.defaultAudioSink

    // Keep the sink tracked and reactive
    PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0.0

    readonly property string icon: {
        if (muted)
            return "󰖁";
        if (volume < 0.33)
            return "󰕿";
        if (volume < 0.67)
            return "󰖀";
        return "󰕾";
    }

    // ── UI ───────────────────────────────────────────────────────────────────

    Text {
        id: volText
        anchors.centerIn: parent
        text: root.muted ? root.icon + " muted" : root.icon + " " + Math.round(root.volume * 100) + "%"
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.mauve

        ToolTip.visible: hover.containsMouse
        ToolTip.text: root.muted ? "Muted" : Math.round(root.volume * 100) + "% — scroll to adjust"
        ToolTip.delay: 400
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true

        // Left click  → mute/unmute
        onClicked: {
            if (root.sink?.audio)
                root.sink.audio.muted = !root.sink.audio.muted;
        }

        // Right click → open wiremix mixer
        onPressAndHold: wiremixProc.running = true

        // Scroll → adjust volume ±5% (capped at 150% for boost)
        onWheel: {
            if (!root.sink?.audio)
                return;
            var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0.0, Math.min(1.5, root.sink.audio.volume + delta));
        }
    }

    Process {
        id: wiremixProc
        command: ["kitty", "--class", "wiremix", "-T", "wiremix", "-e", "wiremix"]
        running: false
    }
}
