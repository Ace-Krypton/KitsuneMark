#include "builder.hpp"

void Builder::sequential_read(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + block_size + "M --size=1G "
                      "--readwrite=read --ramp_time=4 --numjobs=5 > fio_results.txt";

    benchmark->start(command, "READ");
}

void Builder::sequential_write(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=" + block_size + "M --size=1G "
                      "--readwrite=write --ramp_time=4 --numjobs=5 > fio_results.txt";

    benchmark->start(command, "WRITE");
}
