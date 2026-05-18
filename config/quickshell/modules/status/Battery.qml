import "../.."
import QtQuick
import QtQuick.Layouts

Text {
    id: root

    visible: level >= 0
    Layout.preferredWidth: 48
    color: level < 20 && !charging ? Theme.danger : Theme.muted
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    text: icon() + " " + label()

    property int level: -1
    property bool charging: false
    property string status: ""

    function icon() {
        if (level < 0)
            return "";
        if (status === "Charging")
            return "󱐋";
        if (status === "Full" || status === "Not charging")
            return "󱐥";
        if (level < 20)
            return "󰂃";
        if (level < 50)
            return "󰁾";
        if (level < 80)
            return "󰂁";
        return "󰁹";
    }

    function label() {
        if (level < 0)
            return "";
        return level + "%";
    }
}
