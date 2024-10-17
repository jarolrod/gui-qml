// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"
import "../settings"

Page {
    background: null
    clip: true
    PageStack {
        id: storages
        anchors.fill: parent
        initialItem: InformationPage {
            navLeftDetail: NavButton {
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: swipeView.decrementCurrentIndex()
            }
            bannerActive: false
            bold: true
            headerText: qsTr("Storage")
            headerMargin: 0
            description: qsTr("Data retrieved from the Bitcoin network is stored on your device.\nYou have 500GB of storage available.")
            descriptionMargin: 10
            detailActive: true
            detailItem: ColumnLayout {
                spacing: 0
                StorageOptions {
                    customStorage: true //advanced.customStorage
                    customStorageAmount: 10 //advanced.customStorageAmount
                    Layout.maximumWidth: 450
                    Layout.alignment: Qt.AlignCenter
                }
                TextButton {
                    Layout.topMargin: 10
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Detailed settings")
                    onClicked: storages.push(advanced)
                }
            }
            buttonText: qsTr("Next")
            buttonMargin: 20
        } 
 
        Component {
            id: advanced
            SettingsStorage {
                id: storage
                navRightDetail: NavButton {
                    text: qsTr("Done")
                    onClicked: {
                        storages.pop()
                    }
                }
            }
        }
    }
}
