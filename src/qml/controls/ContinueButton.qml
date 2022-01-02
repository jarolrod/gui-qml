// Copyright (c) 2021 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: button
    property int size: 18

    background: Rectangle {
        implicitHeight: 46
        implicitWidth: 300
        color: "#F7931A"
        radius: 5
    }

    contentItem: Text {
        text: parent.text
        font.family: "Inter"
        font.styleName: "Regular"
        font.pointSize: button.size
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
