// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"
import "../settings"

Pane {
    id: root
    signal backClicked()
    signal nextClicked()

    background: null

    contentItem: StackView {
        id: onboarding_storage_stack_view
        anchors.fill: parent
        initialItem: onboarding_storage_amount_page
    }

    Component {
        id: onboarding_storage_amount_page
        InformationPage {
            navLeftItem: NavButton {
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: root.backClicked()
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
                    customStorage: advancedStorage.loadedDetailItem.customStorage
                    customStorageAmount: advancedStorage.loadedDetailItem.customStorageAmount
                    Layout.maximumWidth: 450
                    Layout.alignment: Qt.AlignCenter
                }
                TextButton {
                    Layout.topMargin: 10
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Detailed settings")
                    onClicked: onboarding_storage_stack_view.push(advanced_storage_settings_page)
                }
            }
            buttonText: qsTr("Next")
            buttonMargin: 20

            onNextClicked: root.nextClicked()
        }
    }

    Component {
        id: advanced_storage_settings_page
        SettingsStorage {
            onBackClicked: onboarding_storage_stack_view.pop()
        }
    }
}
