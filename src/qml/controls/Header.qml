// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

Item {
    id: root
    property bool bold: false
    property string header
    property int headerMargin
    property int headerSize: 28
    property string description
    property int descriptionMargin: 10
    property int descriptionSize: 18
    property string subtext
    property int subtextMargin
    property int subtextSize: 15
    implicitHeight: childrenRect.height
    ColumnLayout {
        spacing: 0
        width: parent.width
        Label {
            Layout.alignment: Qt.AlignCenter
            topPadding: root.headerMargin
            font.family: "Inter"
            font.styleName: root.bold ? "Semi Bold" : "Regular"
            font.pointSize: root.headerSize
            color: "#FFFFFF"
            text: root.header
        }
        Loader {
            height: sourceComponent.height
            width: sourceComponent.width
            Layout.alignment: Qt.AlignCenter
            active: root.description.length > 0
            sourceComponent: Label {
                topPadding: root.descriptionMargin
                font.family: "Inter"
                font.styleName: "Regular"
                font.pointSize: root.descriptionSize
                color: "#DEDEDE"
                text: root.description
            }
        }
        Loader {
            height: sourceComponent.height
            width: sourceComponent.width
            Layout.alignment: Qt.AlignCenter
            active: root.subtext.length > 0
            sourceComponent: Label {
                topPadding: root.subtextMargin
                font.family: "Inter"
                font.styleName: "Regular"
                font.pixelSize: root.subtextSize
                color: "#FFFFFF"
                text: root.subtext
            }
        }
    }
}
