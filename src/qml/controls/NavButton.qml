// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
    id: root
    property int textSize: 18
    property string iconSource: ""
    property int iconHeight: 24
    property int iconWidth: 24

    implicitHeight: implicitContentHeight
    implicitWidth: implicitContentWidth
    background: null
    contentItem: RowLayout {
        spacing: 0
        width: parent.width
        Loader {
           id: button_background
           Layout.fillWidth: true
           active: root.iconSource.toString().length > 0
           visible: active
           sourceComponent: Button {
               id: icon_button
               icon.source: root.iconSource
               icon.color: Theme.color.neutral9
               icon.height: root.iconHeight
               icon.width: root.iconWidth
               background: null
               onClicked: root.clicked()
           }
        }
        Loader {
           Layout.fillWidth: true
           active: root.text.length > 0
           visible: active
           sourceComponent: Button {
               id: container
               font.family: "Inter"
               font.styleName: "Regular"
               font.pixelSize: root.textSize
               background: null
               contentItem: Text {
                   font: container.font
                   color: Theme.color.neutral9
                   text: root.text
              }
              onClicked: root.clicked()
          }
      }
    }
}
