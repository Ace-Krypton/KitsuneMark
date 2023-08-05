#include "builder.hpp"

void Builder::seq1mq8t1_read(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=8m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + block_size + "M --size=4G "
                      "--readwrite=read --ramp_time=4 --iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SMREAD");
}

void Builder::seq1mq8t1_write(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=8m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + block_size + "M --size=4G "
                      "--readwrite=write --ramp_time=4 --iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SMWRITE");
}

void Builder::random_read(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + block_size + "K --size=1G "
                      "--readwrite=randread --ramp_time=4 > fio_results.txt";

    benchmark->start(command, "RREAD");
}

void Builder::random_write(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + block_size + "K --size=1G "
                      "--readwrite=readwrite --ramp_time=4 > fio_results.txt";

    benchmark->start(command, "RWRITE");
}
