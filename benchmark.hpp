#pragma once

#include <string>
#include <future>
#include <thread>
#include <vector>
#include <atomic>
#include <thread>
#include <fstream>
#include <sstream>
#include <iostream>

#include <QObject>
#include <QVariant>
#include <QString>
#include <QProcess>

class Benchmark : public QObject {
    Q_OBJECT

public:
    explicit Benchmark(QObject *parent = nullptr);

    Q_INVOKABLE void stop();
    Q_INVOKABLE std::vector<std::string> get_results();
    Q_INVOKABLE void run(const QString &options, const QString &detect);
    Q_INVOKABLE void start(const QString &command, const QString &detect);
    Q_INVOKABLE QString extract_qstring_from_variant(const QVariant &variant) const;
    Q_INVOKABLE static QString extract_bandwidth(std::vector<std::string> &results, const QString &detect);

signals:
    void seq1MReadFinished(QString bandwidth);
    void seq1MWriteFinished(QString bandwidth);
    void randReadFinished(QString bandwidth);
    void randWriteFinished(QString bandwidth);

private:
    std::future<void> _future;
    std::atomic<bool> _exit = false;
    std::vector<std::string> _results;
};
