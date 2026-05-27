import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    Layout.preferredWidth: 38
    Layout.preferredHeight: Theme.pillHeight - 8

    property var downSamples: []
    property var upSamples: []
    property color downColor: Theme.accent
    property color upColor: Theme.good
    property color baselineColor: Theme.border

    onDownSamplesChanged: graph.requestPaint()
    onUpSamplesChanged: graph.requestPaint()

    Canvas {
        id: graph

        anchors.fill: parent
        antialiasing: true

        function maxSample(samples) {
            var maxValue = 1;
            for (var i = 0; i < samples.length; i++)
                maxValue = Math.max(maxValue, Number(samples[i]) || 0);
            return maxValue;
        }

        function drawDottedBaseline(ctx, y) {
            ctx.fillStyle = root.baselineColor;
            ctx.globalAlpha = 0.74;

            for (var x = 1; x < width; x += 5) {
                ctx.beginPath();
                ctx.arc(x, y, 1.05, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        function drawDotColumns(ctx, samples, maxValue, baseY, direction, color) {
            if (!samples || samples.length === 0)
                return;

            var count = samples.length;
            var step = count > 1 ? width / (count - 1) : width;
            var halfHeight = Math.max(1, height / 2 - 2);

            for (var i = 0; i < count; i++) {
                var x = i * step;
                var normalized = Math.min((Number(samples[i]) || 0) / maxValue, 1);
                var peak = Math.max(normalized, 0.10) * halfHeight;
                var dotGap = 3;
                var dots = Math.max(1, Math.round(peak / dotGap));

                ctx.fillStyle = color;
                for (var j = 0; j < dots; j++) {
                    var progress = dots <= 1 ? 1 : j / (dots - 1);
                    var y = baseY - direction * (4 + j * dotGap);
                    var radius = 0.85 + progress * 0.35;

                    ctx.globalAlpha = 0.18 + progress * 0.76;
                    ctx.beginPath();
                    ctx.arc(x, y, radius, 0, Math.PI * 2);
                    ctx.fill();
                }

                if (normalized > 0.65) {
                    var glowY = baseY - direction * peak;
                    ctx.globalAlpha = 0.16;
                    ctx.beginPath();
                    ctx.arc(x, glowY, 2.6, 0, Math.PI * 2);
                    ctx.fill();
                }
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var mid = Math.round(height / 2) + 0.5;

            drawDottedBaseline(ctx, mid);

            drawDotColumns(ctx, root.downSamples, maxSample(root.downSamples), mid, 1, root.downColor);
            drawDotColumns(ctx, root.upSamples, maxSample(root.upSamples), mid, -1, root.upColor);
        }
    }
}
