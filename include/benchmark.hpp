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
    Q_INVOKABLE std::vector<std::string> getResults();
    Q_INVOKABLE QString extractQStringFromVariant(const QVariant &variant) const;
    Q_INVOKABLE void run(const QString &options, const QString &detect, bool isAll);
    Q_INVOKABLE void start(const QString &command, const QString &detect, bool isAll);
    Q_INVOKABLE static QString extractIOPS(std::vector<std::string> &results, const QString &detect);
    Q_INVOKABLE static QString extractBandwidth(std::vector<std::string> &results, const QString &detect);

signals:
    void exitWithFailure(QString detect);
    void seq1MReadFinished(QString bandwidth, bool isAll);
    void seq1MWriteFinished(QString bandwidth, bool isAll);
    void seq128KReadFinished(QString bandwidth, bool isAll);
    void seq128KWriteFinished(QString bandwidth, bool isAll);
    void rand4KQ32T1ReadFinished(QString bandwidth, bool isAll);
    void rand4KQ32T1WriteFinished(QString bandwidth, bool isAll);
    void rand4KQ1T1ReadFinished(QString bandwidth, bool isAll);
    void rand4KQ1T1WriteFinished(QString bandwidth, bool isAll);

private:
    std::future<void> _future;
    std::atomic<bool> _exit = false;
    std::vector<std::string> _results;
};
