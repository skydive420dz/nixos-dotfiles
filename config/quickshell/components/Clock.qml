import ".."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: col.implicitWidth + 8
    implicitHeight: Style.pillHeight

    property bool hovered: hover.containsMouse

    ColumnLayout {
        id: col
        anchors.centerIn: parent
        spacing: 1

        Text {
            id: timeText
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.fontSize
            font.family: Style.font
            font.bold: true
            color: Mocha.blue
        }

        Text {
            id: dateText
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.fontSizeS
            font.family: Style.font
            color: Mocha.subtext0
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            timeText.text = "󱑂 " + Qt.formatTime(now, "hh:mm");
            dateText.text = Qt.formatDate(now, "ddd, MMM d");
        }
    }

    // ── Popover ───────────────────────────────────────────────────────────────
    Popover {
        showing: root.hovered
        side: "right"
        popWidth: 300
        popHeight: clockPopCol.implicitHeight + 28

        ColumnLayout {
            id: clockPopCol
            anchors.fill: parent
            spacing: 10

            // Month header
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var now = new Date();
                    return Qt.formatDate(now, "MMMM yyyy");
                }
                color: Mocha.lavender
                font.pixelSize: Style.fontSize
                font.family: Style.font
                font.bold: true
            }

            // Calendar grid
            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 7
                rowSpacing: 2
                columnSpacing: 0

                property var now: new Date()
                property int todayDate: now.getDate()
                property int firstDay: new Date(now.getFullYear(), now.getMonth(), 1).getDay()
                property int daysInMonth: new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate()

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
                    model: parent.firstDay
                    Item {
                        width: 38
                        height: 24
                    }
                }
                Repeater {
                    model: parent.daysInMonth
                    Rectangle {
                        width: 38
                        height: 24
                        radius: 12
                        color: (index + 1) === parent.parent.todayDate ? Mocha.lavender : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: (index + 1).toString()
                            color: (index + 1) === parent.parent.todayDate ? Mocha.crust : Mocha.text
                            font.pixelSize: 11
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

            // Current weather
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Text {
                    text: WeatherData.icon
                    font.pixelSize: 28
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

            // Details
            Grid {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 4
                columnSpacing: 16

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

            // 3-day forecast
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
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
    }
}
