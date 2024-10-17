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
    property bool onboarding: false
    background: null
    clip: true

    PageStack {
        id: aboutSettingsStack
        anchors.fill: parent
        initialItem: aboutSettings
        
        Component {
            id: aboutSettings
            InformationPage {
                navLeftDetail: NavButton {
                    iconSource: "image://images/caret-left"
                    text: qsTr("Back")
                    onClicked: root.backClicked()
                }
                navMiddleDetail: Header {
                    headerBold: true
                    headerSize: 18
                    header: qsTr("About")
                }
                id: about_settings
                bannerActive: false
                bannerMargin: 0
                bold: true
                showHeader: root.onboarding
                headerText: qsTr("About")
                headerMargin: 0
                description: qsTr("Bitcoin Core is an open source project.\nIf you find it useful, please contribute.\n\n This is experimental software.")
                descriptionMargin: 20
                detailActive: true
                detailItem: AboutOptions {
                    onGoToDeveloper: {
                        aboutSettingsStack.push(devSettings)
                    }
                }
            }
        }
        Component {
            id: devSettings
            SettingsDeveloper {
                onboarding: root.onboarding
                onBackClicked: {
                    aboutSettingsStack.pop()
                }
            }
        }
    }
}
