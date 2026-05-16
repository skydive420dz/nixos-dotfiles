import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "qs-launcher"

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
    property var apps: []
    property var windows: []
    property bool appsLoaded: false
    readonly property var results: filteredResults()
    readonly property int rowHeight: Style.overlayRowHeight
    readonly property int visibleRows: Math.min(results.length, 8)

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

    function toggle(targetScreen) {
        open ? close() : show(targetScreen);
    }

    function show(targetScreen) {
        root.screen = targetScreen ?? focusedScreen();
        closing = false;
        open = true;
        query = "";
        selectedIndex = 0;
        if (!appsLoaded)
            loadProc.running = true;
        windowsProc.running = true;
        search.forceActiveFocus();
    }

    function close() {
        closing = true;
        open = false;
        query = "";
        selectedIndex = 0;
        closeTimer.restart();
    }

    function selectResult(index) {
        if (root.results.length === 0) {
            selectedIndex = 0;
            return;
        }

        selectedIndex = Math.max(0, Math.min(index, root.results.length - 1));
        resultList.positionViewAtIndex(selectedIndex, ListView.Contain);
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
        for (var w = 0; w < windows.length; w++) {
            var win = windows[w];
            pool.push({
                "type": "window",
                "name": win.title || win.class || "Window",
                "subtitle": win.class ? "Window · " + win.class : "Window",
                "search": (win.class || "") + " " + (win.initialClass || ""),
                "icon": "",
                "address": win.address || ""
            });
        }

        for (var i = 0; i < apps.length; i++) {
            var app = apps[i];
            pool.push({
                "type": "app",
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
            if (rank >= 0)
                matches.push({
                    "item": pool[p],
                    "rank": rank + (pool[p].type === "window" ? 2 : 10)
                });
        }

        matches.sort((a, b) => a.rank === b.rank ? a.item.name.localeCompare(b.item.name) : a.rank - b.rank);
        return matches.slice(0, 40).map(match => match.item);
    }

    function activate(index) {
        var item = results[index];
        if (!item)
            return;
        if (item.type === "window")
            Quickshell.execDetached(["hyprctl", "dispatch", "focuswindow", "address:" + item.address]);
        else if (item.terminal)
            Quickshell.execDetached(["bash", "-lc", "uwsm app -- kitty -e " + item.exec]);
        else
            Quickshell.execDetached(["bash", "-lc", "uwsm app -- " + item.exec]);
        close();
    }

    FileView {
        id: toggleSignal
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-launcher-toggle"
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
        command: ["bash", "-lc", "$HOME/.config/scripts/launcher-apps"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            try {
                root.apps = JSON.parse(stdout.buffer.trim());
                root.appsLoaded = true;
            } catch (e) {
                root.apps = [];
                root.appsLoaded = false;
            }
            stdout.buffer = "";
        }
    }

    Process {
        id: windowsProc
        command: ["hyprctl", "clients", "-j"]
        stdout: SplitParser {
            property string buffer: ""
            onRead: data => buffer += data + "\n"
        }
        onExited: {
            try {
                root.windows = JSON.parse(stdout.buffer.trim()).filter(win => !win.hidden);
            } catch (e) {
                root.windows = [];
            }
            stdout.buffer = "";
        }
    }

    Rectangle {
        id: panel
        visible: root.open || root.closing
        width: Math.min(Style.panelWidth, root.width - 48)
        height: searchBox.height + (root.visibleRows > 0 ? resultList.height + Style.panelSpacing : 0)
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
                duration: 120
                easing.type: Easing.OutCubic
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
                        text: ""
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
                            text: "Spotlight Search"
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
                    radius: Style.rowRadius
                    color: index === root.selectedIndex ? Mocha.rowSelected : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Rectangle {
                            Layout.preferredWidth: Style.overlayIconBoxSize
                            Layout.preferredHeight: Style.overlayIconBoxSize
                            radius: Style.iconBoxRadius
                            color: Mocha.iconBg

                            IconImage {
                                anchors.centerIn: parent
                                width: Style.overlayIconSize
                                height: Style.overlayIconSize
                                source: Quickshell.iconPath(modelData.type === "window" ? "preferences-system-windows" : (modelData.icon || "application-x-executable"), "application-x-executable")
                                asynchronous: true
                                mipmap: true
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: modelData.type === "window" || modelData.icon.length === 0
                                text: modelData.type === "window" ? "󰖲" : "󰣆"
                                color: index === root.selectedIndex ? Mocha.accent : Mocha.subtext0
                                font.family: Style.font
                                font.pixelSize: 15
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                text: modelData.name
                                color: Mocha.text
                                font.family: Style.font
                                font.pixelSize: 14
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.subtitle
                                color: Mocha.overlay1
                                font.family: Style.font
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                visible: text.length > 0
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: typeLabel.implicitWidth + 14
                            Layout.preferredHeight: 22
                            radius: Style.iconBoxRadius
                            color: Mocha.iconBg

                            Text {
                                id: typeLabel
                                anchors.centerIn: parent
                                text: modelData.type === "window" ? "Window" : "App"
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
