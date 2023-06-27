#ifndef __SL_CAMERA_ENGINE_H_
#define __SL_CAMERA_ENGINE_H_

#include <thread>

#include <QObject>

#include <binoocularCamera.h>

#include <vtkProcessEngine.h>
#include <imagePaintItem.h>

class SLCameraEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isDetected READ isDetected NOTIFY isDetectedChanged)
public:
    SLCameraEngine(QObject* parent = nullptr);
    ~SLCameraEngine();
    void bindVTKProcessEngine(VTKProcessEngine* vtkProcessEngine);
    void bindDepthAndTextureItem(ImagePaintItem* depthItem, ImagePaintItem* textureItem);
    Q_INVOKABLE void configCamera(const QString jsonPath, const QString cameraName);
    Q_INVOKABLE bool connect();
    Q_INVOKABLE bool disConnect();
    Q_INVOKABLE bool isConnect();
    Q_INVOKABLE bool capture();
    Q_INVOKABLE bool setDepthCameraEnabled(const bool isEnabale);
    Q_INVOKABLE bool getStringAttribute(const QString attributeName, QString& val);
    Q_INVOKABLE bool getNumbericalAttribute(const QString attributeName, double& val);
    Q_INVOKABLE bool getBooleanAttribute(const QString attributeName, bool& val);
    Q_INVOKABLE bool setStringAttribute(const QString attributeName, const QString val);
    Q_INVOKABLE bool setNumbericalAttribute(const QString attributeName, const double val);
    Q_INVOKABLE bool setBooleanAttribute(const QString attributeName, const bool val);
    Q_INVOKABLE bool resetCameraConfig();
    Q_INVOKABLE bool updateCamera();

    Q_INVOKABLE bool continueCapture();
    Q_INVOKABLE bool stopCapture();
    Q_INVOKABLE bool enableAlignedMode(const bool isEnable);
    Q_INVOKABLE bool enableOfflineMode(const bool isEnable);

    Q_INVOKABLE inline bool isDetected() {
        return __isDetected;
    }
signals:
    void isDetectedChanged();
private:
    bool offLineCapture(const QString leftImgPath, const QString rightImgPath);
    bool __isAlignedMode;
    bool __isOfflineMode;
    bool __isBinoocular;
    bool __isDetected;
    sl::slCamera::SLCamera* __camera;
    VTKProcessEngine* __vtkProcessEngine;
    sl::slCamera::FrameData __frameData;
    vtkNew<vtkActor> __platformGridActor;
    std::atomic_bool __isStartDetect;
    std::thread __isDetectThread;
    ImagePaintItem* __depthItem;
    ImagePaintItem* __textureItem;
};

#endif //!__SL_CAMERA_ENGINE_H_
