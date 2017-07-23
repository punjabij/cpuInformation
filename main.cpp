#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>

#include "cpumodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    QQuickView viewer;
    CPUModel model(&viewer);
    model.populateModel();

    viewer.engine()->rootContext()->setContextProperty("CpuModel", &model);
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);

    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.showMaximized();


    return app.exec();
}

