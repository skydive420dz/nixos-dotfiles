import ".."
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property string label: ""
    property string value: ""
    property int labelWidth: 70
    property bool valueFills: true

    Layout.fillWidth: true

    Text {
        text: root.label
        color: Mocha.subtext0
        font.pixelSize: Style.fontSizeS
        font.family: Style.font
        Layout.preferredWidth: root.labelWidth
    }

    Text {
        text: root.value
        color: Mocha.text
        font.pixelSize: Style.fontSizeS
        font.family: Style.font
        Layout.fillWidth: root.valueFills
    }
}
