#include "../include/system.hpp"

System::System(QObject *parent) : QObject(parent) { }

/**
 * @brief Extracts the CPU information from the /proc/cpuinfo file.
 *
 * @return A QString containing the extracted CPU information.
 */
QString System::extract_cpu() {
    std::string model_name { "model name" }, cpu_info { };
    std::ifstream file { "/proc/cpuinfo" };

    /// Check if the file can be opened,
    /// return "<unknown>" if not.
    if (!(file.is_open())) return "<unknown>";

    /// Iterate through the lines of the file to find the CPU model information.
    for (std::string line; (std::getline(file, line)); ) {
        if (line.find(model_name) != std::string::npos) {
            const std::size_t start_pos = line.find(model_name);
            std::string temp = line.substr(start_pos + 13);
            const std::size_t stop_pos = temp.find("CPU");
            cpu_info = temp.substr(0, stop_pos);
        }
    }

    file.close();
    ///Convert the extracted CPU information to a QString.
    return QString::fromStdString(cpu_info);
}

/**
 * @brief Checks if the device at the specified path is an SSD.
 *
 * @param path The path to the device's directory.
 * @return True if the device is an SSD, false otherwise.
 */
bool System::is_ssd(const std::filesystem::path &path) {
    std::string model_name;
    std::ifstream model_file(path / "device/model");

    /// Check if the model file can be opened,
    /// indicating the device exists.
    if (!model_file.is_open()) return false;

    /// Read the model name from the model file.
    if (std::getline(model_file, model_name)) {
        /// Define a regular expression pattern to identify SSDs.
        std::regex ssd_regex("\\bSSD\\b",
                             std::regex_constants::icase);
        /// Search for the SSD pattern in the model name.
        if (std::regex_search(model_name, ssd_regex)) {
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
QString System::extract_ssd() {
    const std::filesystem::path block_dir = "/sys/block/";
    std::vector<std::filesystem::directory_entry> entries;

    /// Collect information about block devices in the system.
    for (const auto &entry :
         std::filesystem::directory_iterator(block_dir)) {
        entries.push_back(entry);
    }

    /// Iterate through block devices to find the first SSD.
    for (const auto &entry : entries) {
        if (is_ssd(entry)) {
            std::ifstream model_file(entry.path() / "device/model");
            if (model_file.is_open()) {
                std::string ssd_name;
                if (std::getline(model_file, ssd_name)) {
                    ///Return the model name of the detected SSD.
                    return QString::fromStdString(ssd_name);
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
QString System::extract_storage() {
    /// Get information about the available
    /// and total storage space on the root filesystem.
    std::filesystem::space_info storage_info = std::filesystem::space("/");

    const double bytes_to_gib = 1024 * 1024 * 1024.0;
    double available_gb = storage_info.available / bytes_to_gib;
    double capacity_gb = storage_info.capacity / bytes_to_gib;
    double percentage = (available_gb / capacity_gb) * 100.0;

    QString result;
    QTextStream stream(&result);
    stream.setRealNumberPrecision(2);
    stream.setRealNumberNotation(QTextStream::FixedNotation);

    /// Construct the storage information string.
    stream << '/' << ": " << percentage << "% "
           << '(' << available_gb << '/'
           << capacity_gb << " GiB" << ')';

    return result;
}
