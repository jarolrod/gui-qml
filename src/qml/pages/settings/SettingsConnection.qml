// Copyright (c) 2022 The Bitcoin Core developers
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
    signal doneClicked

    background: null

    StackView {
        id: connection_settings_stack_view
        anchors.fill: parent
        initialItem: connection_settings
    }

    Component {
        id: connection_settings
        InformationPage {
            navLeftItem:  NavButton {
                visible: !AppMode.onboarding
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: root.backClicked()
            }
            navCenterItem:  Header {
                showHeader: !AppMode.onboarding
                headerBold: true
                headerSize: 18
                header: qsTr("Connection settings")
            }
            navRightItem:  NavButton {
                visible: AppMode.onboarding
                text: qsTr("Done")
                onClicked: root.doneClicked()
            }
            background: null
            clip: true
            bannerActive: false
            bold: true
            showHeader: AppMode.onboarding
            headerText: qsTr("Connection settings")
            headerMargin: 0
            detailActive: true
            detailItem: ConnectionSettings {
                onProxySettings: {
                    connection_settings_stack_view.push(proxy_settings)
                }
            }

            onNextClicked: connection_settings_view.push(proxy_settings)
        }
    }

    Component {
        id: proxy_settings
        SettingsProxy {
            onBackClicked: {
                connection_settings_view.pop()
            }
        }
    }
}
