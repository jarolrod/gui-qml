// Copyright (c) 2021 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../components"
import "../../controls"

Page {
    id: root
    signal finished
    background: null
    clip: true


    PageStack {
        id: onboardingStack
        anchors.fill: parent
        initialItem: cover

        Component {
            id: cover
            OnboardingCover {
                onNext: onboardingStack.push(strengthen)
            }
        }
        Component {
            id: strengthen
            OnboardingStrengthen {
                onBack: onboardingStack.pop()
                onNext: onboardingStack.push(blockclock)
            }
        }
        Component {
            id: blockclock
            OnboardingBlockclock {
                onBack: onboardingStack.pop()
                onNext: onboardingStack.push(storageLocation)
            }
        }
        Component {
            id: storageLocation
            OnboardingStorageLocation {
                onBack: onboardingStack.pop()
                onNext: onboardingStack.push(storageAmount)
            }
        }
        Component {
            id: storageAmount
            OnboardingStorageAmount {
                onBack: onboardingStack.pop()
                onNext: onboardingStack.push(connection)
            }
        }
        Component {
            id: connection
            OnboardingConnection {
                onBack: onboardingStack.pop()
                onNext: root.finished()
            }
        }
    }
}
