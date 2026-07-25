import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    Layout.preferredWidth: 54
    Layout.preferredHeight: Theme.pillHeight - 10

    property bool active: false
    property int tick: 0
    property var levels: []
    property double lastSampleMs: 0
    readonly property int sampleFreshnessMs: 500
    readonly property bool hasLiveLevels: active && lastSampleMs > 0 && levels.length > 0

    function clearLiveLevels() {
        sampleFreshnessTimer.stop();
        lastSampleMs = 0;
        levels = [];
    }

    function acceptLiveLevels(nextLevels, sampleMs) {
        if (!active || nextLevels.length === 0)
            return false;

        var receivedAt = Number(sampleMs);
        if (!Number.isFinite(receivedAt) || receivedAt <= 0)
            receivedAt = Date.now();

        lastSampleMs = receivedAt;
        levels = nextLevels;
        sampleFreshnessTimer.interval = sampleFreshnessMs;
        sampleFreshnessTimer.restart();
        return true;
    }

    function applyCavaSample(data, sampleMs) {
        var payload = (data || "").trim();
        if (payload.length === 0)
            return false;

        var parts = payload.split(";");
        var nextLevels = [];

        for (var i = 0; i < parts.length; i++) {
            var value = Number(parts[i]);
            if (Number.isFinite(value))
                nextLevels.push(Math.max(0, Math.min(value / 100, 1)));
        }

        return acceptLiveLevels(nextLevels, sampleMs);
    }

    function expireLiveLevels(checkMs) {
        var now = Number(checkMs);
        if (!Number.isFinite(now) || now <= 0)
            now = Date.now();

        var age = Math.max(0, now - lastSampleMs);
        if (lastSampleMs <= 0 || age >= sampleFreshnessMs) {
            clearLiveLevels();
            return;
        }

        sampleFreshnessTimer.interval = Math.max(1, Math.ceil(sampleFreshnessMs - age));
        sampleFreshnessTimer.restart();
    }

    Timer {
        interval: 90
        repeat: true
        running: root.active && !root.hasLiveLevels
        onTriggered: {
            root.tick = (root.tick + 1) % 360;
            spectrum.requestPaint();
        }
    }

    // CAVA emits 24 rows/s; 500 ms tolerates roughly 12 missed rows.
    Timer {
        id: sampleFreshnessTimer
        interval: root.sampleFreshnessMs
        onTriggered: root.expireLiveLevels(Date.now())
    }

    onActiveChanged: {
        root.clearLiveLevels();
        spectrum.requestPaint();
    }

    onLevelsChanged: spectrum.requestPaint()

    Process {
        id: cavaProc

        running: root.active
        command: ["cava", "-p", Quickshell.shellPath("modules/media/cava.conf")]

        stdout: SplitParser {
            onRead: data => root.applyCavaSample(data)
        }

        onExited: root.clearLiveLevels()
    }

    Canvas {
        id: spectrum

        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var columns = 12;
            var step = width / (columns - 1);
            var baseline = height - 2;
            var maxHeight = height - 4;

            for (var i = 0; i < columns; i++) {
                var live = root.hasLiveLevels ? (Number(root.levels[i]) || 0) : -1;
                var wave = live >= 0 ? live : root.active ? Math.abs(Math.sin((root.tick + i * 31) / 18)) : 0;
                var pulse = live >= 0 ? live : root.active ? Math.abs(Math.sin((root.tick + i * 17) / 23)) : 0;
                var peak = 3 + wave * maxHeight;
                var dots = Math.max(1, Math.round(peak / 3));
                var x = i * step;

                ctx.fillStyle = Theme.accent;
                for (var j = 0; j < dots; j++) {
                    var progress = dots <= 1 ? 1 : j / (dots - 1);
                    var y = baseline - j * 3;
                    var radius = 0.8 + progress * 0.35;

                    ctx.globalAlpha = root.active ? 0.20 + progress * 0.45 + pulse * 0.25 : 0.16;
                    ctx.beginPath();
                    ctx.arc(x, y, radius, 0, Math.PI * 2);
                    ctx.fill();
                }
            }
        }
    }
}
