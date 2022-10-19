// Copyright (c) 2021 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../controls"

ApplicationWindow {
    id: appWindow
    title: "Bitcoin Core App"
    minimumWidth: 640
    minimumHeight: 665
    color: Theme.color.background
    visible: true

    StackView {
        id: main
        initialItem: onboardingWizard
        anchors.fill: parent
    }

    Wizard {
        id: onboardingWizard
        anchors.fill: parent
        views: [
            "onboarding/onboarding01.qml",
            "onboarding/onboarding02.qml",
            "onboarding/onboarding03.qml",
            "onboarding/onboarding04.qml",
            "onboarding/onboarding05.qml",
            "onboarding/onboarding06.qml",
        ]
        onFinishedChanged: main.push(node)
    }

    Component {
        id: node
        SwipeView {
            id: nodeViews
            anchors.fill: parent
            interactive: false
            orientation: Qt.Horizontal
            Loader {
                source: "node.qml"
            }
            Loader {
                source: "settings/settings01.qml"
            }
        }
    }
}
