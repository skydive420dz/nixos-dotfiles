import Quickshell

ShellRoot {
    Launcher {
        id: launcher
    }

    Clipboard {}

    Osd {}

    Variants {
        model: Quickshell.screens
        delegate: BarLeft {
            required property var modelData
            screen: modelData
            launcher: launcher
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: BarCenter {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: BarRight {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: BarConnectivityPopover {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: BarTray {
            required property var modelData
            screen: modelData
        }
    }
}
