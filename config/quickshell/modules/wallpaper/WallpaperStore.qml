pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string home: Quickshell.env("HOME")
    readonly property string configHome: Quickshell.env("XDG_CONFIG_HOME") || (home + "/.config")
    readonly property string stateHome: Quickshell.env("XDG_STATE_HOME") || (home + "/.local/state")
    readonly property string wallpaperDir: Quickshell.env("SKY_WALLPAPER_DIR") || (home + "/nixos-dotfiles/wallpapers")
    readonly property string stateDir: stateHome + "/quickshell"
    readonly property string stateFile: stateDir + "/wallpaper.json"
    readonly property string signalFile: stateDir + "/wallpaper-signal"

    property bool selectorOpen: false
    property string currentPath: wallpaperDir + "/wallpaper-003.gif"
    property var wallpapers: []

    function basename(path) {
        var parts = String(path || "").split("/");
        return parts[parts.length - 1] || "";
    }

    function fileUrl(path) {
        return "file://" + path;
    }

    function isAnimated(path) {
        return String(path || "").toLowerCase().endsWith(".gif");
    }

    function toggleSelector() {
        if (!selectorOpen)
            refreshWallpapers();
        selectorOpen = !selectorOpen;
    }

    function closeSelector() {
        selectorOpen = false;
    }

    function choose(path) {
        if (!path)
            return;

        currentPath = path;
        selectorOpen = false;
        saveState();
    }

    function applyState(payload) {
        if (payload.currentPath)
            currentPath = payload.currentPath;
    }

    function saveState() {
        var payload = JSON.stringify({
            currentPath: currentPath
        }) + "\n";
        var command = "mkdir -p " + JSON.stringify(stateDir)
            + " && printf %s " + JSON.stringify(payload)
            + " > " + JSON.stringify(stateFile)
            + " && date +%s > " + JSON.stringify(signalFile);

        saveStateProc.command = ["bash", "-lc", command];
        saveStateProc.running = true;
    }

    function refreshWallpapers() {
        listWallpapersProc.running = true;
    }

    function applyWallpaperList(data) {
        var items = String(data || "")
            .split("\n")
            .map(path => path.trim())
            .filter(path => path !== "");

        items.sort();
        wallpapers = items;
    }

    Component.onCompleted: {
        refreshWallpapers();
        loadStateProc.running = true;
    }

    property FileView signalWatcher: FileView {
        path: root.signalFile
        watchChanges: true
        printErrors: false
        onFileChanged: loadStateProc.running = true
    }

    property Process loadStateProc: Process {
        id: loadStateProc
        command: ["bash", "-lc", "cat " + JSON.stringify(root.stateFile) + " 2>/dev/null || true"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data
        }
        onExited: {
            try {
                var payload = JSON.parse(stdout.buffer.trim());
                root.applyState(payload);
            } catch (e) {}
            stdout.buffer = "";
        }
    }

    property Process listWallpapersProc: Process {
        id: listWallpapersProc
        command: [
            "bash",
            "-lc",
            "find " + JSON.stringify(root.wallpaperDir)
                + " -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \\) 2>/dev/null | sort"
        ]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            root.applyWallpaperList(stdout.buffer);
            stdout.buffer = "";
        }
    }

    property Process saveStateProc: Process {}
}
