import ".."
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import "../modules/clipboard"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: clipboardView.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-clipboard"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: clipboardView.open || clipboardView.closing
    color: "transparent"

    readonly property string runtimeDir: Quickshell.env("XDG_RUNTIME_DIR") || ("/run/user/" + Quickshell.env("UID"))

    mask: Region {
        item: outsideClickCatcher
        Region {
            item: clipboardView.maskItem
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
        clipboardView.open ? clipboardView.close() : show(targetScreen);
    }

    function show(targetScreen) {
        root.screen = targetScreen ?? focusedScreen();
        clipboardView.show();
    }

    Item {
        id: outsideClickCatcher

        width: clipboardView.open ? root.width : 0
        height: clipboardView.open ? root.height : 0
        visible: clipboardView.open

        MouseArea {
            anchors.fill: parent

            onClicked: mouse => {
                var point = mapToItem(clipboardView.panelItem, mouse.x, mouse.y);
                if (point.x < 0 || point.x > clipboardView.panelItem.width || point.y < 0 || point.y > clipboardView.panelItem.height)
                    clipboardView.close();
                else
                    mouse.accepted = false;
            }
        }
    }

    FileView {
        path: root.runtimeDir + "/qs-clipboard-toggle"
        watchChanges: true
        printErrors: false
        onFileChanged: targetScreenProc.running = true
    }

    Process {
        id: targetScreenProc

        command: ["bash", "-lc", "cat " + JSON.stringify(root.runtimeDir + "/qs-clipboard-target") + " 2>/dev/null || true"]
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

    ClipboardView {
        id: clipboardView
    }
}
