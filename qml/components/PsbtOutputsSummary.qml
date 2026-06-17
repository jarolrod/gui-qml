// Copyright (c) 2026 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.bitcoincore.qt 1.0

import "../controls"

ColumnLayout {
    id: root
    objectName: "psbtOutputsSummary"

    property var outputModel: null
    property WalletQmlModelTransaction transaction: null

    spacing: 15

    Separator {
        Layout.fillWidth: true
    }

    Column {
        id: outputsList
        objectName: "psbtReviewOutputsList"
        Layout.fillWidth: true
        spacing: 0
        property int count: outputRepeater.count

        Repeater {
            id: outputRepeater
            model: root.outputModel

            delegate: Item {
                id: delegate
                implicitHeight: delegateColumn.implicitHeight
                height: implicitHeight
                width: outputsList.width

                required property string primaryText
                required property string secondaryText
                required property string amount
                required property string amountUnitLabel
                required property string outputType
                required property bool walletOwned
                required property int index
                property bool expanded: false
                readonly property bool expandable: secondaryText.length > 0
                readonly property string amountText: amountUnitLabel.length > 0 ? amount + " " + amountUnitLabel : amount
                readonly property string outputLabel: walletOwned
                    ? qsTr("%1 · wallet-owned").arg(outputType)
                    : outputType

                activeFocusOnTab: expandable
                Accessible.role: expandable ? Accessible.Button : Accessible.StaticText
                Accessible.name: qsTr("%1, %2, amount %3").arg(primaryText).arg(outputLabel).arg(amountText)
                Accessible.description: expanded ? qsTr("Hide output details") : qsTr("Show output details")
                Accessible.onPressAction: click()

                function click() {
                    if (expandable) {
                        expanded = !expanded
                    }
                }

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        delegate.click()
                        event.accepted = true
                    }
                }

                onExpandableChanged: {
                    if (!expandable) {
                        expanded = false
                    }
                }

                Column {
                    id: delegateColumn
                    width: parent.width
                    spacing: 0

                    Item {
                        width: 1
                        height: 15
                    }

                    CoreText {
                        objectName: "psbtReviewOutput" + index + "TypeText"
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        wrap: false
                        elide: Text.ElideRight
                        text: delegate.outputLabel
                        font: Theme.text.caption.font
                        lineHeight: Theme.text.caption.lineHeight
                        lineHeightMode: Text.FixedHeight
                        color: Theme.color.neutral7
                    }

                    Item {
                        width: 1
                        height: 5
                    }

                    RowLayout {
                        width: parent.width
                        spacing: 10

                        HoverHandler {
                            enabled: delegate.expandable
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            enabled: delegate.expandable
                            onTapped: delegate.click()
                        }

                        CoreText {
                            objectName: "psbtReviewOutput" + index + "PrimaryText"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrap: false
                            elide: Text.ElideRight
                            text: delegate.primaryText
                            font: Theme.text.description.font
                            lineHeight: Theme.text.description.lineHeight
                            lineHeightMode: Text.FixedHeight
                            color: Theme.color.neutral9
                        }

                        Item {
                            id: amountDisplay
                            objectName: "psbtReviewOutput" + index + "Amount"
                            property string text: delegate.amountText
                            implicitWidth: amountRow.implicitWidth
                            implicitHeight: amountRow.implicitHeight
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop

                            RowLayout {
                                id: amountRow
                                anchors.fill: parent
                                spacing: 5

                                CoreText {
                                    text: delegate.amount
                                    font: Theme.text.description.font
                                    lineHeight: Theme.text.description.lineHeight
                                    lineHeightMode: Text.FixedHeight
                                    wrap: false
                                    color: Theme.color.neutral9
                                }

                                CoreText {
                                    visible: delegate.amountUnitLabel.length > 0
                                    text: delegate.amountUnitLabel
                                    font: Theme.text.description.font
                                    lineHeight: Theme.text.description.lineHeight
                                    lineHeightMode: Text.FixedHeight
                                    wrap: false
                                    color: Theme.color.neutral9
                                }
                            }
                        }
                    }

                    Item {
                        width: 1
                        height: 10
                        visible: delegate.expanded
                    }

                    TextEdit {
                        objectName: "psbtReviewOutput" + index + "SecondaryText"
                        width: parent.width
                        visible: delegate.expanded
                        readOnly: true
                        selectByMouse: true
                        text: delegate.secondaryText
                        wrapMode: Text.WordWrap
                        leftPadding: 0
                        topPadding: 0
                        rightPadding: 0
                        bottomPadding: 0
                        height: visible ? Math.max(contentHeight, 21) : 0
                        font: Theme.text.description.font
                        color: Theme.color.neutral9
                    }

                    Item {
                        width: 1
                        height: 15
                        visible: delegate.index < outputsList.count - 1
                    }

                    Separator {
                        width: parent.width
                        visible: delegate.index < outputsList.count - 1
                    }
                }

                FocusBorder {
                    visible: delegate.activeFocus
                    topMargin: 0
                    bottomMargin: 0
                    leftMargin: -4
                    rightMargin: -4
                }
            }
        }
    }

    BitcoinAmountDisplayField {
        objectName: "psbtReviewFeeField"
        Layout.topMargin: 10
        labelText: qsTr("Fee")
        labelPixelSize: Theme.text.description.pixelSize
        labelColor: Theme.color.neutral7
        amountText: root.transaction ? root.transaction.feeAmount.display : ""
        unitText: root.transaction ? root.transaction.feeAmount.unitLabel : ""
    }

    Separator {
        Layout.fillWidth: true
    }

    BitcoinAmountDisplayField {
        objectName: "psbtReviewTotalField"
        labelWidth: 130
        labelText: qsTr("Total amount")
        amountText: root.transaction ? root.transaction.totalAmount.display : ""
        unitText: root.transaction ? root.transaction.totalAmount.unitLabel : ""
    }
}
