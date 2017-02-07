#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qDebug() << "hello";
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}


