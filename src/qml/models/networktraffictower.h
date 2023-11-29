// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef BITCOIN_QML_MODELS_NETWORKTRAFFICTOWER_H
#define BITCOIN_QML_MODELS_NETWORKTRAFFICTOWER_H

#include <qml/models/nodemodel.h>

#include <QList>
#include <QObject>
#include <QQueue>

class NetworkTrafficTower : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float )
    Q_PROPERTY(float totalBytesRecv READ totalBytesRecv NOTIFY totalBytesRecvChanged)
    Q_PROPERTY(float totalBytesSent READ totalBytesSent NOTIFY totalBytesSentChanged)

public:
    explicit NetworkTrafficTower(NodeModel& node);

    float totalBytesRecv() const { return m_total_bytes_recv; }
    float totalBytesSent() const { return m_total_bytes_sent; }

public Q_SLOTS:
    Q_INVOKABLE void setDuration(int new_duration);

private Q_SLOTS:
    void setTotalBytesRecv(float new_total_bytes);
    void setTotalBytesSent(float new_total_bytes);
    void broadcastDurationTrafficData();

Q_SIGNALS:
    void totalBytesRecvChanged();
    void totalBytesSentChanged();

private:
    struct DurationTrafficData {
        int duration_samples{0};
        int lookback_samples{0};
        float smoothed_max_recv_rate{0.0f};
        float smoothed_max_sent_rate{0.0f};
        QList<float> smoothed_recv_rate_list{QList<float>()};
        QList<float> smoothed_sent_rate_list{QList<float>()};
        float lookback_running_sum_recv{0.0f};
        float lookback_running_sum_sent{0.0f};

        void addNewRates(float recv_rate, float sent_rate);
        float findMaxRate(QList<float> * smoothed_rate_list);
    };

    void updateTrafficStats();

    NodeModel& m_node;
    int m_duration{0};
    static constexpr size_t m_duration_periods_count = 4;
    static constexpr std::array<int, m_duration_periods_count> m_duration_periods = {
        300,    // five_minutes_samples
        3600,   // one_hour_samples
        43200,  // twelve_hours_samples
        86400   // one_day_samples
    };
    std::array<DurationTrafficData, m_duration_periods_count> m_duration_traffic_data_array;
    float * m_duration_max_recv_rate{nullptr};
    float * m_duration_max_sent_rate{nullptr};
    QList<float> * m_duration_recv_rate_list{nullptr};
    QList<float> * m_duration_sent_rate_list{nullptr};
    int m_smoothing_factor{10};
    float m_total_bytes_recv{0.0f};
    float m_total_bytes_sent{0.0f};
};

#endif // BITCOIN_QML_MODELS_NETWORKTRAFFICTOWER_H
