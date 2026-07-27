import Quickshell
import Quickshell.Hyprland

Scope {
    property var occupiedWorkspaces: Hyprland.workspaces.values.reduce((occupied, workspace) => {
        if (workspace.toplevels.values.length > 0)
            occupied[workspace.id] = true;
        return occupied;
    }, {})
}
