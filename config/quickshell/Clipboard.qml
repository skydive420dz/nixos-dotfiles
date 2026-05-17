import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
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

    visible: root.open || root.closing
    color: "transparent"

    mask: Region {
        item: outsideClickCatcher
        Region {
            item: panelMask
        }
    }

    Item {
        id: outsideClickCatcher
        width: root.open ? root.width : 0
        height: root.open ? root.height : 0
        visible: root.open

        MouseArea {
            anchors.fill: parent
            onClicked: mouse => {
                var point = mapToItem(panel, mouse.x, mouse.y);
                if (point.x < 0 || point.x > panel.width || point.y < 0 || point.y > panel.height)
                    root.close();
                else
                    mouse.accepted = false;
            }
        }
    }

    property bool open: false
    property bool closing: false
    property string query: ""
    property int selectedIndex: 0
    property var entries: []
    readonly property var results: filteredResults()
    readonly property int rowHeight: Style.overlayRowHeight
    readonly property int visibleRows: Math.min(results.length, 8)
    readonly property string previewDir: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-clipboard-previews"

    Item {
        id: panelMask
        x: panel.x
        y: panel.y
        width: panel.visible ? panel.width : 0
        height: panel.visible ? panel.height : 0
    }

    function focusedScreen() {
        var monitorName = Hyprland.focusedMonitor?.name ?? "";
        for (var i = 0; i < Quickshell.screens.length; i++) {
            if (Quickshell.screens[i].name === monitorName)
                return Quickshell.screens[i];
        }
        return root.screen;
    }

    function toggle() {
        open ? close() : show();
    }

    function show() {
        root.screen = focusedScreen();
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

    function isImagePreview(preview) {
        var text = normalize(preview);
        return text.indexOf("image/") >= 0
            || text.indexOf("binary data") >= 0
            || text.indexOf(".png") >= 0
            || text.indexOf(".jpg") >= 0
            || text.indexOf(".jpeg") >= 0
            || text.indexOf(".webp") >= 0
            || text.indexOf(".gif") >= 0;
    }

    function parseEntry(line, index) {
        var tab = line.indexOf("\t");
        var id = tab >= 0 ? line.slice(0, tab) : line;
        var preview = tab >= 0 ? line.slice(tab + 1) : line;
        var cleanPreview = preview.replace(/\s+/g, " ").trim();
        var image = isImagePreview(cleanPreview);

        return {
            "id": id,
            "preview": image ? "Image" : cleanPreview,
            "detail": image ? cleanPreview : "",
            "isImage": image,
            "thumb": previewDir + "/" + id + ".img",
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

    function scrollResults(delta) {
        if (root.results.length <= root.visibleRows)
            return;

        var maxY = Math.max(0, resultList.contentHeight - resultList.height);
        resultList.contentY = Math.max(0, Math.min(maxY, resultList.contentY + delta));
    }

    function selectResult(index) {
        if (root.results.length === 0) {
            selectedIndex = 0;
            return;
        }

        selectedIndex = Math.max(0, Math.min(index, root.results.length - 1));
        resultList.positionViewAtIndex(selectedIndex, ListView.Contain);
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

    Rectangle {
        id: panel
        visible: root.open || root.closing
        width: Math.min(Style.panelWidth, root.width - 48)
        height: searchBox.height + (root.visibleRows > 0 ? resultList.height + Style.panelSpacing : emptyState.height + Style.panelSpacing)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Style.panelTopMargin
        radius: Style.panelRadius
        color: Mocha.panelBg
        border.color: Mocha.panelBorder
        border.width: 1
        clip: true
        opacity: root.open ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Style.animPanel
                easing.type: Style.easeOut
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: Style.panelSpacing

            Rectangle {
                id: searchBox
                Layout.fillWidth: true
                height: Style.controlHeight
                radius: Style.controlRadius
                color: Mocha.controlBg
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.pillPadH
                    anchors.rightMargin: Style.pillPadH
                    spacing: Style.pillSpacing

                    Text {
                        text: ""
                        color: Mocha.accent
                        font.family: Style.font
                        font.pixelSize: Style.controlFontSize
                    }

                    TextInput {
                        id: search
                        Layout.fillWidth: true
                        text: root.query
                        color: Mocha.text
                        selectionColor: Mocha.surface2
                        selectedTextColor: Mocha.text
                        font.family: Style.font
                        font.pixelSize: Style.controlFontSize
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
                                root.selectResult(root.selectedIndex + 1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier))) {
                                root.selectResult(root.selectedIndex - 1);
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
                        color: Mocha.subtext0
                        font.family: Style.font
                        font.pixelSize: 14
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.query.length > 0 ? "Try a softer search." : "Copy something and it will land here."
                        color: Mocha.overlay1
                        font.family: Style.font
                        font.pixelSize: 11
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
                    property bool previewReady: false

                    width: ListView.view.width
                    height: root.rowHeight
                    radius: Style.rowRadius
                    color: index === root.selectedIndex ? Mocha.rowSelected : "transparent"

                    Component.onCompleted: {
                        if (modelData.isImage)
                            previewProc.running = true;
                    }

                    Process {
                        id: previewProc
                        command: ["bash", "-lc", "mkdir -p \"$2\" && [ -s \"$3\" ] || printf '%s' \"$1\" | cliphist decode > \"$3\"", "clipboard-preview", modelData.raw, root.previewDir, modelData.thumb]
                        running: false
                        onExited: previewReady = true
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: Style.overlayIconBoxSize
                            Layout.preferredHeight: Style.overlayIconBoxSize
                            radius: Style.iconBoxRadius
                            color: Mocha.iconBg
                            clip: true

                            Image {
                                anchors.fill: parent
                                anchors.margins: 2
                                visible: modelData.isImage && previewReady
                                source: visible ? "file://" + modelData.thumb : ""
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: false
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: !modelData.isImage || !previewReady
                                text: modelData.isImage ? "" : ""
                                color: index === root.selectedIndex ? Mocha.accent : Mocha.subtext0
                                font.family: Style.font
                                font.pixelSize: 16
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                Layout.fillWidth: true
                                text: modelData.preview
                                color: Mocha.text
                                font.family: Style.font
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.isImage ? modelData.detail : "Text"
                                color: Mocha.overlay1
                                font.family: Style.font
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }
                        }

                        Text {
                            text: "↵"
                            color: Mocha.overlay1
                            font.family: Style.font
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.selectedIndex = index
                        onClicked: root.activate(index)
                        onWheel: wheel => {
                            root.scrollResults(wheel.angleDelta.y > 0 ? -root.rowHeight * 2 : root.rowHeight * 2);
                            wheel.accepted = true;
                        }
                    }
                }
            }
        }
    }
}
