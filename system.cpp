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
            const std::size_t stop_pos = temp.find('\"');
            cpu_info = temp.substr(0, stop_pos);
        }
    }

    file.close();
    return QString::fromStdString(cpu_info);
}

bool System::is_ssd(const std::filesystem::path &path) {
    std::string model_name;
    std::ifstream model_file(path / "device/model");

    if (std::getline(model_file, model_name)) {
        std::transform(model_name.begin(),
                       model_name.end(), model_name.begin(), ::toupper);
        return model_name.find("SSD") != std::string::npos;
    }
    return false;
}

QString System::extract_ssd() {
    const std::filesystem::path block_dir = "/sys/block/";

    for (const auto &entry : std::filesystem::directory_iterator(block_dir)) {
        if (is_ssd(entry)) {
            return QString::fromStdString(entry.path().filename());
        }
    }

    return "<unknown>";
}
