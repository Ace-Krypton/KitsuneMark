#pragma once

#include <QString>
#include <QObject>

#include "benchmark.hpp"

class Builder : public QObject{
    Q_OBJECT

public:
    Q_INVOKABLE void seq1mq8t1_read(const QString &block_size, Benchmark *benchmark);
    Q_INVOKABLE void seq1mq8t1_write(const QString &block_size, Benchmark *benchmark);
    Q_INVOKABLE void random_read(const QString &block_size, Benchmark *benchmark);
    Q_INVOKABLE void random_write(const QString &block_size, Benchmark *benchmark);
};
