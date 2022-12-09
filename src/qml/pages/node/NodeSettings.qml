// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"
import "../settings"

Page {
    id: nodeSettings
    property alias navMiddleDetail: node_settings.navMiddleDetail
    property alias navRightDetail: node_settings.navRightDetail
    background: null
    StackView {
        id: nodeSettingsView
        initialItem: node_settings
        anchors.fill: parent
    }
    Page {
        id: node_settings
        property alias navMiddleDetail: navbar.middleDetail
        property alias navRightDetail: navbar.rightDetail
        background: null
        header: NavigationBar {
            id: navbar
        }
        ColumnLayout {
            spacing: 0
            width: parent.width
            ColumnLayout {
                spacing: 20
                Layout.maximumWidth: 450
                Layout.topMargin: 30
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.alignment: Qt.AlignCenter
                Setting {
                    Layout.fillWidth: true
                    header: qsTr("Dark Mode")
                    actionItem: OptionSwitch {
                        checked: Theme.dark
                        onToggled: Theme.toggleDark()
                    }
                }
                Setting {
                    Layout.fillWidth: true
                    header: qsTr("About")
                    actionItem: NavButton {
                        iconSource: "image://images/caret-right"
                        background: null
                        onClicked: {
                            nodeSettingsView.push(about_page)
                        }
                    }
                }
                Setting {
                    Layout.fillWidth: true
                    header: qsTr("Storage")
                    actionItem: NavButton {
                        iconSource: "image://images/caret-right"
                        background: null
                        onClicked: {
                            nodeSettingsView.push(storage_page)
                        }
                    }
                }
                Setting {
                    Layout.fillWidth: true
                    header: qsTr("Connection")
                    actionItem: NavButton {
                        iconSource: "image://images/caret-right"
                        background: null
                        onClicked: {
                            nodeSettingsView.push(connection_page)
                        }
                    }
                }
            }
        }
    }
    SettingsAbout {
        id: about_page
        navLeftDetail: NavButton {
            iconSource: "image://images/caret-left"
            text: qsTr("Back")
            onClicked: {
                nodeSettingsView.pop()
            }
        }
    }
    SettingsStorage {
        id: storage_page
        navLeftDetail: NavButton {
            iconSource: "image://images/caret-left"
            text: qsTr("Back")
            onClicked: {
                nodeSettingsView.pop()
            }
        }
    }
    SettingsConnection {
        id: connection_page
        navLeftDetail: NavButton {
            iconSource: "image://images/caret-left"
            text: qsTr("Back")
            onClicked: {
                nodeSettingsView.pop()
            }
        }
    }
}
