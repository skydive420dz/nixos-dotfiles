import "."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: Style.barHeight + 5
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 5
        left: 5
        right: 5
        bottom: 0
    }

    implicitHeight: Style.barHeight + 280
    color: "transparent"

    mask: Region {
        item: pill
        Region {
            item: barRow
        }
        Region {
            item: mediaModule
        }
        Region {
            item: trayModule
        }   // tray now in mask so menu mouse events work
    }

    property string hoveredModule: ""

    // ── Connectivity pill ─────────────────────────────────────────────────────
    Rectangle {
        id: pill

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
        anchors.rightMargin: 5

        implicitWidth: connectRow.implicitWidth + Style.pillPadH * 2
        implicitHeight: root.hoveredModule !== "" ? Style.pillHeight + 280 : Style.pillHeight
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

        RowLayout {
            id: connectRow
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: Style.pillPadH
                rightMargin: Style.pillPadH
            }
            height: Style.pillHeight
            spacing: Style.pillSpacing

            Clock {
                id: clockModule
            }
            Weather {
                id: weatherModule
            }
            Network {
                id: netModule
            }
            Bluetooth {
                id: btModule
            }
            Volume {
                id: volModule
            }
            Battery {
                id: battModule
            }
        }

        Item {
            anchors {
                top: connectRow.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 12
                topMargin: 10
            }

            // ── Clock ─────────────────────────────────────────────────────────
            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 10
                opacity: root.hoveredModule === "clock" ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatDate(new Date(), "MMMM yyyy")
                    color: Mocha.lavender
                    font.pixelSize: Style.fontSize
                    font.family: Style.font
                    font.bold: true
                }
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
                            height: 22
                        }
                    }
                    Repeater {
                        model: parent.daysInMonth
                        Rectangle {
                            width: 38
                            height: 22
                            radius: 11
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
            }

            // ── Weather ───────────────────────────────────────────────────────
            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 10
                opacity: root.hoveredModule === "weather" ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    spacing: 8
                    Text {
                        text: WeatherData.icon
                        font.pixelSize: 24
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
                Grid {
                    columns: 2
                    rowSpacing: 4
                    columnSpacing: 16
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
                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true
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

            // ── Network ───────────────────────────────────────────────────────
            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 8
                opacity: root.hoveredModule === "network" ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    Text {
                        text: netModule.connType === "wifi" ? "󰤨" : netModule.connType === "ethernet" ? "󰈀" : "󰤯"
                        font.pixelSize: 20
                        font.family: Style.font
                        color: Mocha.teal
                    }
                    Text {
                        text: netModule.connType === "wifi" ? netModule.ssid : netModule.connType === "ethernet" ? "Ethernet" : "Disconnected"
                        font.pixelSize: Style.fontSize
                        font.family: Style.font
                        font.bold: true
                        color: Mocha.text
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Mocha.pillBorder
                }
                Repeater {
                    model: {
                        var rows = [];
                        if (netModule.ipAddr)
                            rows.push({
                                label: "IP",
                                value: netModule.ipAddr
                            });
                        if (netModule.iface)
                            rows.push({
                                label: "Interface",
                                value: netModule.iface
                            });
                        if (netModule.connType === "wifi")
                            rows.push({
                                label: "Signal",
                                value: netModule.signal + "%"
                            });
                        return rows;
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: modelData.label
                            color: Mocha.subtext0
                            font.pixelSize: Style.fontSizeS
                            font.family: Style.font
                            Layout.preferredWidth: 70
                        }
                        Text {
                            text: modelData.value
                            color: Mocha.text
                            font.pixelSize: Style.fontSizeS
                            font.family: Style.font
                            Layout.fillWidth: true
                        }
                    }
                }
                Text {
                    text: "Click icon to open nmtui"
                    color: Mocha.overlay0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── Bluetooth ─────────────────────────────────────────────────────
            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 8
                opacity: root.hoveredModule === "bluetooth" ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    Text {
                        text: btModule.icon
                        font.pixelSize: 20
                        font.family: Style.font
                        color: btModule.powerState !== "on" ? Mocha.overlay0 : Mocha.teal
                    }
                    Text {
                        text: btModule.powerState !== "on" ? "Bluetooth Off" : btModule.deviceName ? btModule.deviceName : "No device connected"
                        font.pixelSize: Style.fontSize
                        font.family: Style.font
                        font.bold: true
                        color: Mocha.text
                    }
                }
                RowLayout {
                    visible: btModule.deviceBatt >= 0
                    Text {
                        text: "🔋 Battery"
                        color: Mocha.subtext0
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                        Layout.preferredWidth: 70
                    }
                    Text {
                        text: btModule.deviceBatt + "%"
                        color: Mocha.text
                        font.pixelSize: Style.fontSizeS
                        font.family: Style.font
                    }
                }
                Rectangle {
                    visible: btModule.pairedDevices.length > 0
                    Layout.fillWidth: true
                    height: 1
                    color: Mocha.pillBorder
                }
                Text {
                    visible: btModule.pairedDevices.length > 0
                    text: "Paired devices"
                    color: Mocha.subtext0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
                Repeater {
                    model: btModule.pairedDevices
                    Rectangle {
                        Layout.fillWidth: true
                        height: 28
                        radius: 8
                        color: modelData.addr === btModule.deviceAddr ? Qt.rgba(Mocha.teal.r, Mocha.teal.g, Mocha.teal.b, 0.2) : "transparent"
                        border.color: modelData.addr === btModule.deviceAddr ? Mocha.teal : "transparent"
                        border.width: 1
                        RowLayout {
                            anchors {
                                fill: parent
                                leftMargin: 8
                                rightMargin: 8
                            }
                            Text {
                                text: modelData.addr === btModule.deviceAddr ? "󰂱 " : "󰂯 "
                                color: Mocha.teal
                                font.pixelSize: 12
                                font.family: Style.font
                            }
                            Text {
                                text: modelData.name
                                color: Mocha.text
                                font.pixelSize: Style.fontSizeS
                                font.family: Style.font
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var action = modelData.addr === btModule.deviceAddr ? "disconnect" : "connect";
                                Qt.createQmlObject('import Quickshell.Io; Process { command: ["bluetoothctl", "' + action + '", "' + modelData.addr + '"]; running: true }', root);
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Mocha.pillBorder
                }
                Text {
                    text: "Click icon — bluetui   •   Hold icon — toggle power"
                    color: Mocha.overlay0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // ── Volume ────────────────────────────────────────────────────────
            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 10
                opacity: root.hoveredModule === "volume" ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    Text {
                        text: volModule.icon
                        font.pixelSize: 22
                        font.family: Style.font
                        color: volModule.muted ? Mocha.overlay0 : Mocha.mauve
                    }
                    Text {
                        text: volModule.muted ? "Muted" : Math.round(volModule.volume * 100) + "%"
                        font.pixelSize: Style.fontSize
                        font.family: Style.font
                        font.bold: true
                        color: Mocha.text
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        width: 28
                        height: 20
                        radius: 10
                        color: volModule.muted ? Qt.rgba(Mocha.red.r, Mocha.red.g, Mocha.red.b, 0.3) : Mocha.surface1
                        Text {
                            anchors.centerIn: parent
                            text: volModule.muted ? "󰖁" : "󰕾"
                            font.pixelSize: 11
                            font.family: Style.font
                            color: Mocha.text
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (volModule.sink?.audio)
                                    volModule.sink.audio.muted = !volModule.sink.audio.muted;
                            }
                        }
                    }
                }
                Item {
                    Layout.fillWidth: true
                    height: 16
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 6
                        radius: 3
                        color: Mocha.surface1
                        Rectangle {
                            width: parent.width * Math.min(volModule.volume, 1.0)
                            height: parent.height
                            radius: parent.radius
                            color: volModule.muted ? Mocha.overlay0 : Mocha.mauve
                            Behavior on width {
                                NumberAnimation {
                                    duration: 80
                                }
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (volModule.sink?.audio)
                                volModule.sink.audio.volume = Math.max(0, Math.min(1.5, mouseX / width));
                        }
                        onPositionChanged: {
                            if (pressed && volModule.sink?.audio)
                                volModule.sink.audio.volume = Math.max(0, Math.min(1.5, mouseX / width));
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Mocha.pillBorder
                }
                Text {
                    text: "Output devices"
                    color: Mocha.subtext0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                }
                Repeater {
                    model: Pipewire.nodes.values.filter(n => n.isSink && n.audio !== null && !n.isStream)
                    delegate: Rectangle {
                        id: sinkDelegate
                        required property PwNode modelData
                        readonly property bool isDefault: modelData.id === Pipewire.defaultAudioSink?.id
                        Layout.fillWidth: true
                        height: 28
                        radius: 8
                        color: isDefault ? Qt.rgba(Mocha.mauve.r, Mocha.mauve.g, Mocha.mauve.b, 0.2) : "transparent"
                        border.color: isDefault ? Mocha.mauve : "transparent"
                        border.width: 1
                        RowLayout {
                            anchors {
                                fill: parent
                                leftMargin: 8
                                rightMargin: 8
                            }
                            Text {
                                text: sinkDelegate.isDefault ? "󰓃 " : "  "
                                color: Mocha.mauve
                                font.pixelSize: 12
                                font.family: Style.font
                            }
                            Text {
                                text: sinkDelegate.modelData.description || sinkDelegate.modelData.name
                                color: Mocha.text
                                font.pixelSize: Style.fontSizeS
                                font.family: Style.font
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("sink:", sinkDelegate.modelData.description);
                                Pipewire.preferredDefaultAudioSink = sinkDelegate.modelData;
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Mocha.pillBorder
                }
                Text {
                    text: "Click icon — mute   •   Scroll — volume\nHold icon — wiremix"
                    color: Mocha.overlay0
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.font
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // ── Battery ───────────────────────────────────────────────────────
            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: 8
                opacity: root.hoveredModule === "battery" ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    Text {
                        text: battModule.icon
                        font.pixelSize: 22
                        font.family: Style.font
                        color: battModule.iconColor
                    }
                    ColumnLayout {
                        spacing: 1
                        Text {
                            text: battModule.capacity + "%  " + battModule.statusLabel
                            font.pixelSize: Style.fontSize
                            font.family: Style.font
                            font.bold: true
                            color: Mocha.text
                        }
                        Text {
                            visible: battModule.timeRemaining !== ""
                            text: battModule.charging ? "Full in " + battModule.timeRemaining : battModule.timeRemaining + " remaining"
                            font.pixelSize: Style.fontSizeS
                            font.family: Style.font
                            color: Mocha.subtext0
                        }
                    }
                }
                Item {
                    Layout.fillWidth: true
                    height: 10
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 6
                        radius: 3
                        color: Mocha.surface1
                        Rectangle {
                            width: parent.width * (battModule.capacity / 100)
                            height: parent.height
                            radius: parent.radius
                            color: battModule.iconColor
                            Behavior on width {
                                NumberAnimation {
                                    duration: 500
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Mocha.pillBorder
                }
                Repeater {
                    model: [
                        {
                            label: "🔋 Health",
                            value: battModule.health + "%"
                        },
                        {
                            label: "🔄 Cycles",
                            value: battModule.cycleCount.toString()
                        }
                    ]
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: modelData.label
                            color: Mocha.subtext0
                            font.pixelSize: Style.fontSizeS
                            font.family: Style.font
                            Layout.preferredWidth: 80
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
        }

        // ── Hover detection ───────────────────────────────────────────────────
        MouseArea {
            z: 1
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            onPositionChanged: {
                if (mouseY > Style.pillHeight)
                    return;
                var localX = mouseX - Style.pillPadH;
                var modules = [clockModule, weatherModule, netModule, btModule, volModule, battModule];
                var names = ["clock", "weather", "network", "bluetooth", "volume", "battery"];
                var cx = 0;
                for (var i = 0; i < modules.length; i++) {
                    if (i > 0)
                        cx += Style.pillSpacing;
                    cx += modules[i].implicitWidth;
                    if (localX < cx) {
                        root.hoveredModule = names[i];
                        return;
                    }
                }
                root.hoveredModule = "";
            }
            onExited: root.hoveredModule = ""
            onClicked: mouse.accepted = false
            onPressed: mouse.accepted = false
            onReleased: mouse.accepted = false
        }
    }

    // ── Media — truly centered in the full bar ────────────────────────────────
    Media {
        id: mediaModule
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
    }

    // ── Tray — sibling of barRow so it can expand downward freely ─────────────
    Tray {
        id: trayModule
        anchors.top: parent.top
        anchors.right: pill.left
        anchors.topMargin: (Style.barHeight - Style.pillHeight) / 2
        anchors.rightMargin: Style.groupSpacing
    }

    // ── Bar row ───────────────────────────────────────────────────────────────
    RowLayout {
        id: barRow
        anchors {
            top: parent.top
            left: parent.left
            right: trayModule.left   // stops at tray, not at pill
            leftMargin: 4
            rightMargin: Style.groupSpacing
        }
        height: Style.barHeight
        spacing: 0

        OsButton {}
        Item {
            width: 6
        }
        Workspaces {}
        Item {
            width: Style.groupSpacing
        }
        WindowTitle {}
        Item {
            Layout.fillWidth: true
        }
    }
}
