import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

Page {
    background: null
    Layout.fillWidth: true
    clip: true
    SwipeView {
        id: introductions
        anchors.fill: parent
        interactive: false
        orientation: Qt.Horizontal
        Loader {
            source:"settings02.qml"
        }
        Loader {
            source:"settings03.qml"
        }
        Loader {
            source:"settings04.qml"
        }
    }
}
