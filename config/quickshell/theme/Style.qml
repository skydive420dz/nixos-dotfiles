pragma Singleton
import QtQuick

QtObject {
    readonly property int barHeight: 36
    readonly property int pillHeight: 28   // barHeight - 8 — matches waybar min-height
    readonly property int pillRadius: 50
    readonly property int pillRadiusS: 12
    readonly property int pillPadH: 15   // horizontal inner padding
    readonly property int pillSpacing: 8    // gap between items inside a grouped pill
    readonly property int groupSpacing: 20   // gap between pill groups on the bar
    readonly property int fontSize: 14
    readonly property int fontSizeS: 10
    readonly property string font: "FantasqueSansMono Nerd Font Propo"
}
