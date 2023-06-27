#ifndef __VTK_PROCESS_ENGINE_H_
#define __VTK_PROCESS_ENGINE_H_

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickVTKRenderWindow.h>
#include <QQuickWindow>
#include <QTimer>

#include <vtkAxesActor.h>
#include <vtkRenderer.h>
#include <vtkOrientationMarkerWidget.h>
#include <vtkScalarBarActor.h>

#include "vtkRenderItem.h"

#include <pcl/point_cloud.h>
#include <pcl/point_types.h>

class VTKProcessEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(float progressVal READ progressVal NOTIFY progressValChanged)
    Q_PROPERTY(QString statusLabel READ statusLabel NOTIFY statusLabelChanged)
public:
    VTKProcessEngine();
    void init(QQmlApplicationEngine* engine, QString renderItemObjName, QString statusBarItemObjName);
    void renderCloud(const pcl::PointCloud<pcl::PointXYZRGB>& cloud);
    void updateSelectedRec();
    Q_INVOKABLE void enablePointInfo(const bool isEnable);
    Q_INVOKABLE void clip(const bool isClipInner);
    Q_INVOKABLE void cancelClip();
    Q_INVOKABLE void saveCloud(const QString path);
    Q_INVOKABLE void enableAxes(const bool isEnable);
    Q_INVOKABLE void enableGrid(const bool isEnable);
    Q_INVOKABLE void enableOriention(const bool isEnable);
    Q_INVOKABLE void enableColorBar(const bool isEnable);
    Q_INVOKABLE void enableAreaSelected(const bool isEnable);
    Q_INVOKABLE void enableMesh(const bool isEnable);
    Q_INVOKABLE void enableCloud(const bool isEnable);
    Q_INVOKABLE void statisticalOutRemoval(const float stdThreshold, const float meanK);
    Q_INVOKABLE void release();
    Q_INVOKABLE void surfaceRestruction();
    Q_INVOKABLE void colorizeCloud(QColor color);
    Q_INVOKABLE void cancelColorizeCloud();
    Q_INVOKABLE void jetDepthColorMap();
    Q_INVOKABLE void setCameraViewPort(double x, double y, double z, double fx, double fy, double fz, double vx, double vy, double vz);
    Q_INVOKABLE void getCameraViewPort(double& x, double& y, double& z, double& fx, double& fy, double& fz, double& vx, double& vy, double& vz);
    Q_INVOKABLE inline float progressVal() {
        return __progressVal;
    }
    Q_INVOKABLE inline QString statusLabel() {
        return __statusLabelVal;
    }
signals:
    void progressValChanged();
    void statusLabelChanged();
    void paintRectangle();
private:
    void detectSignals();
    float __progressVal;
    QString __statusLabelVal;
    std::atomic_bool __isProgressValChanged;
    std::atomic_bool __isStatusLabelValChanged;
    QQmlApplicationEngine* __engine;
    VTKRenderItem* __renderItem;
    QQuickVTKRenderWindow* __renderWindow;
    vtkSmartPointer<vtkRenderer> __renderer;
    vtkSmartPointer<vtkOrientationMarkerWidget> __orientationWidget;
    QQuickWindow* __quickWindow;
    vtkNew<vtkAxesActor> __axesActor;
    vtkNew<vtkActor> __gridActor;
    vtkNew<vtkActor> __cloud;
    vtkNew<vtkActor> __mesh;
    vtkNew<vtkScalarBarActor> __scalarBar;
    QObject* __statusBar;
    std::thread __asyncThread;
    QTimer* __timer;
};

#endif //__VTK_PROCESS_ENGINE_H_
