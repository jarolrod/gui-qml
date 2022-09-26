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
        Page {
            anchors.fill: parent
            background: null
            ColumnLayout {
                width: 600
                spacing: 0
                anchors.centerIn: parent
                Component.onCompleted: nodeModel.startNodeInitializionThread();
                CircularProgressBar {
                    Layout.alignment: Qt.AlignCenter
                    value: nodeModel.verificationProgress
                    content: ColumnLayout {
                        width: 200
                        spacing: 10
                        Button {
                            id: icon_button
                            padding: 0
                            display: AbstractButton.IconOnly
                            height: 40
                            width: 40
                            icon.source: "image://images/bitcoin-circle"
                            icon.color: Theme.color.neutral9
                            icon.height: 40
                            icon.width: 40
                            background: null
                            Layout.alignment: Qt.AlignCenter
                            Layout.topMargin: 30
                        }
                        Header {
                            bold: true
                            headerSize: 24
                            header: qsTr("Downloading")
                            description: qsTr("12 min left")
                            Layout.alignment: Qt.AlignCenter
                            Layout.topMargin: 5
                        }
                    }
                }
            }
         }
    }
}
