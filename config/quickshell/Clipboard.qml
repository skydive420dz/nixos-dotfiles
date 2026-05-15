import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-clipboard"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: true
    color: "transparent"

    mask: Region {
        item: panel
    }

    property bool open: false
    property bool closing: false
    property string query: ""
    property int selectedIndex: 0
    property var entries: []
    readonly property var results: filteredResults()
    readonly property int rowHeight: 50
    readonly property int visibleRows: Math.min(results.length, 8)

    function toggle() {
        open ? close() : show();
    }

    function show() {
        closing = false;
        open = true;
        query = "";
        selectedIndex = 0;
        loadProc.running = true;
        search.forceActiveFocus();
    }

    function close() {
        closing = true;
        open = false;
        query = "";
        selectedIndex = 0;
        closeTimer.restart();
    }

    function normalize(text) {
        return (text ?? "").toString().toLowerCase();
    }

    function parseEntry(line, index) {
        var tab = line.indexOf("\t");
        var id = tab >= 0 ? line.slice(0, tab) : line;
        var preview = tab >= 0 ? line.slice(tab + 1) : line;

        return {
            "id": id,
            "preview": preview.replace(/\s+/g, " ").trim(),
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
            if (rank >= 0)
                matches.push({
                    "item": entries[i],
                    "rank": rank
                });
        }

        matches.sort((a, b) => a.rank === b.rank ? a.item.index - b.item.index : a.rank - b.rank);
        return matches.slice(0, 60).map(match => match.item);
    }

    function activate(index) {
        var item = results[index];
        if (!item)
            return;

        copyProc.entry = item.raw;
        copyProc.running = true;
        close();
    }

    function remove(index) {
        var item = results[index];
        if (!item)
            return;

        deleteProc.entry = item.raw;
        deleteProc.running = true;
        entries = entries.filter(entry => entry.raw !== item.raw);
        selectedIndex = Math.min(selectedIndex, Math.max(results.length - 2, 0));
    }

    FileView {
        id: toggleSignal
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-clipboard-toggle"
        watchChanges: true
        printErrors: false
        onFileChanged: root.toggle()
    }

    Timer {
        id: closeTimer
        interval: 150
        onTriggered: root.closing = false
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

    Process {
        id: copyProc
        property string entry: ""
        command: ["bash", "-lc", "printf '%s' \"$1\" | cliphist decode | wl-copy", "clipboard-copy", entry]
        running: false
    }

    Process {
        id: deleteProc
        property string entry: ""
        command: ["bash", "-lc", "printf '%s' \"$1\" | cliphist delete", "clipboard-delete", entry]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.open
        visible: root.open
        onClicked: mouse => {
            var point = mapToItem(panel, mouse.x, mouse.y);
            if (point.x < 0 || point.x > panel.width || point.y < 0 || point.y > panel.height)
                root.close();
            else
                mouse.accepted = false;
        }
    }

    Rectangle {
        id: panel
        visible: root.open || root.closing
        width: Math.min(560, root.width - 48)
        height: searchBox.height + (root.visibleRows > 0 ? resultList.height + 8 : 0)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Style.barHeight + 20
        radius: Style.pillRadius
        color: Qt.rgba(Mocha.base.r, Mocha.base.g, Mocha.base.b, 0.92)
        border.color: Mocha.pillBorder
        border.width: 1
        clip: true
        opacity: root.open ? 1 : 0

        Behavior on height {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 8

            Rectangle {
                id: searchBox
                Layout.fillWidth: true
                height: Style.pillHeight
                radius: Style.pillRadius
                color: "transparent"
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.pillPadH
                    anchors.rightMargin: Style.pillPadH
                    spacing: Style.pillSpacing

                    Text {
                        text: ""
                        color: Mocha.blue
                        font.family: Style.font
                        font.pixelSize: 24
                    }

                    TextInput {
                        id: search
                        Layout.fillWidth: true
                        text: root.query
                        color: Mocha.text
                        selectionColor: Mocha.surface2
                        selectedTextColor: Mocha.text
                        font.family: Style.font
                        font.pixelSize: 24
                        clip: true
                        focus: root.open

                        Text {
                            anchors.fill: parent
                            text: "Clipboard Search"
                            color: Mocha.overlay1
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
                                root.selectedIndex = Math.min(root.selectedIndex + 1, root.results.length - 1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier))) {
                                root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace) {
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
                    radius: 12
                    color: index === root.selectedIndex ? Qt.rgba(Mocha.surface1.r, Mocha.surface1.g, Mocha.surface1.b, 0.72) : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 30
                            radius: 9
                            color: Qt.rgba(Mocha.surface0.r, Mocha.surface0.g, Mocha.surface0.b, 0.55)

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                color: index === root.selectedIndex ? Mocha.blue : Mocha.subtext0
                                font.family: Style.font
                                font.pixelSize: 15
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: modelData.preview
                            color: Mocha.text
                            font.family: Style.font
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        Rectangle {
                            Layout.preferredWidth: 54
                            Layout.preferredHeight: 22
                            radius: 8
                            color: Qt.rgba(Mocha.surface0.r, Mocha.surface0.g, Mocha.surface0.b, 0.55)

                            Text {
                                anchors.centerIn: parent
                                text: "Enter"
                                color: Mocha.overlay1
                                font.family: Style.font
                                font.pixelSize: 10
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
