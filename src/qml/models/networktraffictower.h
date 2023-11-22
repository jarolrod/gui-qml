// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef BITCOIN_QML_MODELS_NETWORKTRAFFICTOWER_H
#define BITCOIN_QML_MODELS_NETWORKTRAFFICTOWER_H

#include <qml/models/nodemodel.h>

#include <QObject>
#include <QQueue>

class NetworkTrafficTower : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float totalBytesRecv READ totalBytesRecv NOTIFY totalBytesRecvChanged)
    Q_PROPERTY(float totalBytesSent READ totalBytesSent NOTIFY totalBytesSentChanged)
    Q_PROPERTY(float maxRecvRateBps READ maxRecvRateBps NOTIFY maxRecvRateBpsChanged)
    Q_PROPERTY(float maxSentRateBps READ maxSentRateBps NOTIFY maxSentRateBpsChanged)
    Q_PROPERTY(QQueue<float> recvRateList READ recvRateList NOTIFY recvRateListChanged)
    Q_PROPERTY(QQueue<float> sentRateList READ sentRateList NOTIFY sentRateListChanged)

public:
    explicit NetworkTrafficTower(NodeModel& node);

    float totalBytesRecv() const { return m_total_bytes_recv; }
    float totalBytesSent() const { return m_total_bytes_sent; }
    float maxRecvRateBps() const { return *m_max_recv_duration_rate_bps; }
    float maxSentRateBps() const { return *m_max_sent_duration_rate_bps; }
    QQueue<float> recvRateList() { return *m_smoothed_duration_recv_rate_list; }
    QQueue<float> sentRateList() { return *m_smoothed_duration_sent_rate_list; }

public Q_SLOTS:
    void setTotalBytesRecv(float new_total);
    void setTotalBytesSent(float new_total);
    void setMaxRecvDurationRateBps(float * new_max);
    void setMaxSentDurationRateBps(float * new_max);
    void setSmoothedDurationRecvRateList(QQueue<float> * smoothed_duration_recv_rate_list);
    void setSmoothedDurationSentRateList(QQueue<float> * smoothed_duration_sent_rate_list);

    void setDurationAdjustedValues();
    Q_INVOKABLE void updateDuration(int new_duration);

Q_SIGNALS:
    void totalBytesRecvChanged();
    void totalBytesSentChanged();
    void maxRecvRateBpsChanged();
    void maxSentRateBpsChanged();
    void recvRateListChanged();
    void sentRateListChanged();

private:
    struct DurationTrafficData {
        int duration;
        float* maxRecvRateBps;
        float* maxSentRateBps;
        QQueue<float> * smoothedRecvRateList;
        QQueue<float> * smoothedSentRateList;
    };

    float applyMovingAverageFilter(QQueue<float> * rate_list, int duration);
    float calculateMaxRateBps(QQueue<float> * smoothed_duration_rate_list);
    void pruneRateList(QQueue<float> * rate_list, int duration);
    void updateSmoothedDurationRates(QQueue<float> * rate_list, QQueue<float> * smoothed_duration_rate_list, float * max_duration_rate_bps, int duration);
    void updateTrafficStats();

    NodeModel& m_node;
    int m_duration{300};
    float m_total_bytes_recv{0.0f};
    float m_total_bytes_sent{0.0f};
    DurationTrafficData networkTrafficData[4];
    // max received bps rates
    float * m_max_recv_duration_rate_bps;
    float m_max_recv_five_minutes_rate_bps{0.0f};
    float m_max_recv_one_hour_rate_bps{0.0f};
    float m_max_recv_twelve_hours_rate_bps{0.0f};
    float m_max_recv_one_day_rate_bps{0.0f};
    // max sent bps rates
    float * m_max_sent_duration_rate_bps;
    float m_max_sent_five_minutes_rate_bps{0.0f};
    float m_max_sent_one_hour_rate_bps{0.0f};
    float m_max_sent_twelve_hours_rate_bps{0.0f};
    float m_max_sent_one_day_rate_bps{0.0f};
    // received rate lists
    QQueue<float> m_raw_recv_rate_list;
    QQueue<float> * m_smoothed_duration_recv_rate_list;
    QQueue<float> m_smoothed_five_minutes_recv_rate_list;
    QQueue<float> m_smoothed_one_hour_recv_rate_list;
    QQueue<float> m_smoothed_twelve_hours_recv_rate_list;
    QQueue<float> m_smoothed_one_day_recv_rate_list;
    // sent rate lists
    QQueue<float> m_raw_sent_rate_list;
    QQueue<float> * m_smoothed_duration_sent_rate_list;
    QQueue<float> m_smoothed_five_minutes_sent_rate_list;
    QQueue<float> m_smoothed_one_hour_sent_rate_list;
    QQueue<float> m_smoothed_twelve_hours_sent_rate_list;
    QQueue<float> m_smoothed_one_day_sent_rate_list;
};

#endif // BITCOIN_QML_MODELS_NETWORKTRAFFICTOWER_H
