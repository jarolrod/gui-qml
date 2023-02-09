// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.bitcoincore.qt 1.0

import "../controls"

Item {
    id: root

    implicitWidth: 200
    implicitHeight: 200

    property alias header: mainText.text
    //property alias headerSize: 32
    property alias subText: subText.text
    property int penWidth: 4
    property int headerSize: 24
    property int iconSize: 40
    property int mainTextSize: 32
    property int subTextSize: 18
    property int stateTopMargin: 4
    property int stateBottomMargin: 5
    property int peersIndicatorWidth: 3
    property int peersIndicatorTopMargin: 20
    property int peersIndicatorSpacing: 5
    property bool synced: nodeModel.verificationProgress > 0.999
    property bool paused: false
    property bool conns: true

    BlockClockDial {
        id: dial
        anchors.fill: parent
        timeRatioList: chainModel.timeRatioList
        verificationProgress: nodeModel.verificationProgress
        paused: root.paused
        synced: nodeModel.verificationProgress > 0.999
        penWidth: root.penWidth
        backgroundColor: Theme.color.neutral2
        timeTickColor: Theme.color.neutral5
    }

    Button {
        id: bitcoinIcon
        background: null
        icon.source: "image://images/bitcoin-circle"
        icon.color: Theme.color.neutral9
        icon.width: root.iconSize
        icon.height: root.iconSize
        anchors.bottom: mainText.top
        anchors.horizontalCenter: root.horizontalCenter
    }

    Label {
        id: mainText
        anchors.centerIn: parent
        font.family: "Inter"
        font.styleName: "Semi Bold"
        font.pixelSize: root.mainTextSize
        color: Theme.color.neutral9
    }

    Label {
        id: subText
        anchors.top: mainText.bottom
        anchors.horizontalCenter: root.horizontalCenter
        font.family: "Inter"
        font.styleName: "Semi Bold"
        font.pixelSize: root.subTextSize
        color: Theme.color.neutral4
    }

    RowLayout {
        id: peersIndicator
        anchors.top: subText.bottom
        anchors.topMargin: root.peersIndicatorTopMargin
        anchors.horizontalCenter: root.horizontalCenter
        spacing: root.peersIndicatorSpacing
        Repeater {
            model: 5
            Rectangle {
                width: root.peersIndicatorWidth
                height: root.peersIndicatorWidth
                radius: root.peersIndicatorWidth/2
                color: Theme.color.neutral9
            }
        }
    }

    MouseArea {
        anchors.fill: dial
        onClicked: {
            root.paused = !root.paused
            nodeModel.pause = root.paused
        }
    }

    states: [
        State {
            name: "intialBlockDownload"; when: !synced && !paused && conns
            PropertyChanges {
                target: root
                header: Math.round(nodeModel.verificationProgress * 100) + "%"
                subText: Math.round(nodeModel.remainingSyncTime/60000) > 0 ? Math.round(nodeModel.remainingSyncTime/60000) + "mins" : Math.round(nodeModel.remainingSyncTime/1000) + "secs"
            }
        },

        State {
            name: "blockClock"; when: synced && !paused && conns
            PropertyChanges {
                target: root
                header: Number(nodeModel.blockTipHeight).toLocaleString(Qt.locale(), 'f', 0)
                subText: "Blocktime"
            }
        },

        State {
            name: "Manual Pause"; when: paused
            PropertyChanges {
                target: root
                header: "Paused"
                headerSize: root.headerSize
                subText: "Tap to resume"
            }
            PropertyChanges {
                target: bitcoinIcon
                anchors.bottomMargin: root.stateBottomMargin
            }
            PropertyChanges {
                target: subText
                anchors.topMargin: root.stateTopMargin
            }
        },

        State {
            name: "Connecting"; when: !paused && !conns
            PropertyChanges {
                target: root
                header: "Connecting"
                headerSize: root.headerSize
                subText: "Please Wait"
            }
            PropertyChanges {
                target: bitcoinIcon
                anchors.bottomMargin: root.stateBottomMargin
            }
            PropertyChanges {
                target: subText
                anchors.topMargin: root.stateTopMargin
            }
        }
    ]

    function doubleSize() {
        root.implicitWidth *= 2
        root.implicitHeight *= 2
        root.penWidth *= 2
        root.headerSize *= 2
        root.iconSize *= 2
        root.mainTextSize *= 2
        root.subTextSize *= 2
        root.stateTopMargin *= 2
        root.stateBottomMargin *= 2
        root.peersIndicatorWidth *= 2
        root.peersIndicatorTopMargin *= 2
        root.peersIndicatorSpacing *= 2
    }

    function halfSize() {
        root.implicitWidth /= 2
        root.implicitHeight /= 2
        root.penWidth /= 2
        root.headerSize /= 2
        root.iconSize /= 2
        root.mainTextSize /= 2
        root.subTextSize /= 2
        root.stateTopMargin /= 2
        root.stateBottomMargin /= 2
        root.peersIndicatorWidth /= 2
        root.peersIndicatorTopMargin /= 2
        root.peersIndicatorSpacing /= 2
    }
}
