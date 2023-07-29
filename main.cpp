#include <iostream>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "benchmark.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *rootContext = engine.rootContext();
    Benchmark *benchmark = new Benchmark();
    rootContext->setContextProperty("benchmark", benchmark);

    const QUrl url(QStringLiteral("qrc:/KitsuneSpecs/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
