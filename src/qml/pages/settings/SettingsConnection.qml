// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

Page {
    id: root
    signal backClicked
    signal doneClicked
    property bool onboarding: false
    background: null
    clip: true

    PageStack {
        id: connectionSettingsStack
        anchors.fill: parent
        initialItem: connectionSettings
        
        Component {
            id: connectionSettings
            InformationPage {
                navLeftDetail: NavButton {
                    iconSource: "image://images/caret-left"
                    text: qsTr("Back")
                    onClicked: root.backClicked()
                }
                navMiddleDetail: NavButton {
                    text: qsTr("Cancel")
                }
                navRightDetail: NavButton {
                    text: qsTr("Done")
                    onClicked: root.doneClicked()
                }
                background: null
                clip: true
                bannerActive: false
                bold: true
                showHeader: root.onboarding
                headerText: qsTr("Connection settings")
                headerMargin: 0
                detailActive: true
                detailItem: ConnectionSettings {
                    onGoToProxy: {
                        connectionSettingsStack.push(proxySettings)
                    }
                }
            }
        }
}
    
        Component {
            id: proxySettings
            SettingsProxy {
                onboarding: root.onboarding
                onBackClicked: {
                    connectionSettingsStack.pop()
                }
            }
        }
    }
