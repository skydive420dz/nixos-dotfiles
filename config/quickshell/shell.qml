import Quickshell
import "modules/media"

ShellRoot {
    MediaController {
        id: rootMediaController
    }

    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
            mediaController: rootMediaController
        }
    }

    Osd {}
}
