import "../.."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    anchors.fill: parent

    property alias maskItem: panel
    property alias panelItem: panel
    property bool open: false
    property bool closing: false
    property string query: ""
    property int selectedIndex: 0
    property var entries: []
    readonly property var results: filteredResults()
    readonly property int panelWidth: 620
    readonly property int panelTopMargin: Theme.barHeight + 20
    readonly property int panelSpacing: 10
    readonly property int controlHeight: Theme.pillHeight
    readonly property int controlFontSize: Theme.fontSize + 6
    readonly property int rowHeight: 58
    readonly property int visibleRows: Math.min(results.length, 8)
    readonly property int iconBoxSize: 42
    readonly property color panelColor: Qt.rgba(Theme.panel.r, Theme.panel.g, Theme.panel.b, 0.94)
    readonly property color controlColor: Qt.rgba(Theme.panelAlt.r, Theme.panelAlt.g, Theme.panelAlt.b, 0.96)
    readonly property color chipColor: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.90)

    function show() {
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

    function parseEntry(line, index) {
        var tab = line.indexOf("\t");
        var id = tab >= 0 ? line.slice(0, tab) : line;
        var preview = tab >= 0 ? line.slice(tab + 1) : line;
        var cleanPreview = preview.replace(/\s+/g, " ").trim();

        return {
            "id": id,
            "preview": cleanPreview.length > 0 ? cleanPreview : "Clipboard item",
            "detail": "Text",
            "raw": line,
            "index": index
        };
    }

    function score(entry, needle) {
        var haystack = normalize(entry.preview);
        if (needle.length === 0)
            return entry.index;
        if (haystack.indexOf(needle) === 0)
            return 0;

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
        var matches = [];

        for (var i = 0; i < entries.length; i++) {
            var rank = score(entries[i], needle);
            if (rank >= 0) {
                matches.push({
                    "item": entries[i],
                    "rank": rank
                });
            }
        }

        matches.sort((a, b) => a.rank === b.rank ? a.item.index - b.item.index : a.rank - b.rank);
        return matches.slice(0, 60).map(match => match.item);
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

        Quickshell.execDetached(["bash", "-lc", "printf '%s' \"$1\" | cliphist decode | wl-copy", "clipboard-copy", item.raw]);
        close();
    }

    function remove(index) {
        var item = results[index];
        if (!item)
            return;

        Quickshell.execDetached(["bash", "-lc", "printf '%s' \"$1\" | cliphist delete", "clipboard-delete", item.raw]);
        entries = entries.filter(entry => entry.raw !== item.raw);
        selectedIndex = Math.min(selectedIndex, Math.max(results.length - 2, 0));
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

        command: ["cliphist", "list"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            var lines = stdout.buffer.split("\n").filter(line => line.trim().length > 0);
            root.entries = lines.map((line, index) => root.parseEntry(line, index));
            root.selectedIndex = 0;
            stdout.buffer = "";
        }
    }

    Rectangle {
        id: panel

        visible: root.open || root.closing
        width: Math.min(root.panelWidth, root.width - 48)
        height: searchBox.height + (root.visibleRows > 0 ? resultList.height + root.panelSpacing : emptyState.height + root.panelSpacing)
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
                height: root.controlHeight
                radius: Theme.radius
                color: root.controlColor
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.pad + 7
                    anchors.rightMargin: Theme.pad + 7
                    spacing: 8

                    Text {
                        text: ""
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
                            text: "Clipboard Search"
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
                            } else if (event.key === Qt.Key_Delete || (event.key === Qt.Key_Backspace && search.text.length === 0)) {
                                root.remove(root.selectedIndex);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.activate(root.selectedIndex);
                                event.accepted = true;
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: emptyState

                Layout.fillWidth: true
                height: 92
                visible: root.visibleRows === 0
                color: "transparent"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.query.length > 0 ? "No matches" : "Clipboard is quiet"
                        color: Theme.muted
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSize + 2
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.query.length > 0 ? "Try a softer search." : "Copy something and it will land here."
                        color: Theme.muted
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSizeSmall + 1
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

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                color: index === root.selectedIndex ? Theme.accent : Theme.muted
                                font.family: Theme.iconFont
                                font.pixelSize: 16
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                Layout.fillWidth: true
                                text: modelData.preview
                                color: Theme.text
                                font.family: Theme.font
                                font.pixelSize: Theme.fontSize + 2
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.detail
                                color: Theme.muted
                                font.family: Theme.font
                                font.pixelSize: Theme.fontSizeSmall + 1
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: root.selectedIndex = index
                        onClicked: root.activate(index)
                    }
                }
            }
        }
    }
}
