#pragma once

#include <QString>
#include <QObject>

#include "../include/benchmark.hpp"

class Builder : public QObject {
    Q_OBJECT

public:
    explicit Builder(QObject *parent = nullptr);

    Q_INVOKABLE void sequential(const QString &size, const QString &testCount,
                                Benchmark *benchmark, bool isAll,
                                QString blockSize, QString mode);

    Q_INVOKABLE void random(const QString &size, const QString &testCount,
                            Benchmark *benchmark, bool isAll,
                            QString queue, QString mode, QString allocationSize);

//    Q_INVOKABLE void seq1mq8t1Read(const QString &size, const QString &testCount,
//                                    Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void seq1mq8t1Write(const QString &size, const QString &testCount,
//                                     Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void seq128Kq8t1Read(const QString &size, const QString &testCount,
//                                      Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void seq128Kq8t1Write(const QString &size, const QString &testCount,
//                                       Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void rnd4kq32t1Read(const QString &size, const QString &testCount,
//                                     Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void rnd4kq32t1Write(const QString &size, const QString &testCount,
//                                      Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void rnd4kq1t1Read(const QString &size, const QString &testCount,
//                                    Benchmark *benchmark, bool isAll);
//    Q_INVOKABLE void rnd4kq1t1Write(const QString &size, const QString &testCount,
//                                     Benchmark *benchmark, bool isAll);
};
