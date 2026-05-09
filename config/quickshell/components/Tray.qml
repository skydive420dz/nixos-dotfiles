import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root

    // Root mirrors pill so the mask in Bar.qml covers the real expanded area
    implicitWidth: pill.implicitWidth
    implicitHeight: pill.implicitHeight

    property SystemTrayItem activeItem: null
    readonly property bool menuOpen: activeItem !== null

    QsMenuOpener {
        id: menuOpener
        menu: root.activeItem?.hasMenu ? root.activeItem.menu : null
    }

    Rectangle {
        id: pill
        anchors.top: parent.top
        anchors.right: parent.right

        // Right-anchored, so growing implicitWidth expands LEFT — gives L-shape effect
        implicitWidth: root.menuOpen ? Math.max(iconRow.implicitWidth, menuCol.implicitWidth) + Style.pillPadH * 2 : iconRow.implicitWidth + Style.pillPadH * 2
        Behavior on implicitWidth {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        implicitHeight: root.menuOpen ? Style.pillHeight + Math.min(menuCol.implicitHeight + 20, 320) : Style.pillHeight
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        radius: Style.pillRadius
        color: Mocha.pillBg
        border.color: Mocha.pillBorder
        border.width: 1
        clip: true

        // ── Icon row — right-aligned so icons stay put as pill grows left ──────
        RowLayout {
            id: iconRow
            anchors {
                top: parent.top
                right: parent.right
                rightMargin: Style.pillPadH
            }
            height: Style.pillHeight
            spacing: 8

            Repeater {
                model: SystemTray.items

                delegate: Item {
                    id: trayItem
                    required property SystemTrayItem modelData
                    width: 20
                    height: 20

                    Image {
                        anchors.fill: parent
                        source: trayItem.modelData.icon
                        smooth: true
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: mouse => {
                            if (mouse.button === Qt.LeftButton) {
                                root.activeItem = null;
                                trayItem.modelData.activate();
                            } else if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
                                root.activeItem = root.activeItem === trayItem.modelData ? null : trayItem.modelData;
                            }
                        }
                    }
                }
            }
        }

        // ── Menu content — fades in below icon row ────────────────────────────
        Item {
            anchors {
                top: iconRow.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 10
                topMargin: 8
            }

            opacity: root.menuOpen ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }

            ColumnLayout {
                id: menuCol
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 2

                Repeater {
                    model: menuOpener.children

                    delegate: Rectangle {
                        id: menuItemRect
                        required property QsMenuEntry modelData

                        Layout.fillWidth: true

                        // ⬇ THIS is the key fix: declare what width we'd like to be
                        // based on inner content. ColumnLayout will pick up the
                        // maximum across all menu items, which propagates up
                        // through menuCol.implicitWidth → pill.implicitWidth.
                        implicitWidth: menuItemRect.modelData.isSeparator ? 0 : itemRow.implicitWidth + 16   // 8px left + 8px right margin

                        height: menuItemRect.modelData.isSeparator ? 1 : 28
                        radius: menuItemRect.modelData.isSeparator ? 0 : 6
                        color: {
                            if (menuItemRect.modelData.isSeparator)
                                return Mocha.pillBorder;
                            return itemHover.containsMouse ? Qt.rgba(Mocha.lavender.r, Mocha.lavender.g, Mocha.lavender.b, 0.15) : "transparent";
                        }

                        RowLayout {
                            id: itemRow                          // ← give it an id so Rectangle can read implicitWidth
                            anchors {
                                fill: parent
                                leftMargin: 8
                                rightMargin: 8
                            }
                            visible: !menuItemRect.modelData.isSeparator
                            spacing: 8

                            Image {
                                visible: menuItemRect.modelData.icon !== ""
                                source: menuItemRect.modelData.icon
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                smooth: true
                                mipmap: true
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillWidth: true
                                text: menuItemRect.modelData.text
                                color: menuItemRect.modelData.enabled ? Mocha.text : Mocha.overlay0
                                font.pixelSize: Style.fontSizeS
                                font.family: Style.font
                                // No elide — pill grows to fit
                            }

                            Text {
                                visible: menuItemRect.modelData.checkState !== undefined && menuItemRect.modelData.checkState !== Qt.Unchecked
                                text: "󰄵"
                                color: Mocha.lavender
                                font.pixelSize: Style.fontSizeS
                                font.family: Style.font
                            }
                        }

                        MouseArea {
                            id: itemHover
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: menuItemRect.modelData.enabled && !menuItemRect.modelData.isSeparator
                            onClicked: {
                                menuItemRect.modelData.triggered();
                                root.activeItem = null;
                            }
                        }
                    }
                }
            }
        }
    }
}
