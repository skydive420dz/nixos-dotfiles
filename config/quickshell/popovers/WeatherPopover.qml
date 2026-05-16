import ".."
import QtQuick
import QtQuick.Layouts

PopoverPanel {
    id: root

    moduleName: "weather"
    spacing: 10

    RowLayout {
        spacing: 8

        Text {
            text: WeatherData.icon
            font.pixelSize: 28
            font.family: Style.font
            color: Mocha.blue
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

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

    GridLayout {
        columns: 2
        rowSpacing: 4
        columnSpacing: 10
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

            InfoRow {
                label: modelData.label
                value: modelData.value
                labelWidth: 74
                valueFills: false
            }
        }
    }

    Divider {}

    SectionLabel {
        label: "Forecast"
    }

    ColumnLayout {
        spacing: 2
        Layout.fillWidth: true

        Repeater {
            model: WeatherData.forecast

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: modelData.day
                    color: Mocha.blue
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.preferredWidth: 56
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
                    horizontalAlignment: Text.AlignRight
                    Layout.preferredWidth: 52
                }
            }
        }
    }
}
