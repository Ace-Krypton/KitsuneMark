#pragma once

#include <regex>
#include <fstream>
#include <iostream>
#include <filesystem>

#include <QFile>
#include <QObject>
#include <QString>
#include <QIODevice>
#include <QTextStream>

class System : public QObject {
    Q_OBJECT

public:
    explicit System(QObject *parent = nullptr);

    Q_INVOKABLE QString extractSSD();
    Q_INVOKABLE QString extractCPU();
    Q_INVOKABLE QString extractStorage();
    Q_INVOKABLE QString checkFIOVersion();
    Q_INVOKABLE bool isSSD(const std::filesystem::path &path);
    Q_INVOKABLE void writeToAFile(const QString &data, const QString &fileUrl);
};
