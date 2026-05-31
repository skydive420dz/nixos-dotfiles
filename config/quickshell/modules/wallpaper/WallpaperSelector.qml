pragma ComponentBehavior: Bound

import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    anchors.fill: parent

    property alias maskItem: card
    property string query: ""
    readonly property var filteredWallpapers: filterWallpapers()

    function normalize(text) {
        return (text ?? "").toString().toLowerCase();
    }

    function filterWallpapers() {
        var needle = normalize(query).trim();
        if (needle.length === 0)
            return WallpaperStore.wallpapers;

        return WallpaperStore.wallpapers.filter(path => normalize(WallpaperStore.basename(path)).indexOf(needle) >= 0);
    }

    Connections {
        target: WallpaperStore

        function onSelectorOpenChanged() {
            if (WallpaperStore.selectorOpen) {
                root.query = "";
                search.forceActiveFocus();
            }
        }
    }

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

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.pillHeight
                radius: Theme.radius
                color: Theme.panelAlt
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.pad + 7
                    anchors.rightMargin: Theme.pad + 7
                    spacing: 8

                    Text {
                        text: ""
                        color: Theme.accent
                        font.family: Theme.iconFont
                        font.pixelSize: Theme.fontSize + 3
                    }

                    TextInput {
                        id: search

                        Layout.fillWidth: true
                        text: root.query
                        color: Theme.text
                        selectionColor: Theme.border
                        selectedTextColor: Theme.text
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSize + 4
                        clip: true
                        focus: WallpaperStore.selectorOpen

                        Text {
                            anchors.fill: parent
                            text: "Search wallpapers"
                            color: Theme.muted
                            font.family: search.font.family
                            font.pixelSize: search.font.pixelSize
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            visible: search.text.length === 0
                        }

                        onTextChanged: root.query = text

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                WallpaperStore.closeSelector();
                                event.accepted = true;
                            }
                        }
                    }

                    Text {
                        text: root.filteredWallpapers.length + "/" + WallpaperStore.wallpapers.length
                        color: Theme.muted
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSizeSmall + 1
                    }
                }
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
                        model: WallpaperStore.selectorOpen ? root.filteredWallpapers : []

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

                                    Rectangle {
                                        visible: wallpaperCard.selected
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.margins: 6
                                        height: 24
                                        width: currentBadge.implicitWidth + 18
                                        radius: Theme.radiusSmall
                                        color: Theme.accent

                                        RowLayout {
                                            id: currentBadge

                                            anchors.centerIn: parent
                                            spacing: 4

                                            Text {
                                                text: ""
                                                color: Theme.bg
                                                font.family: Theme.iconFont
                                                font.pixelSize: Theme.fontSizeSmall
                                            }

                                            Text {
                                                text: "Current"
                                                color: Theme.bg
                                                font.family: Theme.font
                                                font.pixelSize: Theme.fontSizeSmall
                                                font.bold: true
                                            }
                                        }
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
