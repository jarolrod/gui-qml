// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    id: root
    required property string link
    property string description: ""
    property int descriptionSize: 18
    property url iconSource: "image://images/export-outline"
    property int iconWidth: 22
    property int iconHeight: 22

    contentItem: RowLayout {
        spacing: 0
        width: parent.width
        Loader {
            Layout.fillWidth: true
            active: root.description.length > 0
            visible: active
            sourceComponent: Text {
                font.family: "Inter"
                font.styleName: "Regular"
                font.pixelSize: root.descriptionSize
                color: Theme.color.neutral7
                text: root.description
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        Button {
            leftPadding: 0
            icon.source: root.iconSource
            icon.color: Theme.color.neutral9
            icon.height: root.iconHeight
            icon.width: root.iconWidth
            background: null
            onClicked: Qt.openUrlExternally(link)
        }
    }
}
