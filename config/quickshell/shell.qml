//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import Quickshell
import "modules/media"
import "modules/workspaces"
import "root"

ShellRoot {
    MediaController {
        id: rootMediaController
    }

    WorkspacesController {
        id: rootWorkspacesController
    }

    Variants {
        model: Quickshell.screens
        delegate: Wallpaper {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
            mediaController: rootMediaController
            workspacesController: rootWorkspacesController
        }
    }

    WallpaperPicker {}

    Launcher {}

    Clipboard {}

    Osd {}
}
