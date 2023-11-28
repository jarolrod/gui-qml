// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <qml/appmode.h>

#include <QObject>

void AppMode::setOnboarding(bool onboarding)
{
    if (m_onboarding != onboarding) {
        m_onboarding = onboarding;
        Q_EMIT onboardingChanged();
    }
}