// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

// The SyncTime component.

import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Label {
    property string syncTime: ""
    color: Theme.color.neutral6
    padding: 16
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    font.family: "Inter"
    font.styleName: "Semi Bold"
    font.pixelSize: 20
    text: syncTime
}
