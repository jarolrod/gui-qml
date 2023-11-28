// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.bitcoincore.qt 1.0
import "../../controls"
import "../../components"

InformationPage {
    id: root
    navLeftItem: NavButton {
        iconSource: "image://images/caret-left"
        visible: !AppMode.onboarding
        text: qsTr("Back")
        onClicked: root.backClicked()
    }
    navCenterItem: Header {
        showHeader: !AppMode.onboarding
        headerBold: true
        headerSize: 18
        header: qsTr("Storage settings")
    }
    navRightItem: NavButton {
        visible: AppMode.onboarding
        text: qsTr("Done")
        onClicked: root.backClicked()
    }
    bannerActive: false
    bold: true
    showHeader: AppMode.onboarding
    headerText: qsTr("Storage settings")
    headerMargin: 0
    detailActive: true
    detailItem: StorageSettings {}
}
