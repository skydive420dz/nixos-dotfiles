import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    Layout.preferredWidth: 54
    Layout.preferredHeight: Theme.pillHeight - 10

    property bool active: false
    property int tick: 0

    Timer {
        interval: 90
        repeat: true
        running: root.active
        onTriggered: {
            root.tick = (root.tick + 1) % 360;
            spectrum.requestPaint();
        }
    }

    onActiveChanged: spectrum.requestPaint()

    Canvas {
        id: spectrum

        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var columns = 12;
            var step = width / (columns - 1);
            var baseline = height - 2;
            var maxHeight = height - 4;

            for (var i = 0; i < columns; i++) {
                var wave = root.active ? Math.abs(Math.sin((root.tick + i * 31) / 18)) : 0;
                var pulse = root.active ? Math.abs(Math.sin((root.tick + i * 17) / 23)) : 0;
                var peak = 3 + wave * maxHeight;
                var dots = Math.max(1, Math.round(peak / 3));
                var x = i * step;

                ctx.fillStyle = Theme.accent;
                for (var j = 0; j < dots; j++) {
                    var progress = dots <= 1 ? 1 : j / (dots - 1);
                    var y = baseline - j * 3;
                    var radius = 0.8 + progress * 0.35;

                    ctx.globalAlpha = root.active ? 0.20 + progress * 0.45 + pulse * 0.25 : 0.16;
                    ctx.beginPath();
                    ctx.arc(x, y, radius, 0, Math.PI * 2);
                    ctx.fill();
                }
            }
        }
    }
}
