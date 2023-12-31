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
 * @brief Checks if the system has enough space based on the provided test size.
 *
 * This function checks if the available storage space on the system is sufficient
 * for the specified test size. The test size should be provided in the format
 * "1 GiB" or "1 MB".
 *
 * @param testSize The test size to check against, in the format "1 GiB" or "1 MB".
 * @return True if there's enough space, false otherwise.
 */
bool System::hasEnoughSpace(const QString &testSize) {
    /// Parse the test size string to get the required bytes
    qint64 requiredBytes = parseTestSize(testSize);

    /// Get storage information for the root filesystem
    QStorageInfo storageInfo = QStorageInfo::root();

    /// Check if the system is in read-only mode or if there's enough space
    return storageInfo.isReadOnly() || storageInfo.bytesAvailable() >= requiredBytes;
}

/**
 * @brief Parses a test size string and returns the size in bytes.
 *
 * This function parses a test size string in the format "1 GiB" or "1 MB"
 * and converts it into the corresponding size in bytes.
 *
 * @param testSize The test size to parse, in the format "1 GiB" or "1 MB".
 * @return The size in bytes.
 */
qint64 System::parseTestSize(const QString &testSize) {
    /// Regular expression pattern to match the test size format
    static QRegularExpression sizePattern("(\\d+)\\s*(MB|GiB)?",
                                          QRegularExpression::CaseInsensitiveOption);

    /// Attempt to match the pattern against the provided test size
    QRegularExpressionMatch match = sizePattern.match(testSize);

    if (match.hasMatch()) {
        /// Extract the numeric value and unit from the match
        qint64 size = match.captured(1).toLongLong();
        /// Convert unit to uppercase
        QString unit = match.captured(2).toUpper();

        /// Unit multipliers for converting to bytes
        static const QHash<QString, qint64> unitMultipliers = {
            {"MB", 1024 * 1024},
            {"GIB", 1024 * 1024 * 1024}
        };

        /// Return the calculated size in bytes
        return size * unitMultipliers.value(unit, 1);
    }

    /// If the test size format doesn't match, return 0
    return 0;
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

/**
 * @brief Writes data to a file.
 *
 * @param data The data to be written to the file.
 * @param fileUrl The URL of the file to write to (can start with "file://").
 */
void System::writeToAFile(const QString &data, const QString &fileUrl) {
    if (!fileUrl.isEmpty()) {
        /// Remove "file://" prefix if present
        QString filePath = fileUrl;
        if (filePath.startsWith("file://")) {
            filePath.remove(0, 7);
        }

        QFile file(filePath);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QTextStream stream(&file);
            stream << data;
            file.close();
        }
    }
}

/**
 * @brief Copies the provided data to the system clipboard.
 * @param data The data to be copied to the clipboard.
 */
void System::copyData(const QString &data) {
    /// Create a QClipboard object to interact with the system clipboard.
    QClipboard *clipboard = QGuiApplication::clipboard();

    /// Set the provided data as text on the clipboard.
    clipboard->setText(data);
}

/**
 * @brief This function retrieves the username of the current system user.
 * @return A QString containing the username of the current user.
 */
QString System::getUser() {
    /// Retrieve the username from the
    /// environment variables using qgetenv function.
    return qgetenv("USER");
}
