#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>

#include <QtWidgets/QApplication> //need this for charts module

#include "coffeecupmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    //c++ models
    CoffeeCupModel coffeeCupModel;

    QQmlApplicationEngine engine;

    //qml context of models
    QQmlContext* context = engine.rootContext();
    context->setContextProperty("coffeeCupModel", &coffeeCupModel);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
