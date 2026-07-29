import Quickshell
import Quickshell.Wayland

Scope {
    readonly property string activeClass: ToplevelManager.activeToplevel?.appId ?? ""
    readonly property string activeTitle: ToplevelManager.activeToplevel?.title ?? ""
}
