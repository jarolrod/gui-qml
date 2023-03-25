// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef BITCOIN_QT_SYSTEMPROFILER_H
#define BITCOIN_QT_SYSTEMPROFILER_H

#include <QObject>
#include <QColor>
#include <QProcess>


class SystemProfiler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool darkMode READ darkMode NOTIFY darkModeChanged)
    Q_PROPERTY(QColor systemBaseColor READ systemBaseColor WRITE setSystemBaseColor)

public:
    explicit SystemProfiler(QObject* parent = nullptr);

    bool darkMode() const { return m_dark_mode; };
    QColor systemBaseColor() const { return m_system_base_color; };

public Q_SLOTS:
    void setSystemBaseColor(QColor base_color);
    void getLinuxDarkModePreference();
    void getWindowsDarkModePreference();

Q_SIGNALS:
    void darkModeChanged();

private:
    void initProfiler();
    void watchLinuxDarkModePreference();
    //void watchWindowsDarkModePreference();

    bool m_dark_mode{ true };
    bool m_dconf_available;
    QProcess m_theme_watch_process;
    bool m_manual_theme{ false };
    QColor m_system_base_color;
};

#endif // BITCOIN_QT_SYSTEMPROFILER_H