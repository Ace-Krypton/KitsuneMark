#include "builder.hpp"

Builder::Builder(QObject *parent) : QObject(parent) { }

void Builder::seq1mq8t1_read(const QString &block_size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=1M --size=4G --readwrite=read --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SMREAD", is_all);
}

void Builder::seq1mq8t1_write(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=1M --size=4G --readwrite=write --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SMWRITE", is_all);
}

void Builder::seq128Kq8t1_read(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=128K --size=4G --readwrite=read --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SKREAD", is_all);
}

void Builder::seq128Kq8t1_write(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=32m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 "
                      "--name=test --filename=test "
                      "--bs=128K --size=4G --readwrite=write --ramp_time=4 "
                      "--iodepth=8 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "SKWRITE", is_all);
}

void Builder::rnd4kq32t1_read(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=8m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=32 --bs=4K --size=4G "
                      "--readwrite=randread --ramp_time=1 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "RGREAD", is_all);
}

void Builder::rnd4kq32t1_write(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=8m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=32 --bs=4K --size=4G "
                      "--readwrite=randwrite --ramp_time=1 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "RGWRITE",is_all);
}

void Builder::rnd4kq1t1_read(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=256m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=1 --bs=4K --size=1G "
                      "--readwrite=randread --ramp_time=1 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "RLREAD", is_all);
}

void Builder::rnd4kq1t1_write(const QString &size, Benchmark *benchmark, bool is_all) {
    QString command = "sync;fio --loops=5 --size=256m --stonewall --zero_buffers=0 "
                      "--randrepeat=1 --ioengine=libaio --direct=1 --name=test "
                      "--filename=test --iodepth=1 --bs=4K --size=1G "
                      "--readwrite=randwrite --ramp_time=1 --numjobs=1 > fio_results.txt";

    benchmark->start(command, "RLWRITE", is_all);
}
