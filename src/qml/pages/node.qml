// Copyright (c) 2021 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../controls"

Page {
    background: null
    clip: true
    Layout.fillWidth: true
    header: NavigationBar {
        rightDetail: NavButton {
            iconSource: "image://images/gear"
            iconHeight: 24
            onClicked: {
                nodeViews.incrementCurrentIndex()
            }
        }
    }
    ColumnLayout {
        width: 600
        spacing: 0
        anchors.centerIn: parent
        Component.onCompleted: nodeModel.startNodeInitializionThread();
        Image {
            Layout.alignment: Qt.AlignCenter
            source: "image://images/app"
            sourceSize.width: 64
            sourceSize.height: 64
        }
        BlockCounter {
            Layout.alignment: Qt.AlignCenter
            blockHeight: nodeModel.blockTipHeight
        }
        ProgressIndicator {
            width: 200
            Layout.alignment: Qt.AlignCenter
            progress: nodeModel.verificationProgress
        }
    }
 }
