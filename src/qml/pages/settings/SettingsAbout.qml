// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.bitcoincore.qt 1.0
import "../../controls"
import "../../components"

Pane {
    id: root
    signal backClicked

    background: null

    contentItem: StackView {
        id: about_stack_view
        anchors.fill: parent
        initialItem: about_settings
    }

    Component {
        id: about_settings
        InformationPage {
            id: about_settings_page
            navLeftItem: NavButton {
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: {
                    root.backClicked()
                }
            }
            navCenterItem:  Header {
                showHeader: !AppMode.onboarding
                headerBold: true
                headerSize: 18
                header: qsTr("About")
            }
            bannerActive: false
            bannerMargin: 0
            bold: true
            showHeader: AppMode.onboarding
            headerText: qsTr("About")
            headerMargin: 0
            description: qsTr("Bitcoin Core is an open source project.\nIf you find it useful, please contribute.\n\n This is experimental software.")
            descriptionMargin: 20
            detailActive: true
            detailItem: AboutOptions {
                onDeveloperSettings: {
                    about_settings_page.nextClicked()
                }
            }

            onNextClicked: about_stack_view.push(developer_settings)
        }
    }

    Component {
        id: developer_settings
        SettingsDeveloper {
            onBackClicked: {
                about_stack_view.pop()
            }
        }
    }
}