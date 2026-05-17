pragma Singleton
import QtQuick

QtObject {
    id: root

    property string hoveredModule: ""

    function show(moduleName) {
        _hideTimer.stop();
        hoveredModule = moduleName;
    }

    function hideSoon() {
        _hideTimer.restart();
    }

    function hideNow() {
        _hideTimer.stop();
        hoveredModule = "";
    }

    property var _hideTimer: Timer {
        interval: 120
        repeat: false
        onTriggered: root.hoveredModule = ""
    }
}
