import ".."
import QtQuick
import QtQuick.Layouts

PopoverPanel {
    id: root

    property date now: new Date()
    readonly property int todayDate: now.getDate()
    readonly property int firstDay: new Date(now.getFullYear(), now.getMonth(), 1).getDay()
    readonly property int daysInMonth: new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate()
    moduleName: "clock"
    spacing: 10

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDate(root.now, "MMMM yyyy")
        color: Mocha.lavender
        font.pixelSize: Style.fontSize
        font.family: Style.font
        font.bold: true
    }

    Grid {
        Layout.alignment: Qt.AlignHCenter
        columns: 7
        rowSpacing: 2
        columnSpacing: 0

        Repeater {
            model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
            Text {
                width: 38
                text: modelData
                color: Mocha.subtext0
                font.pixelSize: 10
                font.family: Style.font
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Repeater {
            model: root.firstDay
            Item {
                width: 38
                height: 22
            }
        }

        Repeater {
            model: root.daysInMonth
            Rectangle {
                width: 38
                height: 22
                radius: 11
                color: (index + 1) === root.todayDate ? Mocha.lavender : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: (index + 1).toString()
                    color: (index + 1) === root.todayDate ? Mocha.crust : Mocha.text
                    font.pixelSize: 11
                    font.family: Style.font
                }
            }
        }
    }
}
