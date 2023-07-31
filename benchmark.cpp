#include "benchmark.hpp"
#include <thread>

Benchmark::Benchmark(QObject *parent) : QObject(parent) { }

void Benchmark::run(const QString &options) {
    QString command = "sync;/usr/bin/fio " + options + " > fio_results.txt";

    int result = std::system(command.toStdString().c_str());

    if (result != 0) {
        std::cout << "FIO benchmarking failed with exit code: " << result << std::endl;
        return;
    }

    if (result != 0) {
        std::cout << "FIO benchmarking failed with exit code: " << result << std::endl;
    } else {
        std::ifstream file("fio_results.txt");
        if (file) {
            std::string line;
            while (std::getline(file, line)) {
                _results.push_back(line);
            }
            file.close();
        } else {
            std::cout << "Failed to write FIO results to file.\n";
        }
    }

    std::remove("test");
    std::remove("fio_results.txt");

    QString bandwidth = extract_bandwidth(_results);
    emit benchmarkFinished(bandwidth);
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
    QString optionsString = extract_qstring_from_variant(options);

    _future = std::async(std::launch::async, &Benchmark::run, this, optionsString);
}

QString Benchmark::extract_qstring_from_variant(const QVariant &variant) const {
    if (variant.canConvert<QString>()) {
        return variant.toString();
    }

    return {};
}

void Benchmark::stop() {
    if (_future.valid()) {
        _future.wait();
    }
}
