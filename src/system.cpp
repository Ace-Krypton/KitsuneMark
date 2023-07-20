#include "../include/system.hpp"

System::System(QObject *parent) : QObject(parent) { }

/**
 * @brief Extracts the CPU information from the /proc/cpuinfo file.
 *
 * @return A QString containing the extracted CPU information.
 */
QString System::extractCPU() {
    std::string modelName { "model name" }, cpuInfo { };
    std::ifstream file { "/proc/cpuinfo" };

    /// Check if the file can be opened,
    /// return "<unknown>" if not.
    if (!(file.is_open())) return "<unknown>";

    /// Iterate through the lines of the file to find the CPU model information.
    for (std::string line; (std::getline(file, line)); ) {
        if (line.find(modelName) != std::string::npos) {
            const std::size_t startPos = line.find(modelName);
            std::string temp = line.substr(startPos + 13);
            const std::size_t stopPos = temp.find("CPU");
            cpuInfo = temp.substr(0, stopPos);
        }
    }

    file.close();
    ///Convert the extracted CPU information to a QString.
    return QString::fromStdString(cpuInfo);
}

/**
 * @brief Checks if the device at the specified path is an SSD.
 *
 * @param path The path to the device's directory.
 * @return True if the device is an SSD, false otherwise.
 */
bool System::isSSD(const std::filesystem::path &path) {
    std::string modelName;
    std::ifstream modelFile(path / "device/model");

    /// Check if the model file can be opened,
    /// indicating the device exists.
    if (!modelFile.is_open()) return false;

    /// Read the model name from the model file.
    if (std::getline(modelFile, modelName)) {
        /// Define a regular expression pattern to identify SSDs.
        std::regex ssdRegex("\\bSSD\\b",
                             std::regex_constants::icase);
        /// Search for the SSD pattern in the model name.
        if (std::regex_search(modelName, ssdRegex)) {
            return true;
        }
    }

    ///The device is not identified as an SSD.
    return false;
}

/**
 * @brief Extracts the model name of the first SSD found in the system.
 *
 * @return A QString containing the model name of the first detected SSD,
 * or "<unknown>" if none is found.
 */
QString System::extractSSD() {
    const std::filesystem::path blockDir = "/sys/block/";
    std::vector<std::filesystem::directory_entry> entries;

    /// Collect information about block devices in the system.
    for (const auto &entry :
         std::filesystem::directory_iterator(blockDir)) {
        entries.push_back(entry);
    }

    /// Iterate through block devices to find the first SSD.
    for (const auto &entry : entries) {
        if (isSSD(entry)) {
            std::ifstream modelFile(entry.path() / "device/model");
            if (modelFile.is_open()) {
                std::string ssdName;
                if (std::getline(modelFile, ssdName)) {
                    ///Return the model name of the detected SSD.
                    return QString::fromStdString(ssdName);
                }
            }
        }
    }

    ///No SSD was detected in the system.
    return "<unknown>";
}

/**
 * @brief Extracts storage information for the root filesystem.
 *
 * @return A QString containing the storage usage information.
 */
QString System::extractStorage() {
    /// Get information about the available
    /// and total storage space on the root filesystem.
    std::filesystem::space_info storageInfo = std::filesystem::space("/");

    const double bytesToGib = 1024 * 1024 * 1024.0;
    double availableGb = storageInfo.available / bytesToGib;
    double capacityGb = storageInfo.capacity / bytesToGib;
    double percentage = (availableGb / capacityGb) * 100.0;

    QString result;
    QTextStream stream(&result);
    stream.setRealNumberPrecision(2);
    stream.setRealNumberNotation(QTextStream::FixedNotation);

    /// Construct the storage information string.
    stream << '/' << ": " << percentage << "% "
           << '(' << availableGb << '/'
           << capacityGb << " GiB" << ')';

    return result;
}

/**
 * @brief Checks the Flexible I/O Tester's version
 *
 * @return Version string
 */
QString System::checkFIOVersion() {
    std::string command = "fio --version";

    std::ostringstream outputStream;
    std::array<char, 128> buffer;
    std::string result;

    /// Open a pipe and execute the command
    std::unique_ptr<FILE, decltype(&pclose)>
        pipe(popen(command.c_str(), "r"), pclose);

    if (!pipe) return "<unknown>";

    /// Read the command output into the output stream
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        outputStream << buffer.data();
    }

    /// Extract the result from the output stream
    result = outputStream.str();

    /// Return the version
    return QString::fromStdString(result);
}

void System::writeToAFile(const QString &data) {
    QFile file("output.txt");

    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file);
        stream << data;
        file.close();
    }
}
