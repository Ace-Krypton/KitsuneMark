#include "system.hpp"

System::System(QObject *parent) : QObject(parent) { }

QString System::extract_cpu() {
    std::string model_name { "model name" }, cpu_info { };
    std::ifstream file { "/proc/cpuinfo" };

    if (!(file.is_open())) return "<unknown>";

    for (std::string line; (std::getline(file, line)); ) {
        if (line.find(model_name) != std::string::npos) {
            const std::size_t start_pos = line.find(model_name);
            std::string temp = line.substr(start_pos + 13);
            const std::size_t stop_pos = temp.find("CPU");
            cpu_info = temp.substr(0, stop_pos);
        }
    }

    file.close();
    return QString::fromStdString(cpu_info);
}

bool System::is_ssd(const std::filesystem::path &path) {
    std::string model_name;
    std::ifstream model_file(path / "device/model");

    if (!model_file.is_open()) return false;

    if (std::getline(model_file, model_name)) {
        std::regex ssd_regex("\\bSSD\\b",
                             std::regex_constants::icase);
        if (std::regex_search(model_name, ssd_regex)) {
            return true;
        }
    }

    return false;
}

QString System::extract_ssd() {
    const std::filesystem::path block_dir = "/sys/block/";
    std::vector<std::filesystem::directory_entry> entries;

    for (const auto &entry :
         std::filesystem::directory_iterator(block_dir)) {
        entries.push_back(entry);
    }

    for (const auto &entry : entries) {
        if (is_ssd(entry)) {
            std::ifstream model_file(entry.path() / "device/model");
            if (model_file.is_open()) {
                std::string ssd_name;
                if (std::getline(model_file, ssd_name)) {
                    return QString::fromStdString(ssd_name);
                }
            }
        }
    }

    return "<unknown>";
}
