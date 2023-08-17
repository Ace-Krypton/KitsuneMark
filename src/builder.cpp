#include "../include/builder.hpp"

Builder::Builder(QObject *parent) : QObject(parent) { }

void Builder::sequential(const QString &size, const QString &testCount,
                         Benchmark *benchmark, bool isAll,
                         QString blockSize, QString mode) {

    QString command = "sync;fio --loops=" + testCount + " --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + blockSize + " --size=" + size + "G --readwrite=" + mode + " --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    QString detect;

    if (mode == "read" && blockSize == "1M") {
        detect = "SMREAD";
    } else if (mode == "read" && blockSize == "128K") {
        detect = "SKREAD";
    } else if (mode == "write" && blockSize == "1M") {
        detect = "SMWRITE";
    } else if (mode == "write" && blockSize == "128K") {
        detect = "SKWRITE";
    }

    benchmark->start(command, detect, isAll);
}

void Builder::random(const QString &size, const QString &testCount,
                     Benchmark *benchmark, bool isAll,
                     QString queue, QString mode, QString allocationSize) {

    QString command = "sync;fio --loops=" + testCount + " --size=" + allocationSize
                      + "m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=" + queue + " --bs=4K --size=" + size +
                      "G --readwrite=rand" + mode + " --ramp_time=1 --numjobs=1 > fio_results.txt";

    QString detect;

    if (mode == "read" && queue == "32") {
        detect = "RGREAD";
    } else if (mode == "read" && queue == "1") {
        detect = "RLREAD";
    } else if (mode == "write" && queue == "32") {
        detect = "RGWRITE";
    } else if (mode == "write" && queue == "1") {
        detect = "RLWRITE";
    }

    benchmark->start(command, detect, isAll);
}

///**
// * @brief Runs a sequential read with 1M 8 Queues and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::seq1mq8t1Read(const QString &size, const QString &testCount,
//                             Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=32m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 "
//                      "--name=test --filename=test "
//                      "--bs=1M --size=" + size + "G --readwrite=read --ramp_time=4 "
//                      "--iodepth=8 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "SMREAD", isAll);
//}

///**
// * @brief Runs a sequential write with 1M 8 Queues and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::seq1mq8t1Write(const QString &size, const QString &testCount,
//                              Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=32m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 "
//                      "--name=test --filename=test "
//                      "--bs=1M --size=" + size + "G --readwrite=write --ramp_time=4 "
//                      "--iodepth=8 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "SMWRITE", isAll);
//}

///**
// * @brief Runs a sequential read with 128K 8 Queues and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::seq128Kq8t1Read(const QString &size, const QString &testCount,
//                               Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=32m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 "
//                      "--name=test --filename=test "
//                      "--bs=128K --size=" + size + "G --readwrite=read --ramp_time=4 "
//                      "--iodepth=8 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "SKREAD", isAll);
//}

///**
// * @brief Runs a sequential write with 128K 8 Queues and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::seq128Kq8t1Write(const QString &size, const QString &testCount,
//                                Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=32m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 "
//                      "--name=test --filename=test "
//                      "--bs=128K --size=" + size + "G --readwrite=write --ramp_time=4 "
//                      "--iodepth=8 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "SKWRITE", isAll);
//}

///**
// * @brief Runs a random read with 4K 32 Queues and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::rnd4kq32t1Read(const QString &size, const QString &testCount,
//                              Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=8m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
//                      "--filename=test --iodepth=32 --bs=4K --size=" + size +
//                      "G --readwrite=randread --ramp_time=1 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "RGREAD", isAll);
//}

///**
// * @brief Runs a random write with 4K 32 Queues and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::rnd4kq32t1Write(const QString &size, const QString &testCount,
//                               Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=8m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
//                      "--filename=test --iodepth=32 --bs=4K --size=" + size +
//                      "G --readwrite=randwrite --ramp_time=1 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "RGWRITE", isAll);
//}

///**
// * @brief Runs a random read with 4K 1 Queue and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::rnd4kq1t1Read(const QString &size, const QString &testCount,
//                             Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=256m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
//                      "--filename=test --iodepth=1 --bs=4K --size=" + size +
//                      "G --readwrite=randread --ramp_time=1 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "RLREAD", isAll);
//}

///**
// * @brief Runs a random write with 4K 1 Queue and 1 Thread.
// *
// * @param size The size of the data to read in gigabytes.
// * @param testCount The number of tests that will be done.
// * @param benchmark A pointer to the Benchmark object to record the results.
// * @param isAll If true, the benchmark includes all data;
// * otherwise, it includes important data only.
// */
//void Builder::rnd4kq1t1Write(const QString &size, const QString &testCount,
//                              Benchmark *benchmark, bool isAll) {
//    QString command = "sync;fio --loops=" + testCount + " --size=256m --stonewall --zero_buffers=0 "
//                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
//                      "--filename=test --iodepth=1 --bs=4K --size=" + size +
//                      "G --readwrite=randwrite --ramp_time=1 --numjobs=1 > fio_results.txt";

//    benchmark->start(command, "RLWRITE", isAll);
//}
