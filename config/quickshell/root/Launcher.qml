import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import "../modules/launcher"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: launcherView.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-launcher"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: launcherView.open || launcherView.closing
    color: "transparent"

    readonly property string runtimeDir: Quickshell.env("XDG_RUNTIME_DIR") || ("/run/user/" + Quickshell.env("UID"))

    mask: Region {
        item: outsideClickCatcher
        Region {
            item: launcherView.maskItem
        }
    }

    function focusedScreen() {
        var monitorName = Hyprland.focusedMonitor?.name ?? "";
        var screen = screenByName(monitorName);
        return screen ?? root.screen;
    }

    function screenByName(screenName) {
        if (!screenName || screenName.length === 0)
            return null;

        for (var i = 0; i < Quickshell.screens.length; i++) {
            if (Quickshell.screens[i].name === screenName)
                return Quickshell.screens[i];
        }

        return null;
    }

    function toggle(targetScreen) {
        launcherView.open ? launcherView.close() : show(targetScreen);
    }

    function show(targetScreen) {
        root.screen = targetScreen ?? focusedScreen();
        launcherView.show();
    }

    Item {
        id: outsideClickCatcher

        width: launcherView.open ? root.width : 0
        height: launcherView.open ? root.height : 0
        visible: launcherView.open

        MouseArea {
            anchors.fill: parent

            onClicked: mouse => {
                var point = mapToItem(launcherView.panelItem, mouse.x, mouse.y);
                if (point.x < 0 || point.x > launcherView.panelItem.width || point.y < 0 || point.y > launcherView.panelItem.height)
                    launcherView.close();
                else
                    mouse.accepted = false;
            }
        }
    }

    FileView {
        path: root.runtimeDir + "/qs-launcher-toggle"
        watchChanges: true
        printErrors: false
        onFileChanged: targetScreenProc.running = true
    }

    Process {
        id: targetScreenProc

        command: ["bash", "-lc", "cat " + JSON.stringify(root.runtimeDir + "/qs-launcher-target") + " 2>/dev/null || true"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data
        }
        onExited: {
            var screenName = stdout.buffer.trim();
            stdout.buffer = "";
            root.toggle(root.screenByName(screenName));
        }
    }

    LauncherView {
        id: launcherView
    }
}
