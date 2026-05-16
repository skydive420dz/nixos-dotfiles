import ".."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string title: "Unknown"
    property string artist: ""
    property string contentIcon: ""
    property bool isYoutube: false
    property real trackWidth: 180

    Layout.fillWidth: true
    Layout.preferredWidth: trackWidth
    Layout.maximumWidth: trackWidth
    implicitWidth: trackWidth
    implicitHeight: Style.pillHeight
    clip: true

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 1

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4
            Layout.maximumWidth: root.trackWidth

            Text {
                visible: root.contentIcon !== ""
                text: root.contentIcon
                color: root.isYoutube ? Mocha.red : Mocha.accent
                font.pixelSize: Style.fontSizeS + 1
                font.family: Style.font
            }

            Text {
                text: root.title
                color: Mocha.text
                font.pixelSize: Style.fontSizeS + 1
                font.family: Style.font
                font.bold: true
                elide: Text.ElideRight
                Layout.maximumWidth: root.trackWidth - (root.contentIcon !== "" ? 18 : 0)
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.artist
            color: Mocha.subtext0
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
            elide: Text.ElideRight
            Layout.maximumWidth: root.trackWidth
            visible: text !== ""
        }
    }
}
