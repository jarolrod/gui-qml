// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    id: root
    property alias rightButton: right_button.sourceComponent
    property alias leftButton: left_button.sourceComponent
    property alias middleElement: middle_detail.sourceComponent
    property bool alignLeft: true
    height: 46
    contentItem: RowLayout {
        spacing: 0
        Layout.fillWidth: true
        Loader {
            id: left_button
            Layout.rightMargin: 10
            Layout.alignment: Qt.AlignLeft
            active: true
            visible: active
            sourceComponent: root.rightButton
        }
        Loader {
            id: middle_detail
            Layout.alignment: Qt.AlignHCenter
            active: true
            visible: active
            sourceComponent: root.middleElement
        }
        Loader {
            id: right_button
            Layout.rightMargin: 10
            Layout.alignment: Qt.AlignRight
            active: true
            visible: active
            sourceComponent: root.rightButton
        }
    }
}
