// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <qml/models/networktraffictower.h>

#include <QObject>
#include <QThread>
#include <QTimer>

NetworkTrafficTower::NetworkTrafficTower(NodeModel& node)
    : m_node{node}
{
    QTimer* timer = new QTimer();
    connect(timer, &QTimer::timeout, this, &NetworkTrafficTower::updateTrafficStats);
    timer->start(1000);

    QThread* timer_thread = new QThread;
    timer->moveToThread(timer_thread);
    timer_thread->start();

    // initialize m_duration_traffic_data_array
    for (size_t i = 0; i < m_duration_periods_count; ++i) {
        m_duration_traffic_data_array[i].duration_samples = m_duration_periods[i];
        int duration_lookback_samples = m_duration_periods[i] / m_smoothing_factor;
        m_duration_traffic_data_array[i].lookback_samples = duration_lookback_samples;
    }

    connect(this, &NetworkTrafficTower::durationChanged, this, &NetworkTrafficTower::broadcastDurationTrafficData);
}

void NetworkTrafficTower::setDuration(int new_duration)
{
    if (new_duration == m_duration) {
        return;
    }
    m_duration = new_duration;
    Q_EMIT durationChanged();
}

void NetworkTrafficTower::setDurationMaxRecvRate(float * new_duration_max_rate)
{
    m_duration_max_recv_rate = new_duration_max_rate;
    Q_EMIT durationMaxRecvRateChanged();
}

void NetworkTrafficTower::setDurationMaxSentRate(float * new_duration_max_rate)
{
    m_duration_max_sent_rate = new_duration_max_rate;
    Q_EMIT durationMaxSentRateChanged();
}

void NetworkTrafficTower::setDurationRecvRateList(QList<float> * new_duration_rate_list)
{
    m_duration_recv_rate_list = new_duration_rate_list;
    Q_EMIT durationRecvRateListChanged();
}

void NetworkTrafficTower::setDurationSentRateList(QList<float> * new_duration_rate_list)
{
    m_duration_sent_rate_list = new_duration_rate_list;
    Q_EMIT durationSentRateListChanged();
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

void NetworkTrafficTower::broadcastDurationTrafficData()
{
    for(DurationTrafficData& data : m_duration_traffic_data_array) {
        if (data.duration_samples == m_duration) {
            setDurationMaxRecvRate(&data.smoothed_max_recv_rate);
            setDurationMaxSentRate(&data.smoothed_max_sent_rate);
            setDurationRecvRateList(&data.smoothed_recv_rate_list);
            setDurationSentRateList(&data.smoothed_sent_rate_list);
            return;
        }
    }
}

void NetworkTrafficTower::DurationTrafficData::addNewRates(float raw_recv_rate, float raw_sent_rate) {
    // // 1. If we have enough lookback samples, then get the oldest lookback sample and subtract it from the running sums
    // if (smoothed_recv_rate_list.size() >= lookback_samples) {
    //     float current_oldest_lookback_recv_rate = smoothed_recv_rate_list.at(smoothed_recv_rate_list.size() - (lookback_samples + 1));
    //     float current_oldest_lookback_sent_rate = smoothed_sent_rate_list.at(smoothed_sent_rate_list.size() - (lookback_samples + 1));
    //     lookback_running_sum_recv -= current_oldest_lookback_recv_rate;
    //     lookback_running_sum_sent -= current_oldest_lookback_sent_rate;
    // }

    // 2. Add the new rates to the running sums
    lookback_running_sum_recv += raw_recv_rate;
    lookback_running_sum_sent += raw_sent_rate;

    // 3. Calculate the smoothed rates
    int smoothing_factor = std::min(lookback_samples, smoothed_recv_rate_list.size());
    float smoothed_recv_rate = lookback_running_sum_recv / smoothing_factor;
    float smoothed_sent_rate = lookback_running_sum_sent / smoothing_factor;

    // 4. Add the smoothed rates to the smoothed rate lists
    smoothed_recv_rate_list.append(smoothed_recv_rate);
    smoothed_sent_rate_list.append(smoothed_sent_rate);

    // 5. Update max rates if necessary
    if (smoothed_recv_rate > smoothed_max_recv_rate) {
        smoothed_max_recv_rate = smoothed_recv_rate;
    }
    if (smoothed_sent_rate > smoothed_max_sent_rate) {
        smoothed_max_sent_rate = smoothed_sent_rate;
    }

    float old_smoothed_max_recv_rate{0.0f};
    float old_smoothed_max_sent_rate{0.0f};

    // // 5. If the smoothed rate lists are full, then remove the oldest rate
    // if (smoothed_recv_rate_list.size() > duration_samples && smoothed_recv_rate_list.notEmpty()) {
    //     old_smoothed_max_recv_rate = smoothed_recv_rate_list.takeFirst();
    //     old_smoothed_max_sent_rate = smoothed_sent_rate_list.takeFirst();
    // }

    // 6. If we removed the max rate, then find the new max rate
    if (old_smoothed_max_recv_rate == smoothed_max_recv_rate && old_smoothed_max_recv_rate != smoothed_recv_rate) {
        findMaxRate(&smoothed_recv_rate_list);
    }
    if (old_smoothed_max_sent_rate == smoothed_max_sent_rate && old_smoothed_max_sent_rate != smoothed_sent_rate) {
        findMaxRate(&smoothed_sent_rate_list);
    }
}

float NetworkTrafficTower::DurationTrafficData::findMaxRate(QList<float> * smoothed_rate_list) {
    // float max_rate = *std::max_element(smoothed_rate_list->begin(), smoothed_rate_list->end());
    return {0.0f};
}

void NetworkTrafficTower::updateTrafficStats()
{
    // 1. Get total bytes received and sent from node
    float total_bytes_recv = m_node.getTotalBytesReceived();
    float total_bytes_sent = m_node.getTotalBytesSent();

    // 2. Calculate received and sent rates
    float recv_rate = (total_bytes_recv - m_total_bytes_recv);
    float sent_rate = (total_bytes_sent - m_total_bytes_sent);

    // 3. Compute duration specific traffic stats
    for (DurationTrafficData& duration : m_duration_traffic_data_array) {
        duration.addNewRates(recv_rate, sent_rate);
    }

    // 4. broadcast new traffic stats
    setTotalBytesRecv(total_bytes_recv);
    setTotalBytesSent(total_bytes_sent);
    broadcastDurationTrafficData();
}
