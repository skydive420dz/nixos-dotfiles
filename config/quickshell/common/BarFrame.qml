import ".."
import QtQuick

Canvas {
    id: root

    required property int barHeight

    property int frameWidth: 3
    property int frameRadius: 10
    property int borderWidth: 2
    property color panelColor: Qt.rgba(0.090, 0.098, 0.135, 0.54)
    property color borderColor: Theme.border

    onPaint: {
        var ctx = getContext("2d");
        var barBottom = root.barHeight;
        var w = root.frameWidth;
        var r = root.frameRadius;
        var right = width;
        var bottom = height;
        var innerLeft = w;
        var innerRight = right - w;
        var innerTop = barBottom + w;
        var bottomInner = bottom - w;
        var halfBorder = root.borderWidth / 2;

        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = root.panelColor;
        ctx.fillRect(0, 0, width, height);

        ctx.save();
        ctx.beginPath();
        ctx.moveTo(innerLeft, innerTop + r);
        ctx.quadraticCurveTo(innerLeft, innerTop, innerLeft + r, innerTop);
        ctx.lineTo(innerRight - r, innerTop);
        ctx.quadraticCurveTo(innerRight, innerTop, innerRight, innerTop + r);
        ctx.lineTo(innerRight, bottomInner - r);
        ctx.quadraticCurveTo(innerRight, bottomInner, innerRight - r, bottomInner);
        ctx.lineTo(innerLeft + r, bottomInner);
        ctx.quadraticCurveTo(innerLeft, bottomInner, innerLeft, bottomInner - r);
        ctx.lineTo(innerLeft, innerTop + r);
        ctx.closePath();
        ctx.clip();
        ctx.clearRect(0, 0, width, height);
        ctx.restore();

        ctx.strokeStyle = root.borderColor;
        ctx.lineWidth = root.borderWidth;
        ctx.beginPath();
        ctx.moveTo(halfBorder, halfBorder);
        ctx.lineTo(width - halfBorder, halfBorder);
        ctx.moveTo(halfBorder, halfBorder);
        ctx.lineTo(halfBorder, root.barHeight - halfBorder);
        ctx.moveTo(width - halfBorder, halfBorder);
        ctx.lineTo(width - halfBorder, root.barHeight - halfBorder);
        ctx.stroke();
    }

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onBarHeightChanged: requestPaint()
    onFrameWidthChanged: requestPaint()
    onFrameRadiusChanged: requestPaint()
    onBorderWidthChanged: requestPaint()
    onPanelColorChanged: requestPaint()
    onBorderColorChanged: requestPaint()
}
