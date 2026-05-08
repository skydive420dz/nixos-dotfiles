import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Item {
    id: root
    implicitWidth: volText.implicitWidth + 8
    implicitHeight: Style.pillHeight
    property bool hovered: hover.containsMouse

    // ── Pipewire native bindings — fully reactive, no polling ─────────────────
    property PwNode sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property string icon: muted ? "󰖁" : volume < 0.33 ? "󰕿" : volume < 0.67 ? "󰖀" : "󰕾"

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
            if (!root.sink?.audio)
                return;
            root.sink.audio.volume = Math.max(0.0, Math.min(1.5, root.sink.audio.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)));
        }
    }

    WindowToggle {
        id: wiremixToggle
        windowClass: "wiremix"
        launchCommand: ["kitty", "--class", "wiremix", "-T", "wiremix", "-e", "wiremix"]
    }

    // ── Popover ───────────────────────────────────────────────────────────────
}
