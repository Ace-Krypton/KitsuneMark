#pragma once

#include <QString>
#include <QObject>

#include "benchmark.hpp"

class Builder : public QObject {
    Q_OBJECT

public:
    explicit Builder(QObject *parent = nullptr);

    Q_INVOKABLE void seq1mq8t1_read(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void seq1mq8t1_write(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void seq128Kq8t1_read(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void seq128Kq8t1_write(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void rnd4kq32t1_read(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void rnd4kq32t1_write(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void rnd4kq1t1_read(const QString &size, Benchmark *benchmark, bool is_all);
    Q_INVOKABLE void rnd4kq1t1_write(const QString &size, Benchmark *benchmark, bool is_all);
};
