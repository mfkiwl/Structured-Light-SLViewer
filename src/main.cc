#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

#include <QQuickVTKRenderWindow.h>
#include <QQuickVTKRenderItem.h>
#include <QQuickVTKInteractiveWidget.h>
#include <QQmlContext>
#include <QtWebEngineCore>
#include <QtWebEngine>

#include "frameLessWindowHelper.h"
#include "vtkRenderItem.h"
#include "vtkProcessEngine.h"
#include "slCameraEngine.h"
#include "imagePaintItem.h"

#include <vtkPolyDataMapper.h>
#include <vtkConeSource.h>

#include "calibrationMaster/include/calibrateLaucher.h"
#include "calibrationMaster/include/cameraModel.h"
#include "calibrationMaster/include/paintItem.h"

#include "grayPhaseEncoder/include/imageModel.h"
#include "grayPhaseEncoder/include/codeMakerLauncher.h"

int main(int argc, char *argv[])
{
    QQuickVTKRenderWindow::setupGraphicsBackend();
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);
    QtWebEngine::initialize();
    app.setApplicationName("SLViewer");
    app.setApplicationDisplayName("SLViewer");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("@Liu Yunhuang");
    app.setWindowIcon(QIcon("qrc:/icons/application.ico"));

    QQmlApplicationEngine engine;
    qmlRegisterType<FramelessWindowHelper>("FramelessWindowHelper", 1, 0, "FramelessWindowHelper");
    qmlRegisterType<VTKProcessEngine>("VTKProcessEngine", 1, 0, "VTKProcessEngine");
    qmlRegisterType<QQuickVTKRenderWindow>("VTKRenderWindow", 9, 2, "VTKRenderWindow");
    qmlRegisterType<QQuickVTKInteractiveWidget>("VTKInteractiveWidget", 9, 2, "VTKInteractiveWidget");
    qmlRegisterType<VTKRenderItem>("VTKRenderItem", 9, 2, "VTKRenderItem");
    qmlRegisterType<CameraModel>("CameraModel", 1, 0, "CameraModel");
        qmlRegisterType<PaintItem>("PaintItem", 1, 0, "PaintItem");
        qmlRegisterType<CalibrateLaucher>("CalibrateLaucher", 1, 0,
                                          "CalibrateLaucher");
    qmlRegisterType<ImageModel>("ImageModel", 1, 0,
                                      "ImageModel");
    qmlRegisterType<CodeMakerLauncher>("CodeMakerLauncher", 1, 0,
                                      "CodeMakerLauncher");
    qmlRegisterType<SLCameraEngine>("SLCameraEngine", 1, 0,
                                      "SLCameraEngine");
    qmlRegisterType<ImagePaintItem>("ImagePaintItem", 1, 0,
                                      "ImagePaintItem");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    auto rootWindow = qobject_cast<QQuickWindow*>(engine.rootObjects().value(0));

    auto vtkProcessEngine = rootWindow->findChild<VTKProcessEngine*>("vtkProcessEngine");
    vtkProcessEngine->init(&engine, "renderItem", "statusBar");

    auto depthItem = rootWindow->findChild<ImagePaintItem*>("depthItem");
    auto textureItem = rootWindow->findChild<ImagePaintItem*>("textureItem");
    depthItem->updateImage(QImage("../ui/icons/baseline_image_white_36dp.png"));
    textureItem->updateImage(QImage("../ui/icons/baseline_image_white_36dp.png"));

    auto slCameraEngine = rootWindow->findChild<SLCameraEngine*>("slCameraEngine");
    slCameraEngine->bindVTKProcessEngine(vtkProcessEngine);
    slCameraEngine->bindDepthAndTextureItem(depthItem, textureItem);

    return app.exec();
}
