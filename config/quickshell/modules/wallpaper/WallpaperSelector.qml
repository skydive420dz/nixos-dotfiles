pragma ComponentBehavior: Bound

import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    anchors.fill: parent

    property alias maskItem: card

    Rectangle {
        id: card

        width: Math.min(parent.width - 96, 720)
        height: Math.min(parent.height - Theme.barHeight - 72, 430)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Theme.barHeight + 24

        radius: Theme.radius
        color: Theme.panel
        border.color: Theme.border
        border.width: 1
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "󰸉"
                    color: Theme.accent
                    font.family: Theme.iconFont
                    font.pixelSize: Theme.mediaIconSize + 4
                }

                Text {
                    Layout.fillWidth: true
                    text: "Wallpapers"
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize + 2
                    font.bold: true
                }

                Rectangle {
                    Layout.preferredWidth: Theme.pillHeight - 6
                    Layout.preferredHeight: Theme.pillHeight - 6
                    radius: Theme.radiusSmall
                    color: closeMouse.containsMouse ? Theme.panelAlt : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        color: Theme.muted
                        font.family: Theme.iconFont
                        font.pixelSize: Theme.fontSize + 2
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: WallpaperStore.closeSelector()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
            }

            Flickable {
                id: wallpaperList

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: width
                contentHeight: wallpaperGrid.implicitHeight

                Grid {
                    id: wallpaperGrid

                    width: wallpaperList.width
                    columns: Math.max(1, Math.floor(width / 160))
                    spacing: 10

                    Repeater {
                        model: WallpaperStore.selectorOpen ? WallpaperStore.wallpapers : []

                        delegate: Rectangle {
                            id: wallpaperCard

                            required property var modelData

                            readonly property bool selected: modelData === WallpaperStore.currentPath
                            readonly property int cardWidth: Math.floor((wallpaperGrid.width - wallpaperGrid.spacing * (wallpaperGrid.columns - 1)) / wallpaperGrid.columns)

                            width: cardWidth
                            height: 128
                            radius: Theme.radius
                            color: wallpaperMouse.containsMouse || selected ? Theme.panelAlt : Theme.bg
                            border.color: selected ? Theme.accent : Theme.border
                            border.width: selected ? 2 : 1
                            clip: true

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 6

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 82
                                    radius: Theme.radiusSmall
                                    color: Theme.panel
                                    clip: true

                                    Image {
                                        anchors.fill: parent
                                        source: WallpaperStore.fileUrl(wallpaperCard.modelData)
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        cache: false
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: WallpaperStore.basename(wallpaperCard.modelData)
                                    color: wallpaperCard.selected ? Theme.text : Theme.muted
                                    font.family: Theme.font
                                    font.pixelSize: Theme.fontSizeSmall
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            MouseArea {
                                id: wallpaperMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: WallpaperStore.choose(wallpaperCard.modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
