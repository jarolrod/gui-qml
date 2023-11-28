// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.bitcoincore.qt 1.0
import "../../controls"
import "../../components"
import "../settings"

Pane {
    id: root
    signal onboardingFinished

    background: null

    Component.onCompleted: {
        AppMode.setOnboarding(true)
    }

    contentItem: StackView {
        id: wizard_stack_view
        anchors.fill: parent
        initialItem: onboarding_cover
    }

    Component {
        id: onboarding_cover
        OnboardingCover {
            onNextClicked: wizard_stack_view.push(onboarding_strengthen)
        }
    }

    Component {
        id: onboarding_strengthen
        OnboardingStrengthen {
            onNextClicked: wizard_stack_view.push(onboarding_blockclock)
            onBackClicked: wizard_stack_view.pop()
        }
    }

    Component {
        id: onboarding_blockclock
        OnboardingBlockclock {
            onNextClicked: wizard_stack_view.push(onboarding_storage_location)
            onBackClicked: wizard_stack_view.pop()
        }
    }

    Component {
        id: onboarding_storage_location
        OnboardingStorageLocation {
            onNextClicked: wizard_stack_view.push(onboarding_storage_amount)
            onBackClicked: wizard_stack_view.pop()
        }
    }

    Component {
        id: onboarding_storage_amount
        OnboardingStorageAmount {
            onNextClicked: wizard_stack_view.push(onboarding_connection)
            onBackClicked: wizard_stack_view.pop()
        }
    }

    Component {
        id: onboarding_connection
        OnboardingConnection {
            onNextClicked: root.onboardingFinished()
            onBackClicked: wizard_stack_view.pop()
        }
    }
}

