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
    readonly property string wallpaperDir: Quickshell.env("SKY_WALLPAPER_DIR") || (home + "/Projects/nixos-dotfiles/wallpapers")
    readonly property string stateDir: stateHome + "/quickshell"
    readonly property string stateFile: stateDir + "/wallpaper.json"
    readonly property string signalFile: stateDir + "/wallpaper-signal"
    readonly property string thumbnailDir: stateDir + "/wallpaper-thumbnails"
    readonly property string ffmpegBin: Quickshell.env("SKY_FFMPEG") || "ffmpeg"
    readonly property string wallpaperHelper: Quickshell.shellPath("modules/wallpaper/wallpaper-io")

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

    function extension(path) {
        var name = basename(path).toLowerCase();
        var dot = name.lastIndexOf(".");
        return dot >= 0 ? name.slice(dot + 1) : "";
    }

    function isAnimated(path) {
        return extension(path) === "gif";
    }

    function isVideo(path) {
        return ["mp4", "m4v", "mov", "webm", "mkv"].indexOf(extension(path)) >= 0;
    }

    function mediaKind(path) {
        if (isVideo(path))
            return "video";
        return isAnimated(path) ? "animated" : "image";
    }

    function thumbnailKey(path) {
        return basename(path).replace(/[^A-Za-z0-9._-]/g, "_");
    }

    function videoThumbnailPath(path) {
        return thumbnailDir + "/" + thumbnailKey(path) + ".jpg";
    }

    function videoThumbnailCommand(path) {
        return [wallpaperHelper, "thumbnail", ffmpegBin, path, videoThumbnailPath(path)];
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
        });

        saveStateProc.command = [wallpaperHelper, "save-state", stateFile, signalFile, payload];
        saveStateProc.running = true;
    }

    function refreshWallpapers() {
        listWallpapersProc.running = true;
    }

    function applyWallpaperList(data) {
        var items = String(data || "").split("\n").map(path => path.trim()).filter(path => path !== "");

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
        command: ["cat", "--", root.stateFile]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data
        }
        stderr: StdioCollector {}
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
        command: ["find", "--", root.wallpaperDir, "-maxdepth", "1", "-type", "f", "(", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.png", "-o", "-iname", "*.webp", "-o", "-iname", "*.gif", "-o", "-iname", "*.mp4", "-o", "-iname", "*.m4v", "-o", "-iname", "*.mov", "-o", "-iname", "*.webm", "-o", "-iname", "*.mkv", ")"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        stderr: StdioCollector {}
        onExited: {
            root.applyWallpaperList(stdout.buffer);
            stdout.buffer = "";
        }
    }

    property Process saveStateProc: Process {}
}
