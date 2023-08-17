#include "../include/builder.hpp"

Builder::Builder(QObject *parent) : QObject(parent) { }

void Builder::sequential(const QString &size, const QString &testCount,
                         Benchmark *benchmark, bool isAll,
                         const QString &blockSize, const QString &mode) {

    static const std::map<QString, std::map<QString, QString>> detectMap = {
        {"read", {{"1M", "SMREAD"}, {"128K", "SKREAD"}}},
        {"write", {{"1M", "SMWRITE"}, {"128K", "SKWRITE"}}}
    };

    QString detect = detectMap.at(mode).at(blockSize);

    QString command = QString::fromUtf8(
                          "sync;fio --loops=%1 --size=32m --stonewall --zero_buffers=0 "
                          "--randrepeat=1 --ioengine=libaio --direct=1 "
                          "--name=test --filename=test "
                          "--bs=%2 --size=%3G --readwrite=%4 --ramp_time=4 "
                          "--iodepth=8 --numjobs=1 > fio_results.txt")
                          .arg(testCount, blockSize, size, mode);

    benchmark->start(command, detect, isAll);
}

void Builder::random(const QString &size, const QString &testCount,
                     Benchmark *benchmark, bool isAll,
                     const QString &queue, const QString &mode,
                     const QString &allocationSize) {

    static const std::map<QString, std::map<QString, QString>> detectMap = {
        {"read", {{"32", "RGREAD"}, {"1", "RLREAD"}}},
        {"write", {{"32", "RGWRITE"}, {"1", "RLWRITE"}}}
    };

    QString detect = detectMap.at(mode).at(queue);

    QString command = QString::fromUtf8(
                          "sync;fio --loops=%1 --size=%2m --stonewall --zero_buffers=0 "
                          "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                          "--filename=test --iodepth=%3 --bs=4K --size=%4G --readwrite=rand%5 "
                          "--ramp_time=1 --numjobs=1 > fio_results.txt")
                          .arg(testCount, allocationSize, queue, size, mode);

    benchmark->start(command, detect, isAll);
}
