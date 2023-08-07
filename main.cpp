#include <iostream>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "system.hpp"
#include "builder.hpp"
#include "benchmark.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *rootContext = engine.rootContext();

    Benchmark benchmark;
    rootContext->setContextProperty("benchmark", &benchmark);

    Builder builder;
    rootContext->setContextProperty("builder", &builder);

    qmlRegisterType<System>("CustomTypes", 1, 0, "System");

    const QUrl url(QStringLiteral("qrc:/KitsuneSpecs/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
