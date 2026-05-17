pragma Singleton
import QtQuick

QtObject {
    property var activeItem: null
    readonly property bool menuOpen: activeItem !== null

    function close() {
        activeItem = null;
    }
}
