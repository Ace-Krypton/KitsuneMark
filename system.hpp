#pragma once

#include <fstream>
#include <filesystem>

#include <QObject>
#include <QString>

class System : public QObject {
    Q_OBJECT

public:
    explicit System(QObject *parent = nullptr);
    Q_INVOKABLE QString extract_ssd();
    Q_INVOKABLE QString extract_cpu();
    Q_INVOKABLE bool is_ssd(const std::filesystem::path &path);
};
