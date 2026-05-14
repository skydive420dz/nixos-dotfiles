import Quickshell

ShellRoot {
    Launcher {
        id: launcher
    }

    Osd {}

    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
            launcher: launcher
        }
    }
}
