// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <qml/systemprofiler.h>

#if defined(_WIN32)
#include <windows.h>
#endif

#include <QProcess>


SystemProfiler::SystemProfiler(QObject* parent)
    : QObject(parent)
{
    initProfiler();
}

void SystemProfiler::setSystemBaseColor(QColor base_color)
{
    // Convert QColor's 8-bit RGB values to linear RGB values
    double linearR = base_color.redF();
    double linearG = base_color.greenF();
    double linearB = base_color.blueF();

    // Constants for the luminance formula
    const double RED_FACTOR = 0.2126;
    const double GREEN_FACTOR = 0.7152;
    const double BLUE_FACTOR = 0.0722;

    // Calculate luminance using the formula
    double luminance = RED_FACTOR * linearR + GREEN_FACTOR * linearG + BLUE_FACTOR * linearB;

    if (luminance <= 0.5) {
        m_dark_mode = true;
    } else {
        m_dark_mode = false;
    }

    m_system_base_color = base_color;
    Q_EMIT darkModeChanged();
}

void SystemProfiler::getLinuxDarkModePreference()
{
    QProcess process;

    QObject::connect(&process, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        m_dconf_available = false;
        m_dark_mode = true;
    });

    process.start("dconf", QStringList() << "read" << "/org/gnome/desktop/interface/color-scheme");

    if (process.waitForFinished(-1)) {
        QString output = process.readAllStandardOutput().trimmed();
        bool isDark = output.contains("dark", Qt::CaseInsensitive);
        watchLinuxDarkModePreference();
        m_dconf_available = true;
        m_dark_mode = isDark;
    } else {
        m_dconf_available = false;
        m_dark_mode = true;
    }

    Q_EMIT darkModeChanged();
}

void SystemProfiler::getWindowsDarkModePreference()
{
    // Get the current theme
    HKEY hKey;
    LONG lRes = RegOpenKeyExW(HKEY_CURRENT_USER, L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize", 0, KEY_READ, &hKey);
    if (lRes != ERROR_SUCCESS) {
        m_dark_mode = true;
        return;
    }

    DWORD dwSize = sizeof(DWORD);
    DWORD dwType = REG_DWORD;
    DWORD dwValue = 0;

    lRes = RegQueryValueExW(hKey, L"AppsUseLightTheme", nullptr, &dwType, (LPBYTE)&dwValue, &dwSize);
    if (lRes != ERROR_SUCCESS) {
        m_dark_mode = true;
        return;
    }

    if (dwValue == 0) {
        m_dark_mode = true;
    } else {
        m_dark_mode = false;
    }

    Q_EMIT darkModeChanged();
}

void SystemProfiler::watchLinuxDarkModePreference()
{
    m_theme_watch_process.start("dconf", QStringList() << "watch" << "/org/gnome/desktop/interface/color-scheme");

    QObject::connect(&m_theme_watch_process, &QProcess::readyReadStandardOutput, [this]() {
        QString output = m_theme_watch_process.readAllStandardOutput().trimmed();
        bool isDark = output.contains("dark", Qt::CaseInsensitive);
        m_dark_mode = isDark;
        Q_EMIT darkModeChanged();
    });
}


void SystemProfiler::initProfiler()
{
    #ifdef Q_OS_LINUX
        getLinuxDarkModePreference();
    #elif defined(Q_OS_WIN)
        getWindowsDarkModePreference();
    #endif

    Q_EMIT darkModeChanged();
}