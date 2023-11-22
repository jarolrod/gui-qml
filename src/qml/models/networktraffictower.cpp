// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <qml/models/networktraffictower.h>

#include <QObject>
#include <QThread>
#include <QTimer>

#define FIVE_MINUTES_SAMPLES 300
#define ONE_HOUR_SAMPLES 3600
#define TWELVE_HOURS_SAMPLES 43200
#define ONE_DAY_SAMPLES 86400

NetworkTrafficTower::NetworkTrafficTower(NodeModel& node)
    : m_node{node}
{
    QTimer* timer = new QTimer();
    connect(timer, &QTimer::timeout, this, &NetworkTrafficTower::updateTrafficStats);
    timer->start(1000);

    QThread* timer_thread = new QThread;
    timer->moveToThread(timer_thread);
    timer_thread->start();

    networkTrafficData[0] = { FIVE_MINUTES_SAMPLES, &m_max_recv_five_minutes_rate_bps, &m_max_sent_five_minutes_rate_bps, &m_smoothed_five_minutes_recv_rate_list, &m_smoothed_five_minutes_sent_rate_list };
    networkTrafficData[1] = { ONE_HOUR_SAMPLES, &m_max_recv_one_hour_rate_bps, &m_max_sent_one_hour_rate_bps, &m_smoothed_one_hour_recv_rate_list, &m_smoothed_one_hour_sent_rate_list };
    networkTrafficData[2] = { TWELVE_HOURS_SAMPLES, &m_max_recv_twelve_hours_rate_bps, &m_max_sent_twelve_hours_rate_bps, &m_smoothed_twelve_hours_recv_rate_list, &m_smoothed_twelve_hours_sent_rate_list };
    networkTrafficData[3] = { ONE_DAY_SAMPLES, &m_max_recv_one_day_rate_bps, &m_max_sent_one_day_rate_bps, &m_smoothed_one_day_recv_rate_list, &m_smoothed_one_day_sent_rate_list };
}

void NetworkTrafficTower::setTotalBytesRecv(float new_total)
{
    m_total_bytes_recv = new_total;
    Q_EMIT totalBytesRecvChanged();
}

void NetworkTrafficTower::setTotalBytesSent(float new_total)
{
    m_total_bytes_sent = new_total;
    Q_EMIT totalBytesSentChanged();
}

void NetworkTrafficTower::setMaxRecvDurationRateBps(float * new_max)
{
    m_max_recv_duration_rate_bps = new_max;
    Q_EMIT maxRecvRateBpsChanged();
}

void NetworkTrafficTower::setMaxSentDurationRateBps(float * new_max)
{
    m_max_sent_duration_rate_bps = new_max;
    Q_EMIT maxSentRateBpsChanged();
}

void NetworkTrafficTower::setSmoothedDurationRecvRateList(QQueue<float> * smoothed_duration_recv_rate_list)
{
    m_smoothed_duration_recv_rate_list = smoothed_duration_recv_rate_list;
    Q_EMIT recvRateListChanged();
}

void NetworkTrafficTower::setSmoothedDurationSentRateList(QQueue<float> * smoothed_duration_sent_rate_list)
{
    m_smoothed_duration_sent_rate_list = smoothed_duration_sent_rate_list;
    Q_EMIT sentRateListChanged();
}

void NetworkTrafficTower::setDurationAdjustedValues()
{
    for (const auto& data : durationLists) {
        if (m_duration == data.duration) {
            setMaxRecvDurationRateBps(data.maxRecvRateBps);
            setMaxSentDurationRateBps(data.maxSentRateBps);
            setSmoothedDurationRecvRateList(data.smoothedRecvRateList);
            setSmoothedDurationSentRateList(data.smoothedSentRateList);
            break;
        }
    }
}

void NetworkTrafficTower::updateDuration(int new_duration)
{
    m_duration = new_duration;
    setDurationAdjustedValues();
}

float NetworkTrafficTower::applyMovingAverageFilter(QQueue<float> * rate_list, int duration)
{
    int lookback = std::min(rate_list->size(), duration);
    float sum = 0.0f;
    for (int i = 0; i < lookback; ++i) {
        sum += rate_list->at(i);
    }

    return sum / duration;
}

float NetworkTrafficTower::calculateMaxRateBps(QQueue<float> * smoothed_duration_rate_list)
{
    float max_rate_bps = 0.0f;
    for (int i = smoothed_duration_rate_list->size() - 1; i > 0; --i) {
        if (smoothed_duration_rate_list->at(i) > max_rate_bps) {
            max_rate_bps = smoothed_duration_rate_list->at(i);
        }
    }
    return max_rate_bps;
}

void NetworkTrafficTower::pruneRateList(QQueue<float> * rate_list, int duration)
{
    while (rate_list->size() > duration) {
        rate_list->pop_back();
    }
}

void NetworkTrafficTower::updateSmoothedDurationRates(QQueue<float> * raw_rate_list, QQueue<float> * smoothed_duration_rate_list, float * max_duration_rate_bps, int duration)
{
    float smoothed_rate_bps = applyMovingAverageFilter(raw_rate_list, duration);
    smoothed_duration_rate_list->push_front(smoothed_rate_bps);
    pruneRateList(smoothed_duration_rate_list, duration);
    *max_duration_rate_bps = calculateMaxRateBps(smoothed_duration_rate_list);
}

void NetworkTrafficTower::updateTrafficStats()
{
    // 1. Get new total bytes received and sent from node
    float new_total_bytes_recv = m_node.getTotalBytesReceived();
    float new_total_bytes_sent = m_node.getTotalBytesSent();

    // 2. Calculate new raw rate of bytes received and sent per second
    float raw_rate_recv_bps = (new_total_bytes_recv - m_total_bytes_recv);
    float raw_rate_sent_bps = (new_total_bytes_sent - m_total_bytes_sent);

    // 3. Push new rate of bytes received and sent to raw rate lists
    m_raw_recv_rate_list.push_front(raw_rate_recv_bps);
    m_raw_sent_rate_list.push_front(raw_rate_sent_bps);

    // 4. Prune raw rate lists
    pruneRateList(&m_raw_recv_rate_list, ONE_DAY_SAMPLES);
    pruneRateList(&m_raw_sent_rate_list, ONE_DAY_SAMPLES);

    // 5. update rate lists
    for (const auto& data : durationLists) {
        updateSmoothedDurationRates(&m_raw_recv_rate_list, data.smoothedRecvRateList, data.maxRecvRateBps, data.duration);
        updateSmoothedDurationRates(&m_raw_sent_rate_list, data.smoothedSentRateList, data.maxSentRateBps, data.duration);
    }

    // 7. Set new values
    setTotalBytesRecv(new_total_bytes_recv);
    setTotalBytesSent(new_total_bytes_sent);
    setDurationAdjustedValues();
}
