import ".."
import QtQuick

// Weather display in the bar — data is owned by the WeatherData singleton.
// Popover content lives in Clock.qml alongside the calendar.

Item {
    implicitWidth: weatherText.implicitWidth + 8
    implicitHeight: Style.pillHeight

    Text {
        id: weatherText
        anchors.centerIn: parent
        text: WeatherData.display
        font.pixelSize: Style.fontSize
        font.family: Style.font
        color: Mocha.sky
    }
}
