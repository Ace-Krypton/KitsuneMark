#include "benchmark.hpp"
#include "qvariant.h"

Benchmark::Benchmark(QObject *parent) : QObject(parent) { }

void Benchmark::run(const QString &options) {
    QString command = "sync;fio " + options + " > fio_results.txt";

    QProcess process;
    process.start("sync;fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test --filename=test --bs=1M --size=1G --readwrite=read --ramp_time=4 --numjobs=5 > fio_results.txt");
    process.waitForFinished(-1);

    std::cout << "FIO Command: " << command.toStdString() << std::endl;

    int result = process.exitCode();

    if (result != 0) {
        std::cout << result << std::endl;
        std::cout << "FIO benchmarking failed!\n";
    } else {
        std::ifstream file("fio_results.txt");

        if (file) {
            std::string line;
            while (std::getline(file, line)) {
                _results.push_back(line);
            }
            file.close();

        } else {
            std::cout << "Failed to read FIO results file.\n";
        }
    }

    std::remove("test");
    std::remove("fio_results.txt");
}

QString Benchmark::extract_bandwidth(const std::vector<std::string> &results) {
    for (const std::string &logs : results) {
        std::string line;
        std::istringstream log_stream(logs);

        while (std::getline(log_stream, line)) {
            if (line.find("READ: bw=") != std::string::npos) {
                size_t start = line.find('(') + 1;
                size_t end = line.find("MB/s", start);
                if (start != std::string::npos && end != std::string::npos) {
                    std::string bandwidth = line.substr(start, end - start);
                    return QString::fromStdString(bandwidth);
                }
            }
        }
    }

    return {};
}

std::vector<std::string> Benchmark::get_results() {
    return _results;
}

void Benchmark::start(const QVariant &options) {
    QString optionsString = extractQStringFromVariant(options);

    _thread = std::thread(&Benchmark::run, this, optionsString);
    std::this_thread::sleep_for(std::chrono::seconds(5));
}

QString Benchmark::extractQStringFromVariant(const QVariant &variant) const {
    if (variant.canConvert<QString>()) {
        return variant.toString();
    }
    return {};
}

void Benchmark::stop() {
    if (_thread.joinable()) {
        _exit = true;
        _thread.join();
    }
}
