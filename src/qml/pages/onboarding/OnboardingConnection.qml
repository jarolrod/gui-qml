// Copyright (c) 2022 The Bitcoin Core developers
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
    signal backClicked
    signal nextClicked

    background: null

    contentItem: StackView {
        id: onboarding_connection_stack_view
        anchors.fill: parent
        initialItem: onboarding_connection_page
    }

    Component {
        id: onboarding_connection_page
        InformationPage {
            navLeftItem: NavButton {
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: root.backClicked()
            }
            bannerItem: Image {
                Layout.topMargin: 20
                Layout.alignment: Qt.AlignCenter
                source: Theme.image.storage
                sourceSize.width: 200
                sourceSize.height: 200
            }
            bold: true
            headerText: qsTr("Starting initial download")
            headerMargin: 30
            description: qsTr("The application will connect to the Bitcoin network and start downloading and verifying transactions.\n\nThis may take several hours, or even days, based on your connection.")
            descriptionMargin: 10
            detailActive: true
            detailTopMargin: 10
            detailItem: RowLayout {
                TextButton {
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Connection settings")
                    onClicked: onboarding_connection_stack_view.push(advanced_connection_settings)
                }
            }
            lastPage: true
            buttonText: qsTr("Next")
            buttonMargin: 20

            onNextClicked: root.nextClicked()
        }
    }

    Component {
        id: advanced_connection_settings
        SettingsConnection {
            onBackClicked: {
                onboarding_connection_stack_view.pop()
            }
        }
    }
}
