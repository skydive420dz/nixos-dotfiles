import "../.."
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: Math.min(titleText.implicitWidth + Theme.pad * 2, 360)
    implicitHeight: Theme.pillHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.maximumWidth: 360
    Layout.alignment: Qt.AlignVCenter

    clip: true

    required property var controller

    function windowLabel() {
        if (!controller.activeTitle)
            return "Desktop";

        var klass = controller.activeClass.toLowerCase();
        if (klass.indexOf("firefox") >= 0)
            return controller.activeTitle.replace(/ [—–] Mozilla Firefox$/, "").replace(/ Mozilla Firefox$/, "");
        if (klass === "ghostty" || klass.indexOf("ghostty") >= 0)
            return "Terminal";
        if (klass === "vesktop" || klass === "discord")
            return "Discord";
        return controller.activeTitle;
    }

    Text {
        id: titleText
        anchors.centerIn: parent
        width: Math.min(implicitWidth, parent.width - Theme.pad * 2)
        text: root.windowLabel()
        elide: Text.ElideRight
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
    }
}
