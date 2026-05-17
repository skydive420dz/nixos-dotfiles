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

    function playPause() {
        mediaPlayer?.togglePlaying();
    }

    IpcHandler {
        target: "media"

        function playPause(): void {
            root.playPause();
        }
    }
}
