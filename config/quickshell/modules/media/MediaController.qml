import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Scope {
    id: root

    property MprisPlayer mediaPlayer: {
        var players = Mpris.players.values;
        for (var i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing)
                return players[i];
        }
        for (var j = 0; j < players.length; j++) {
            if (players[j].playbackState === MprisPlaybackState.Paused)
                return players[j];
        }
        return null;
    }

    readonly property bool analyzerActive: mediaPlayer?.playbackState === MprisPlaybackState.Playing
    property var levels: []
    property double lastSampleMs: 0
    readonly property int sampleFreshnessMs: 500

    function clearLiveLevels() {
        sampleFreshnessTimer.stop();
        lastSampleMs = 0;
        levels = [];
    }

    function acceptLiveLevels(nextLevels, sampleMs) {
        if (!analyzerActive || nextLevels.length === 0)
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

    function playPause() {
        mediaPlayer?.togglePlaying();
    }

    // CAVA emits 24 rows/s; 500 ms tolerates roughly 12 missed rows.
    Timer {
        id: sampleFreshnessTimer
        interval: root.sampleFreshnessMs
        onTriggered: root.expireLiveLevels(Date.now())
    }

    onAnalyzerActiveChanged: root.clearLiveLevels()

    Process {
        id: cavaProc

        running: root.analyzerActive
        command: ["cava", "-p", Quickshell.shellPath("modules/media/cava.conf")]

        stdout: SplitParser {
            onRead: data => root.applyCavaSample(data)
        }

        onExited: root.clearLiveLevels()
    }

    IpcHandler {
        target: "media"

        function playPause(): void {
            root.playPause();
        }
    }
}
