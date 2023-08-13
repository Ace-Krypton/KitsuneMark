#include "../include/benchmark.hpp"

Benchmark::Benchmark(QObject *parent) : QObject(parent) { }

/**
 * @brief Runs a benchmark using the specified FIO options and processes the results.
 *
 * @param options The FIO command-line options for the benchmark.
 * @param detect The type of benchmark being run.
 * @param is_all If true, the benchmark includes all data; otherwise, it includes important data only.
 */
void Benchmark::run(const QString &options, const QString &detect, bool is_all) {
    QString command = options;
    int result = std::system(command.toStdString().c_str());

    /// Check if the FIO benchmarking failed.
    if (result != 0) {
        std::cout << "FIO benchmarking failed with exit code: " << result << std::endl;
        emit exitWithFailure(detect);
        return;
    }

    /// Read FIO results from file and store them.
    if (result != 0) {
        std::cout << "FIO benchmarking failed with exit code: " << result << std::endl;
        emit exitWithFailure(detect);
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
            emit exitWithFailure(detect);
        }
    }

    /// Remove temporary files created during the benchmark.
    std::remove("test");
    std::remove("fio_results.txt");

    /// Extract bandwidth information from results.
    QString bandwidth = extract_bandwidth(_results, detect)
                        + " = " + extract_iops(_results, detect);

    /// Define a map of benchmark types to corresponding signals.
    std::unordered_map<QString, std::function<void(QString, bool)>> map = {
        {"SMREAD", [this](QString bandwidth, bool is_all) { emit seq1MReadFinished(bandwidth, is_all); }},
        {"SMWRITE", [this](QString bandwidth, bool is_all) { emit seq1MWriteFinished(bandwidth, is_all); }},
        {"SKREAD", [this](QString bandwidth, bool is_all) { emit seq128KReadFinished(bandwidth, is_all); }},
        {"SKWRITE", [this](QString bandwidth, bool is_all) { emit seq128KWriteFinished(bandwidth, is_all); }},
        {"RGREAD", [this](QString bandwidth, bool is_all) { emit rand4KQ32T1ReadFinished(bandwidth, is_all); }},
        {"RGWRITE", [this](QString bandwidth, bool is_all) { emit rand4KQ32T1WriteFinished(bandwidth, is_all); }},
        {"RLREAD", [this](QString bandwidth, bool is_all) { emit rand4KQ1T1ReadFinished(bandwidth, is_all); }},
        {"RLWRITE", [this](QString bandwidth, bool is_all) { emit rand4KQ1T1WriteFinished(bandwidth, is_all); }}
    };

    /// Find the corresponding signal and emit it with the extracted bandwidth.
    auto it = map.find(detect);
    if (it != map.end()) it->second(bandwidth, is_all);

    /// Clear the results vector after extracting necessary information.
    _results.clear();
}

/**
 * @brief Extracts the bandwidth information from the FIO results for a specific benchmark type.
 *
 * @param results The vector of FIO result logs.
 * @param detect The type of benchmark being extracted (e.g., "SMREAD").
 * @return The extracted bandwidth as a QString, or an empty QString if not found.
 */
QString Benchmark::extract_bandwidth(std::vector<std::string> &results, const QString &detect) {
    for (std::string &logs : results) {
        std::string line;
        std::istringstream log_stream(logs);

        while (std::getline(log_stream, line)) {
            /// Check if the line contains the bandwidth information.
            if (line.find(detect.toStdString().substr(2) + ": bw=") != std::string::npos) {
                size_t start = line.find('(') + 1;
                size_t end = line.find("MB/s", start);
                /// Extract the bandwidth value if the necessary markers are found.
                if (start != std::string::npos && end != std::string::npos) {
                    std::string bandwidth = line.substr(start, end - start);
                    return QString::fromStdString(bandwidth);
                }
            }
        }
    }

    /// Return an empty QString if the bandwidth information is not found.
    return {};
}

/**
 * @brief Extracts the IOPS information from the FIO results for a specific benchmark type.
 *
 * @param results The vector of FIO result logs.
 * @param detect The type of benchmark being extracted (e.g., "SMREAD").
 * @return The extracted bandwidth as a QString, or an empty QString if not found.
 */
QString Benchmark::extract_iops(std::vector<std::string> &results, const QString &detect) {
    for (std::string &logs : results) {
        std::string line;
        std::istringstream log_stream(logs);

        while (std::getline(log_stream, line)) {
            /// Check if the line contains the IOPS information.
            if (line.find(": IOPS=") != std::string::npos) {
                size_t start = line.find("IOPS=") + 5;
                size_t end = line.find(',', start);
                /// Extract the IOPS value if the necessary markers are found.
                if (start != std::string::npos && end != std::string::npos) {
                    std::string iops = line.substr(start, end - start);
                    return QString::fromStdString(iops);
                }
            }
        }
    }

    /// Return an empty QString if the IOPS information is not found.
    return {};
}

/**
 * @brief Returns the vector of FIO result logs.
 *
 * @return A vector of strings containing the FIO result logs.
 */
std::vector<std::string> Benchmark::get_results() {
    return _results;
}

/**
 * @brief Starts the benchmark asynchronously using the specified command and parameters.
 *
 * @param command The FIO command to run the benchmark.
 * @param detect The type of benchmark being run.
 * @param is_all If true, the benchmark includes all data; otherwise, it includes important data only.
 */
void Benchmark::start(const QString &command, const QString &detect, bool is_all) {
    /// Start the benchmark asynchronously and store the future object.
    _future = std::async(std::launch::async, &Benchmark::run, this, command, detect, is_all);
}

/**
 * @brief Extracts a QString value from a QVariant if possible.
 *
 * @param variant The QVariant containing the value to be extracted.
 * @return The extracted QString value if conversion is successful, otherwise an empty QString.
 */
QString Benchmark::extract_qstring_from_variant(const QVariant &variant) const {
    if (variant.canConvert<QString>()) {
        /// Convert the QVariant to QString and return it.
        return variant.toString();
    }

    /// Return an empty QString if conversion is not possible.
    return {};
}

/**
 * @brief Stops the benchmark by waiting for any running asynchronous operation to complete.
 */
void Benchmark::stop() {
    if (_future.valid()) {
        /// Wait for the asynchronous operation to complete.
        _future.wait();
    }
}
