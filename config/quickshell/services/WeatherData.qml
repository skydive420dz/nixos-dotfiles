pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    // ── Display (bar label) ───────────────────────────────────────────────────
    property string display: "󰖐 --"

    // ── Current conditions ────────────────────────────────────────────────────
    property string icon: "󰖐"
    property string moonIcon: "🌙"
    property int tempF: 0
    property int tempC: 0
    property int feelsF: 0
    property int feelsC: 0
    property int humidity: 0
    property int windMph: 0
    property string windDir: ""
    property string desc: ""
    property int uv: 0
    property string sunrise: ""
    property string sunset: ""
    property string moonPhase: ""
    property int moonIllum: 0

    // ── Forecast (array of {day, desc, max_f, min_f}) ────────────────────────
    property var forecast: []

    // ── Fetching ──────────────────────────────────────────────────────────────
    property var _proc: Process {
        command: ["bash", "-c", "$HOME/.config/scripts/weather"]

        stdout: SplitParser {
            property string buffer: ""
            onRead: data => {
                buffer += data + "\n";
            }
        }

        onExited: {
            try {
                var j = JSON.parse(_proc.stdout.buffer.trim());
                root.display = j.text ?? "󰖐 --";
                var d = j.data;
                if (!d)
                    return;
                root.icon = d.icon ?? "󰖐";
                root.moonIcon = d.moon_icon ?? "🌙";
                root.tempF = d.temp_f ?? 0;
                root.tempC = d.temp_c ?? 0;
                root.feelsF = d.feels_f ?? 0;
                root.feelsC = d.feels_c ?? 0;
                root.humidity = d.humidity ?? 0;
                root.windMph = d.wind_mph ?? 0;
                root.windDir = d.wind_dir ?? "";
                root.desc = d.desc ?? "";
                root.uv = d.uv ?? 0;
                root.sunrise = d.sunrise ?? "";
                root.sunset = d.sunset ?? "";
                root.moonPhase = d.moon_phase ?? "";
                root.moonIllum = d.moon_illum ?? 0;
                root.forecast = d.forecast ?? [];
            } catch (e) {}
            _proc.stdout.buffer = "";
        }
    }

    property var _timer: Timer {
        interval: 1800000   // 30 min
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root._proc.running = true
    }
}
