import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    Layout.preferredWidth: StatusMetrics.networkGraphWidth
    Layout.preferredHeight: Theme.pillHeight - StatusMetrics.networkGraphHeightOffset

    property var downSamples: []
    property var upSamples: []
    property color downColor: Theme.accent
    property color upColor: Theme.danger
    property color baselineColor: Theme.border

    onDownSamplesChanged: graph.requestPaint()
    onUpSamplesChanged: graph.requestPaint()

    Canvas {
        id: graph

        anchors.fill: parent
        antialiasing: true

        function scaleSample(samples) {
            var maxValue = 4096;
            for (var i = 0; i < samples.length; i++)
                maxValue = Math.max(maxValue, Number(samples[i]) || 0);
            return maxValue * 1.25;
        }

        function drawDottedBaseline(ctx, y, dotSize, pitch) {
            ctx.fillStyle = root.baselineColor;
            ctx.globalAlpha = 0.62;

            for (var x = 0; x < width; x += pitch) {
                ctx.fillRect(x, y, dotSize, dotSize);
            }
        }

        function sampleAt(samples, index, count) {
            if (!samples || samples.length === 0)
                return 0;

            var start = Math.max(0, samples.length - count);
            return Number(samples[start + index]) || 0;
        }

        function drawDotColumns(ctx, samples, maxValue, baseY, direction, color, dotSize, pitch) {
            if (!samples || samples.length === 0)
                return;

            var count = Math.min(samples.length, Math.max(1, Math.floor(width / pitch)));
            var rowPitch = dotSize + 1;
            var halfHeight = Math.max(1, height / 2 - 3);
            var maxRows = Math.max(1, Math.floor(halfHeight / rowPitch));
            var leftPad = Math.max(0, width - count * pitch) / 2;

            for (var i = 0; i < count; i++) {
                var x = Math.round(leftPad + i * pitch);
                var sample = sampleAt(samples, i, count);
                var normalized = Math.min(Math.log1p(sample) / Math.log1p(maxValue), 1);
                var dots = sample > 0 ? Math.max(1, Math.round(normalized * maxRows)) : 0;

                ctx.fillStyle = color;
                for (var j = 0; j < dots; j++) {
                    var progress = dots <= 1 ? 1 : j / (dots - 1);
                    var y = Math.round(baseY - direction * (rowPitch + j * rowPitch));

                    ctx.globalAlpha = 0.24 + progress * 0.72;
                    ctx.fillRect(x, y, dotSize, dotSize);
                }

                if (normalized > 0.80) {
                    var peakY = Math.round(baseY - direction * (rowPitch + (dots - 1) * rowPitch));
                    ctx.globalAlpha = 0.20;
                    ctx.fillRect(x - 1, peakY - 1, dotSize + 2, dotSize + 2);
                }
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var dotSize = StatusMetrics.networkGraphDotSize;
            var pitch = StatusMetrics.networkGraphPitch;
            var mid = Math.round(height / 2);

            drawDottedBaseline(ctx, mid, dotSize, pitch);

            drawDotColumns(ctx, root.downSamples, scaleSample(root.downSamples), mid, 1, root.downColor, dotSize, pitch);
            drawDotColumns(ctx, root.upSamples, scaleSample(root.upSamples), mid, -1, root.upColor, dotSize, pitch);
        }
    }
}
