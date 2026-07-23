pragma ComponentBehavior: Bound

import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    anchors.fill: parent

    property alias maskItem: panel
    property alias panelItem: panel
    property bool open: false
    property bool closing: false
    property string query: ""
    property int selectedIndex: 0
    property var apps: []
    readonly property var results: filteredResults()
    readonly property int panelWidth: 620
    readonly property int panelTopMargin: Theme.barHeight + 20
    readonly property int panelSpacing: 10
    readonly property int controlHeight: Theme.pillHeight
    readonly property int controlFontSize: Theme.fontSize + 6
    readonly property int rowHeight: 58
    readonly property int visibleRows: Math.min(results.length, 8)
    readonly property int iconBoxSize: 42
    readonly property int iconSize: 22
    readonly property color panelColor: Qt.rgba(Theme.panel.r, Theme.panel.g, Theme.panel.b, 0.94)
    readonly property color controlColor: Qt.rgba(Theme.panelAlt.r, Theme.panelAlt.g, Theme.panelAlt.b, 0.96)
    readonly property color chipColor: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.90)

    function show() {
        closeTimer.stop();
        closing = false;
        open = true;
        query = "";
        selectedIndex = 0;
        if (!loadProc.running)
            loadProc.running = true;
        search.forceActiveFocus();
    }

    function close() {
        closing = true;
        open = false;
        closeTimer.restart();
    }

    function normalize(text) {
        return (text ?? "").toString().toLowerCase();
    }

    function score(item, needle) {
        var name = normalize(item.name);
        var words = name.split(/\s+/);
        for (var w = 0; w < words.length; w++)
            if (words[w].indexOf(needle) === 0)
                return w;

        var haystack = normalize(item.name + " " + item.subtitle + " " + item.search);
        if (name.indexOf(needle) === 0)
            return 5;

        var direct = haystack.indexOf(needle);
        if (direct >= 0)
            return 20 + direct;

        var pos = 0;
        var gaps = 0;
        for (var i = 0; i < needle.length; i++) {
            var next = haystack.indexOf(needle[i], pos);
            if (next < 0)
                return -1;
            gaps += next - pos;
            pos = next + 1;
        }

        return 80 + gaps + haystack.length / 100;
    }

    function filteredResults() {
        var needle = normalize(query).trim();
        if (needle.length === 0)
            return [];

        var pool = [];
        for (var i = 0; i < apps.length; i++) {
            var app = apps[i];
            pool.push({
                "name": app.name,
                "subtitle": app.generic || app.comment || app.exec,
                "search": app.desktop + " " + app.generic + " " + app.comment,
                "icon": app.icon || "",
                "exec": app.exec,
                "terminal": app.terminal || false
            });
        }

        var matches = [];
        for (var p = 0; p < pool.length; p++) {
            var rank = score(pool[p], needle);
            if (rank >= 0) {
                matches.push({
                    "item": pool[p],
                    "rank": rank
                });
            }
        }

        matches.sort((a, b) => a.rank === b.rank ? a.item.name.localeCompare(b.item.name) : a.rank - b.rank);
        return matches.slice(0, 40).map(match => match.item);
    }

    function selectResult(index) {
        if (root.results.length === 0) {
            selectedIndex = 0;
            return;
        }

        selectedIndex = Math.max(0, Math.min(index, root.results.length - 1));
        resultList.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    function activate(index) {
        var item = results[index];
        if (!item)
            return;

        if (item.terminal)
            Quickshell.execDetached(["bash", "-lc", "uwsm app -- ghostty -e " + item.exec]);
        else
            Quickshell.execDetached(["bash", "-lc", "uwsm app -- " + item.exec]);

        close();
    }

    Timer {
        id: closeTimer

        interval: 150
        onTriggered: {
            root.query = "";
            root.selectedIndex = 0;
            root.closing = false;
        }
    }

    Process {
        id: loadProc

        command: ["bash", "-lc", "$HOME/.config/scripts/launcher-apps"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            try {
                root.apps = JSON.parse(stdout.buffer.trim());
            } catch (e) {
                root.apps = [];
            }
            stdout.buffer = "";
        }
    }

    Rectangle {
        id: panel

        visible: root.open || root.closing
        width: Math.min(root.panelWidth, root.width - 48)
        height: searchBox.height + (root.visibleRows > 0 ? resultList.height + root.panelSpacing : 0)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.panelTopMargin
        radius: Theme.radius
        color: root.panelColor
        border.color: "transparent"
        border.width: 0
        clip: true
        opacity: root.open ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: root.panelSpacing

            Rectangle {
                id: searchBox

                Layout.fillWidth: true
                Layout.preferredHeight: root.controlHeight
                radius: Theme.radius
                color: root.controlColor
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
                        font.pixelSize: root.controlFontSize
                        clip: true
                        focus: root.open

                        Text {
                            anchors.fill: parent
                            text: "Spotlight Search"
                            color: Theme.muted
                            font.family: search.font.family
                            font.pixelSize: search.font.pixelSize
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            visible: search.text.length === 0
                        }

                        onTextChanged: {
                            root.query = text;
                            root.selectedIndex = 0;
                        }

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                root.close();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Down || (event.key === Qt.Key_J && (event.modifiers & Qt.ControlModifier))) {
                                root.selectResult(root.selectedIndex + 1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier))) {
                                root.selectResult(root.selectedIndex - 1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.activate(root.selectedIndex);
                                event.accepted = true;
                            }
                        }
                    }
                }
            }

            ListView {
                id: resultList

                Layout.fillWidth: true
                Layout.preferredHeight: root.visibleRows * root.rowHeight
                visible: root.visibleRows > 0
                clip: true
                interactive: root.results.length > root.visibleRows
                boundsBehavior: Flickable.StopAtBounds
                model: root.results

                delegate: Rectangle {
                    id: resultDelegate

                    required property var modelData
                    required property int index

                    width: ListView.view.width
                    height: root.rowHeight
                    radius: Theme.radius
                    color: index === root.selectedIndex ? root.controlColor : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Rectangle {
                            Layout.preferredWidth: root.iconBoxSize
                            Layout.preferredHeight: root.iconBoxSize
                            radius: Theme.radiusSmall
                            color: root.chipColor

                            IconImage {
                                anchors.centerIn: parent
                                width: root.iconSize
                                height: root.iconSize
                                source: Quickshell.iconPath(resultDelegate.modelData.icon || "application-x-executable", "application-x-executable")
                                asynchronous: true
                                mipmap: true
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: resultDelegate.modelData.icon.length === 0
                                text: "󰣆"
                                color: resultDelegate.index === root.selectedIndex ? Theme.accent : Theme.muted
                                font.family: Theme.iconFont
                                font.pixelSize: 15
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                text: resultDelegate.modelData.name
                                color: Theme.text
                                font.family: Theme.font
                                font.pixelSize: Theme.fontSize + 2
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                text: resultDelegate.modelData.subtitle
                                color: Theme.muted
                                font.family: Theme.font
                                font.pixelSize: Theme.fontSizeSmall + 1
                                elide: Text.ElideRight
                                visible: text.length > 0
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: root.selectedIndex = resultDelegate.index
                        onClicked: root.activate(resultDelegate.index)
                    }
                }
            }
        }
    }
}
