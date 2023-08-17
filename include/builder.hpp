#pragma once

#include <unordered_map>

#include <QString>
#include <QObject>


#include "../include/benchmark.hpp"

class Builder : public QObject {
    Q_OBJECT

public:
    explicit Builder(QObject *parent = nullptr);

    Q_INVOKABLE void sequential(const QString &size, const QString &testCount,
                                Benchmark *benchmark, bool isAll,
                                const QString &blockSize, const QString &mode);

    Q_INVOKABLE void random(const QString &size, const QString &testCount,
                            Benchmark *benchmark, bool isAll,
                            const QString &queue, const QString &mode,
                            const QString &allocationSize);
};
