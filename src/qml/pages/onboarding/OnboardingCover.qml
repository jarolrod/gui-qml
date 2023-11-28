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
    signal nextClicked

    background: null

    contentItem: StackView {
        id: onboarding_cover_view
        anchors.fill: parent
        initialItem: cover_page
    }

    Component {
        id: cover_page
        InformationPage {
            navRightItem: NavButton {
                iconSource: "image://images/info"
                iconHeight: 24
                iconWidth: 24
                iconColor: Theme.color.neutral0
                iconBackground: Rectangle {
                    radius: 12
                    color: Theme.color.neutral9
                }
                onClicked: {
                    onboarding_cover_view.push(about_settings)
                }
            }
            bannerItem: Image {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                source: "image://images/app"
                // Bitcoin icon has ~11% padding
                sourceSize.width: 112
                sourceSize.height: 112
            }
            bannerMargin: 0
            bold: true
            headerText: qsTr("Bitcoin Core App")
            headerSize: 36
            description: qsTr("Be part of the Bitcoin network.")
            descriptionMargin: 10
            descriptionSize: 24
            subtext: qsTr("100% open-source & open-design")
            buttonText: qsTr("Start")

            onNextClicked: root.nextClicked()
        }
    }

    Component {
        id: about_settings
        SettingsAbout {
            onBackClicked: {
                onboarding_cover_view.pop()
            }
        }
    }
}
