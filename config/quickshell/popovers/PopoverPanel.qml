import QtQuick
import QtQuick.Layouts
import ".."

ColumnLayout {
    id: root

    property string hoveredModule: ""
    property string moduleName: ""

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    spacing: 8
    opacity: hoveredModule === moduleName ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: Style.animNormal
            easing.type: Style.easeOut
        }
    }
}
