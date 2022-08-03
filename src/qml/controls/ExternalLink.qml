// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
  property string link
  property string description
  property int descriptionSize: 18
  property string iconSource
  property int iconWidth: 30
  property int iconHeight: 30

  ContentItem: RowLayout {
    Loader {
        Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
        active: root.description.length > 0
        visible: active
        sourceComponent: Text {
            font.family: "Inter"
            font.styleName: "Regular"
            font.pixelSize: root.descriptionSize
            color: Theme.color.neutral8
            text: "<style>a:link { color: " + Theme.color.neutral8 + "; text-decoration: none;}</style>" + "<a href=\"" + link + "\">" + root.description + "</a>"
            onLinkActivated: Qt.openUrlExternally(link)
            horizontalAlignment: Text.AlignRight
            wrapMode: Text.WordWrap
          }
      }
      Loader {
          Layout.preferredWidth: root.iconWidth
          Layout.preferredHeight: root.iconHeight
          Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
          active: root.iconSource.length > 0
          visible: active
          sourceComponent: Image {
              horizontalAlignment: Image.AlignRight
              source: root.iconSource
              fillMode: Image.PreserveAspectFit
              mipmap: true
              MouseArea {
                  anchors.fill: parent
                  onClicked: {
                      Qt.openUrlExternally(link)
                    }
                }
            }
        }
    }
}
