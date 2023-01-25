import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../controls"

ColumnLayout {
    spacing: 10
    Header {
        bold: true
        center: false
        header: qsTr("Default Proxy")
        headerSize: 24
        description: qsTr("Run peer connections through a proxy (SOCKS5) for improved privacy. The default proxy supports connections via IPv4, IPv6 and Tor. Tor connections can also be run through a separate Tor proxy.")
        descriptionSize: 15
    }
    Rectangle {
        height: 1
        color: Theme.color.neutral5
        Layout.fillWidth: true
    }
    Setting {
        Layout.topMargin: 10
        Layout.fillWidth: true
        header: qsTr("Enable")
        actionItem: OptionSwitch {}
    }
    Setting {
        Layout.topMargin: 10
        Layout.fillWidth: true
        header: qsTr("IP and Port")
        actionItem: RowLayout {
            ValueInput {
              id: default_ip
              description: "127.0.0.1"
            }
            Header {
              header: ":"
              headerSize: 18
            }
            ValueInput {
                id: default_port
                description: "9050"
            }
        }
    }
    Header {
        bold: true
        center: false
        header: qsTr("Tor Proxy")
        headerSize: 24
        description: qsTr("Enable to run Tor connections through a dedicated proxy.")
        descriptionSize: 15
        Layout.topMargin: 35
    }
    Rectangle {
        height: 1
        color: Theme.color.neutral5
        Layout.fillWidth: true
    }
    Setting {
        Layout.topMargin: 10
        Layout.fillWidth: true
        header: qsTr("Enable")
        actionItem: OptionSwitch {}
        description: qsTr("When disabled, Tor connections will use the default proxy (if enabled).")
    }
    Setting {
        Layout.topMargin: 10
        Layout.fillWidth: true
        header: qsTr("IP and Port")
        actionItem: RowLayout {
            ValueInput {
              id: tor_ip
              description: "127.0.0.1"
            }
            Header {
              header: ":"
              headerSize: 18
            }
            ValueInput {
                id: tor_port
                description: "9050"
            }
        }
    }
}
