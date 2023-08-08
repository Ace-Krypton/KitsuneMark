#pragma once

#include <regex>
#include <fstream>
#include <iostream>
#include <filesystem>

#include <QObject>
#include <QString>
#include <QTextStream>

class System : public QObject {
    Q_OBJECT

public:
    explicit System(QObject *parent = nullptr);

    Q_INVOKABLE QString extract_ssd();
    Q_INVOKABLE QString extract_cpu();
    Q_INVOKABLE QString extract_storage();
    Q_INVOKABLE bool is_ssd(const std::filesystem::path &path);
};
