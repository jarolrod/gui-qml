// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

Item {
    signal backClicked

    id: root
    property alias showHeader: aboutSwipe.showHeader
    SwipeView {
        id: aboutSwipe
        property alias showHeader: about_settings.showHeader
        anchors.fill: parent
        interactive: false
        orientation: Qt.Horizontal
        InformationPage {
            id: about_settings

            navLeftItem: NavButton {
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: root.backClicked()
            }
            navCenterItem: Header {
                headerBold: true
                headerSize: 18
                header: qsTr("About")
            }

            bannerActive: false
            bannerMargin: 0
            bold: true
            headerText: qsTr("About")
            headerMargin: 0
            description: qsTr("Bitcoin Core is an open source project.\nIf you find it useful, please contribute.\n\n This is experimental software.")
            descriptionMargin: 20
            detailActive: true
            detailItem: AboutOptions {}
        }
        SettingsDeveloper {
            id: about_developer
            showHeader: about_settings.showHeader
            onBackClicked: aboutSwipe.decrementCurrentIndex()
        }
    }
}
