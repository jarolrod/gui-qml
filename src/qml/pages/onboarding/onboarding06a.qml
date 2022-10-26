// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.bitcoincore.qt 1.0
import "../../controls"
import "../../components"

Page {
    background: null
    Layout.fillWidth: true
    clip: true
    header: NavigationBar {
        leftDetail: NavButton {
            iconSource: "image://images/caret-left"
            text: "Back"
            onClicked: swipeView.currentIndex -= 1
        }
    }
    OnboardingInfo {
        height: parent.height
        width: Math.min(parent.width, 600)
        anchors.horizontalCenter: parent.horizontalCenter
        bannerItem: Image {
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignCenter
            source: Theme.image.storage
            sourceSize.width: 200
            sourceSize.height: 200
        }
        bold: true
        header: qsTr("Starting initial download")
        headerMargin: 30
        description: qsTr("The application will connect to the Bitcoin network and start downloading and verifying transactions.\n\nThis may take several hours, or even days, based on your connection.")
        descriptionMargin: 20
        detailActive: true
        detailItem: TextButton {
            text: "Connection settings"
            textSize: 18
            textColor: Theme.color.orange
            onClicked: {
              connections.incrementCurrentIndex()
              swipeView.inSubPage = true
            }
        }
        lastPage: true
        buttonText: "Next"
    }
}
