// Copyright (c) 2026 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Window 2.15
import QtTest 1.2

import "../../qml/pages/wallet"

TestCase {
    name: "SendReviewPsbtSigning"
    when: windowShown
    width: 900
    height: 700

    Window {
        id: testWindow
        width: 900
        height: 700
        visible: true
    }

    Component {
        id: sendReviewComponent

        SendReview {
            width: 900
            height: 700
            inspectionMode: true
        }
    }

    function init() {
        testWalletModel.resetPsbtSigningTestState()
        testWalletModel.currentTransactionCanSend = false
        testWalletModel.currentTransactionCanBroadcast = false
        testWalletModel.currentTransactionCanSign = true
        testWalletModel.hasExternalSigner = false
    }

    function createPage() {
        const page = createTemporaryObject(sendReviewComponent, testWindow.contentItem)
        verify(page !== null)
        wait(0)
        return page
    }

    function test_imported_sign_only_psbt_shows_sign_and_save() {
        const page = createPage()

        compare(findChild(page, "sendReviewSendButton").visible, false)
        compare(findChild(page, "sendReviewBroadcastButton").visible, false)
        compare(findChild(page, "sendReviewExternalSignerButton").visible, false)
        compare(findChild(page, "sendReviewSignPsbtButton").visible, true)
        compare(findChild(page, "sendReviewSavePsbtButton").visible, true)
    }

    function test_imported_broadcastable_psbt_warning_does_not_hide_actions() {
        testWalletModel.currentTransactionCanSign = false
        testWalletModel.currentTransactionCanBroadcast = true
        testWalletModel.currentTransactionReviewMessage = "This transaction has one or more positive-value outputs that cannot be shown as a Bitcoin address. Review the script details before signing or broadcasting."

        const page = createPage()

        compare(findChild(page, "sendReviewCannotSignBanner").visible, true)
        compare(findChild(page, "sendReviewSendButton").visible, false)
        compare(findChild(page, "sendReviewSignPsbtButton").visible, false)
        compare(findChild(page, "sendReviewBroadcastButton").visible, true)
        compare(findChild(page, "sendReviewSavePsbtButton").visible, true)
    }

    function test_sign_button_signs_psbt_without_sending() {
        const page = createPage()
        const signButton = findChild(page, "sendReviewSignPsbtButton")
        verify(signButton !== null)

        signButton.clicked()

        compare(testWalletModel.signCurrentPsbtCalls, 1)
        compare(testWalletModel.signCurrentPsbtWithPassphraseCalls, 0)
        compare(testWalletModel.sendTransactionCalls, 0)
        compare(testWalletModel.broadcastCurrentTransactionCalls, 0)
        compare(page.sending, false)
    }

    function test_locked_signing_uses_sign_passphrase_path() {
        testWalletModel.signCurrentPsbtNeedsUnlock = true
        testWalletModel.signCurrentPsbtEnablesBroadcast = true

        const page = createPage()
        const signButton = findChild(page, "sendReviewSignPsbtButton")
        verify(signButton !== null)

        signButton.clicked()
        compare(testWalletModel.signCurrentPsbtCalls, 1)

        const popup = findChild(testWindow.contentItem, "sendReviewPassphrasePopup")
        verify(popup !== null)
        tryCompare(popup, "opened", true)

        const confirmButton = findChild(testWindow.contentItem, "sendReviewPassphraseConfirmButton")
        const passphraseField = findChild(testWindow.contentItem, "sendReviewPassphraseField")
        verify(confirmButton !== null)
        verify(passphraseField !== null)
        compare(confirmButton.text, "Unlock and sign")

        passphraseField.text = "correct horse battery staple"
        tryCompare(confirmButton, "enabled", true)
        confirmButton.clicked()

        compare(testWalletModel.signCurrentPsbtWithPassphraseCalls, 1)
        compare(testWalletModel.lastSignCurrentPsbtPassphrase, "correct horse battery staple")
        compare(testWalletModel.sendTransactionCalls, 0)
        compare(testWalletModel.currentTransactionCanBroadcast, true)
    }
}
