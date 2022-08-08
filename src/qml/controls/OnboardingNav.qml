// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    property alias navButton: button_loader.sourceComponent
    //property bool left: true

    contentItem: RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.margins: 11
            spacing: 0
            Loader {
                id: button_loader
                active: true
                visible: active
                sourceComponent: root.navButton
            }
        }
}
