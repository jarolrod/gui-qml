import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    font.family: "Inter"
    font.styleName: "Semi Bold"
    font.pixelSize: 18
    text: nodeModel.networkName();
    contentItem: Text {
        text: parent.text
        font: parent.font
        color: Theme.color.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        id: rectColor
        implicitHeight: 46
        implicitWidth: 300
        color: getBackgroundColor(parent.text)
        radius: 5
    }

    function getBackgroundColor(net_name) {
      var rectColor = "orange"
      switch (net_name) {
        case "regtest":
            rectColor = "blue";
            break;
        case "test":
            rectColor = "green";
            break;
        case "signet":
            rectColor = "yellow";
            break;
        default:
            rectColor = "orange";
        }
      return rectColor
    }
}
