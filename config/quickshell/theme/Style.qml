pragma Singleton
import QtQuick

QtObject {
    readonly property int barHeight: 38
    readonly property int barTopMargin: 5
    readonly property int popoverTop: barHeight + barTopMargin   // 43 — flush below bar
    readonly property int pillHeight: 38
    readonly property int pillRadius: 10
    readonly property int pillRadiusS: 8
    readonly property int pillPadH: 15
    readonly property int pillSpacing: 8
    readonly property int groupSpacing: 20
    readonly property int fontSize: 14
    readonly property int fontSizeS: 10
    readonly property string font: "FantasqueSansMono Nerd Font Propo"
}
