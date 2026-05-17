import Quickshell
import "modules/media"

ShellRoot {
    MediaController {
        id: mediaController
    }

    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
            mediaController: mediaController
        }
    }

    Osd {}
}
