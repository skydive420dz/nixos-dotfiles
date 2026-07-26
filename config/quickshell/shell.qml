//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import Quickshell
import "modules/media"
import "modules/status"
import "modules/window"
import "modules/workspaces"
import "root"

ShellRoot {
    MediaController {
        id: rootMediaController
    }

    StatusController {
        id: rootStatusController
    }

    WindowTitleController {
        id: rootWindowTitleController
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
            statusController: rootStatusController
            windowTitleController: rootWindowTitleController
            workspacesController: rootWorkspacesController
        }
    }

    WallpaperPicker {}

    Launcher {}

    Clipboard {}

    Osd {}
}
