#include "builder.hpp"

void Builder::seq1mq8t1_read(const QString &block_size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=1M --size=4G --readwrite=read --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SMREAD");
}

void Builder::seq1mq8t1_write(const QString &size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=1M --size=4G --readwrite=write --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SMWRITE");
}

void Builder::seq128Kq8t1_read(const QString &size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=128K --size=4G --readwrite=read --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SKREAD");
}

void Builder::seq128Kq8t1_write(const QString &size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=128K --size=4G --readwrite=write --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SKWRITE");
}

void Builder::rnd4kq32t1_read(const QString &size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=8m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=32 --bs=4K --size=4G "
                      "--readwrite=randread --ramp_time=1 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "RGREAD");
}

void Builder::rnd4kq32t1_write(const QString &size, Benchmark *benchmark) {
    QString command = "sync;fio --loops=5 --size=8m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=32 --bs=4K --size=4G "
                      "--readwrite=randwrite --ramp_time=1 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "RGWRITE");
}
