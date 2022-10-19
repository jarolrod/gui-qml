// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    id: root
    property alias leftDetail: left_detail.sourceComponent
    property alias middleDetail: middle_detail.sourceComponent
    property alias rightDetail: right_detail.sourceComponent
    property int holderWidth: 40
    property int holderHeight: 46
    height: 46

    contentItem: RowLayout {
        spacing: 0
        Loader {
            id: left_detail
            active: true
            visible: active
            sourceComponent: root.leftDetail ?? createPlaceHolder()
        }
        Loader {
            id: middle_detail
            Layout.fillWidth: true
            active: true
            visible: active
            sourceComponent: root.middleDetail ?? createPlaceHolder()
        }
        Loader {
            id: right_detail
            active: true
            visible: active
            sourceComponent: root.rightDetail ?? createPlaceHolder()
        }
    }

    function createPlaceHolder() {
        const placeHolder = Qt.createQMLObject('Rectangle {
        color: "red"
        width: 20
        height: 20
    }');
        return placeHolder;
    }
}
