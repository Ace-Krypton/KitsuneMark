#include "benchmark.hpp"
#include "qvariant.h"

Benchmark::Benchmark(QObject *parent) : QObject(parent) { }

void Benchmark::run(const QString &options) {
    QString command = "sync;fio " + options + " > fio_results.txt";
    int result = std::system(command.toStdString().c_str());

    if (result != 0) {
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

std::string Benchmark::extract_bandwidth(const std::vector<std::string> &results) {
    for (const std::string &logs : results) {
        std::string line;
        std::istringstream log_stream(logs);

        while (std::getline(log_stream, line)) {
            if (line.find("READ: bw=") != std::string::npos) {
                size_t start = line.find('(') + 1;
                size_t end = line.find("MB/s", start);
                if (start != std::string::npos && end != std::string::npos) {
                    return line.substr(start, end - start);
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
