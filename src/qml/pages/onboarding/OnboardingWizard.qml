// Copyright (c) 2024 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

SwipeView {
    id: root
    signal finished
    interactive: false

    OnboardingCover {
        onNext: root.incrementCurrentIndex()
    }
    OnboardingStrengthen {
        onBack: root.decrementCurrentIndex()
        onNext: root.incrementCurrentIndex()
    }
    OnboardingBlockclock {
        onBack: root.decrementCurrentIndex()
        onNext: root.incrementCurrentIndex()
    }
    OnboardingStorageLocation {
        onBack: root.decrementCurrentIndex()
        onNext: root.incrementCurrentIndex()
    }
    OnboardingStorageAmount {
        onBack: root.decrementCurrentIndex()
        onNext: root.incrementCurrentIndex()
    }
    OnboardingConnection {
        onBack: root.decrementCurrentIndex()
        onNext: root.finished()
    }
}