pragma Singleton
import QtQuick

QtObject {
    readonly property int barHeight: 38
    readonly property int barTopMargin: 5
    readonly property int popoverTop: barHeight + barTopMargin   // 43 — flush below bar
    readonly property int pillHeight: 38
    readonly property int pillRadius: 8
    readonly property int pillRadiusS: 6
    readonly property int panelRadius: 10
    readonly property int panelWidth: 620
    readonly property int panelTopMargin: barHeight + 20
    readonly property int panelSpacing: 10
    readonly property int controlHeight: pillHeight
    readonly property int controlRadius: pillRadius
    readonly property int controlFontSize: 18
    readonly property int overlayRowHeight: 58
    readonly property int overlayIconBoxSize: 42
    readonly property int overlayIconSize: 22
    readonly property int rowRadius: pillRadius
    readonly property int iconBoxRadius: pillRadiusS
    readonly property int pillPadH: 15
    readonly property int pillSpacing: 8
    readonly property int groupSpacing: 20
    readonly property int connectivityPillWidth: 424
    readonly property int fontSize: 14
    readonly property int fontSizeS: 10
    readonly property string font: "FantasqueSansMono Nerd Font Propo"

    // QML owns UI motion. Hyprland layer animations stay disabled so layer-shell
    // surfaces do not slide or fade as transparent compositor rectangles.
    readonly property int animFast: 100
    readonly property int animNormal: 150
    readonly property int animSlow: 240
    readonly property int animPanel: 140
    readonly property int animResize: 220
    readonly property int animColor: 130
    readonly property int animMicroSlide: 4
    readonly property int easeOut: Easing.OutCubic
    readonly property int easeInOut: Easing.InOutCubic
}
