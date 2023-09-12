// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

InformationPage {
    signal backClicked

    id: root
    navLeftItem: NavButton {
        iconSource: "image://images/caret-left"
        text: qsTr("Back")
        onClicked: root.backClicked()
    }
    navCenterItem: Header {
        headerBold: true
        headerSize: 18
        header: qsTr("Developer settings")
    }

    bannerActive: false
    bold: true
    headerText: qsTr("Developer options")
    headerMargin: 0
    detailActive: true
    detailItem: DeveloperOptions {}
}
