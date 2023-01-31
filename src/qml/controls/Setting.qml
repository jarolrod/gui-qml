// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: root
    property bool last: parent && root === parent.children[parent.children.length - 1]
    required property string header
    property alias actionItem: action_loader.sourceComponent
    property string description

    spacing: 20
    Item {
        id: settingContent
        Layout.fillWidth: true
        state: "FILLED"

        states: [
            State {
                name: "FILLED"
                PropertyChanges { target: settingText; headerColor: Theme.color.neutral9 }
            },
            State {
                name: "HOVER"
                PropertyChanges { target: settingText; headerColor: Theme.color.orange }
            },
            State {
                name: "PRESSED"
                PropertyChanges { target: settingText; headerColor: Theme.color.orangeLight2 }
            }
        ]

        RowLayout {
            Header {
                id: settingText
                Layout.fillWidth: true
                center: false
                header: root.header
                headerSize: 18
                description: root.description
                descriptionSize: 15
                descriptionMargin: 0
            }
            Loader {
                id: action_loader
                active: true
                visible: active
                sourceComponent: root.actionItem
            }
        }
        // MouseArea {
        //     anchors.fill: parent
        //     hoverEnabled: true
        //     onEntered: {
        //         settingContent.state = "HOVER"
        //     }
        //     onExited: {
        //         settingContent.state = "FILLED"
        //     }
        //     onPressed: {
        //         settingContent.state = "PRESSED"
        //     }
        //     onReleased: {
        //         settingContent.state = "FILLED"
        //         settingContent.clicked()
        //     }
        // }
    }
    Loader {
        Layout.fillWidth: true
        Layout.columnSpan: 2
        active: !last
        visible: active
        sourceComponent: Rectangle {
            height: 1
            color: Theme.color.neutral5
        }
    }
}
