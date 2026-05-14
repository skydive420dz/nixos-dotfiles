import ".."
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string hoveredModule: ""

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    spacing: 10
    opacity: hoveredModule === "weather" ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    RowLayout {
        spacing: 8

        Text {
            text: WeatherData.icon
            font.pixelSize: 24
            font.family: Style.font
            color: Mocha.sky
        }

        ColumnLayout {
            spacing: 2

            Text {
                text: WeatherData.desc
                color: Mocha.text
                font.pixelSize: Style.fontSize
                font.family: Style.font
                font.bold: true
            }

            Text {
                text: WeatherData.tempF + "°F  feels " + WeatherData.feelsF + "°F"
                color: Mocha.subtext0
                font.pixelSize: Style.fontSizeS
                font.family: Style.font
            }
        }
    }

    Grid {
        columns: 2
        rowSpacing: 4
        columnSpacing: 16
        Layout.fillWidth: true

        Repeater {
            model: [
                {
                    label: "💧 Humidity",
                    value: WeatherData.humidity + "%"
                },
                {
                    label: "💨 Wind",
                    value: WeatherData.windMph + " mph " + WeatherData.windDir
                },
                {
                    label: "☀️ UV",
                    value: WeatherData.uv.toString()
                },
                {
                    label: "🌅 Sunrise",
                    value: WeatherData.sunrise
                },
                {
                    label: "🌇 Sunset",
                    value: WeatherData.sunset
                },
                {
                    label: WeatherData.moonIcon + " Moon",
                    value: WeatherData.moonPhase
                }
            ]

            RowLayout {
                spacing: 4

                Text {
                    text: modelData.label
                    color: Mocha.subtext0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }

                Text {
                    text: modelData.value
                    color: Mocha.text
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Mocha.pillBorder
    }

    ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

        Repeater {
            model: WeatherData.forecast

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    text: modelData.day
                    color: Mocha.lavender
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.preferredWidth: 70
                }

                Text {
                    text: modelData.desc
                    color: Mocha.text
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: modelData.max_f + "/" + modelData.min_f + "°F"
                    color: Mocha.subtext0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
            }
        }
    }
}
