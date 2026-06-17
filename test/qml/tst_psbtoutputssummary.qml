// Copyright (c) 2026 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtTest 1.2
import "../../qml/components"

TestCase {
    name: "PsbtOutputsSummary"
    when: windowShown
    width: 700
    height: 500

    ListModel {
        id: psbtOutputModel
    }

    Component {
        id: summaryComponent

        PsbtOutputsSummary {
            width: 640
            height: 360
            outputModel: psbtOutputModel
        }
    }

    function findObjectByName(root, objectName) {
        if (!root) {
            return null
        }
        if (root.objectName === objectName) {
            return root
        }

        if (root.contentItem) {
            const contentResult = findObjectByName(root.contentItem, objectName)
            if (contentResult) {
                return contentResult
            }
        }

        const children = root.children || []
        for (let i = 0; i < children.length; ++i) {
            const childResult = findObjectByName(children[i], objectName)
            if (childResult) {
                return childResult
            }
        }

        return null
    }

    function init() {
        psbtOutputModel.clear()
        psbtOutputModel.append({
            primaryText: "bc1qaddress",
            secondaryText: "",
            amount: "0.00001500",
            amountUnitLabel: "BTC",
            outputType: "Address",
            walletOwned: false
        })
        psbtOutputModel.append({
            primaryText: "Data output",
            secondaryText: "6a03010203",
            amount: "0.00000000",
            amountUnitLabel: "BTC",
            outputType: "Data",
            walletOwned: false
        })
        psbtOutputModel.append({
            primaryText: "Unknown output script",
            secondaryText: "5101ff",
            amount: "0.00001000",
            amountUnitLabel: "BTC",
            outputType: "Unknown",
            walletOwned: false
        })
    }

    function test_renders_imported_psbt_output_rows() {
        const summary = createTemporaryObject(summaryComponent, this)
        verify(summary !== null)

        const outputsList = findObjectByName(summary, "psbtReviewOutputsList")
        verify(outputsList !== null)
        compare(outputsList.count, 3)

        compare(findObjectByName(summary, "psbtReviewOutput0TypeText").text, "Address")
        compare(findObjectByName(summary, "psbtReviewOutput0PrimaryText").text, "bc1qaddress")
        compare(findObjectByName(summary, "psbtReviewOutput0Amount").text, "0.00001500 BTC")

        compare(findObjectByName(summary, "psbtReviewOutput1TypeText").text, "Data")
        compare(findObjectByName(summary, "psbtReviewOutput1PrimaryText").text, "Data output")
        compare(findObjectByName(summary, "psbtReviewOutput1SecondaryText").text, "6a03010203")

        compare(findObjectByName(summary, "psbtReviewOutput2TypeText").text, "Unknown")
        compare(findObjectByName(summary, "psbtReviewOutput2PrimaryText").text, "Unknown output script")
        compare(findObjectByName(summary, "psbtReviewOutput2SecondaryText").text, "5101ff")
    }
}
