pragma Singleton
import QtQuick

QtObject {
    readonly property int barHeight: 39
    readonly property int barTopMargin: 5
    readonly property int popoverTop: barHeight + barTopMargin   // 43 — flush below bar
    readonly property int pillHeight: 36
    readonly property int pillRadius: 20
    readonly property int pillRadiusS: 12
    readonly property int pillPadH: 15
    readonly property int pillSpacing: 8
    readonly property int groupSpacing: 20
    readonly property int fontSize: 14
    readonly property int fontSizeS: 10
    readonly property string font: "FantasqueSansMono Nerd Font Propo"
}
