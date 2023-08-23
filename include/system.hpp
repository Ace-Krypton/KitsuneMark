#pragma once

#include <regex>
#include <fstream>
#include <stdlib.h>
#include <iostream>
#include <filesystem>

#include <QFile>
#include <QObject>
#include <QString>
#include <QIODevice>
#include <QClipboard>
#include <QTextStream>
#include <QStorageInfo>
#include <QStandardPaths>
#include <QGuiApplication>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

class System : public QObject {
    Q_OBJECT

public:
    explicit System(QObject *parent = nullptr);

    Q_INVOKABLE QString getUser();
    Q_INVOKABLE QString extractSSD();
    Q_INVOKABLE QString extractCPU();
    Q_INVOKABLE QString extractStorage();
    Q_INVOKABLE QString checkFIOVersion();
    Q_INVOKABLE void copyData(const QString &data);
    Q_INVOKABLE bool hasEnoughSpace(const QString &testSize);
    Q_INVOKABLE qint64 parseTestSize(const QString &testSize);
    Q_INVOKABLE bool isSSD(const std::filesystem::path &path);
    Q_INVOKABLE void writeToAFile(const QString &data, const QString &fileUrl);
};
