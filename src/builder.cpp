#include "../include/builder.hpp"

Builder::Builder(QObject *parent) : QObject(parent) { }

/**
 * @brief Executes a sequential benchmark using FIO with specified parameters.
 *
 * This function generates a command to run a sequential benchmark using FIO,
 * with various parameters such as test size, test count, block size, and operation mode.
 * The benchmark results are then recorded using the provided Benchmark object.
 *
 * @param size The size of the benchmark test in GB.
 * @param testCount The number of test iterations to run.
 * @param benchmark A pointer to the Benchmark object for recording results.
 * @param isAll Indicates whether to perform all tests or not.
 * @param blockSize The block size to be used in the benchmark.
 * @param mode The operation mode for the benchmark (read or write).
 */
void Builder::sequential(const QString &size, const QString &testCount,
                         Benchmark *benchmark, bool isAll,
                         const QString &blockSize, const QString &mode) {

    /// Mapping of operation modes and block sizes to detection strings.
    static const std::map<QString, std::map<QString, QString>> detectMap = {
        {"read", {{"1M", "SMREAD"}, {"128K", "SKREAD"}}},
        {"write", {{"1M", "SMWRITE"}, {"128K", "SKWRITE"}}}
    };

    /// Determine the appropriate detection string based on the operation mode and block size.
    QString detect = detectMap.at(mode).at(blockSize);

    /// Generate the FIO command string with the provided parameters.
    QString command = QString::fromUtf8(
                          "sync;fio --loops=%1 --size=32m --stonewall --zero_buffers=0 "
                          "--randrepeat=1 --ioengine=libaio --direct=1 "
                          "--name=test --filename=test "
                          "--bs=%2 --size=%3G --readwrite=%4 --ramp_time=4 "
                          "--iodepth=8 --numjobs=1 > fio_results.txt")
                          .arg(testCount, blockSize, size, mode);

    /// Start the benchmark with the generated command and detection string.
    benchmark->start(command, detect, isAll);
}

/**
 * @brief Executes a random I/O benchmark using FIO (Flexible I/O Tester) with specified parameters.
 *
 * This function generates a command to run a random I/O benchmark using FIO,
 * with various parameters such as test size, test count, queue depth, operation mode,
 * and allocation size. The benchmark results are then recorded using the provided Benchmark object.
 *
 * @param size The size of the benchmark test in GB.
 * @param testCount The number of test iterations to run.
 * @param benchmark A pointer to the Benchmark object for recording results.
 * @param isAll Indicates whether to perform all tests or not.
 * @param queue The queue depth to be used in the benchmark.
 * @param mode The operation mode for the benchmark (read or write).
 * @param allocationSize The allocation size for the benchmark in MB.
 */
void Builder::random(const QString &size, const QString &testCount,
                     Benchmark *benchmark, bool isAll,
                     const QString &queue, const QString &mode,
                     const QString &allocationSize) {

    /// Mapping of operation modes and queue depths to detection strings.
    static const std::map<QString, std::map<QString, QString>> detectMap = {
        {"read", {{"32", "RGREAD"}, {"1", "RLREAD"}}},
        {"write", {{"32", "RGWRITE"}, {"1", "RLWRITE"}}}
    };

    /// Determine the appropriate detection string based on the operation mode and queue depth.
    QString detect = detectMap.at(mode).at(queue);

    /// Generate the FIO command string with the provided parameters.
    QString command = QString::fromUtf8(
                          "sync;fio --loops=%1 --size=%2m --stonewall --zero_buffers=0 "
                          "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                          "--filename=test --iodepth=%3 --bs=4K --size=%4G --readwrite=rand%5 "
                          "--ramp_time=1 --numjobs=1 > fio_results.txt")
                          .arg(testCount, allocationSize, queue, size, mode);

    /// Start the benchmark with the generated command and detection string.
    benchmark->start(command, detect, isAll);
}
