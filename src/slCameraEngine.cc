#include <slCameraEngine.h>

#include <cameraFactory.h>

#include <pcl/io/ply_io.h>

#include <QQuickWindow>
#include <QDir>
#include <calibrationHandEye/include/caliHandEyeLaunch.h>

std::mutex lockMutex;

using namespace sl::slCamera;

SLCameraEngine::SLCameraEngine(QObject* parent) : __camera(nullptr), __vtkProcessEngine(nullptr), __isStartDetect(false), __isDetected(false), __isOfflineMode(false), __isAlignedMode(false) {


}

SLCameraEngine::~SLCameraEngine() {
    __isStartDetect.store(false, std::memory_order_release);

    if(__isDetectThread.joinable()) {
        __isDetectThread.join();
    }

    if(__camera) {
        delete __camera;
    }

    if(__vtkProcessEngine) {
        delete __vtkProcessEngine;
    }
}

void SLCameraEngine::bindQMLEngine(QQmlApplicationEngine* engine) {
    __qmlEngine = engine;
}

void SLCameraEngine::bindVTKProcessEngine(VTKProcessEngine* vtkProcessEngine) {
    __vtkProcessEngine = vtkProcessEngine;
}

void SLCameraEngine::configCamera(const QString jsonPath, const QString cameraName) {
    if(__camera) {
        delete __camera;
        __camera = nullptr;
    }

    if(cameraName == "binoocularCamera") {
        __camera = new BinocularCamera(jsonPath.toStdString());
        __isBinoocular = true;
    }
    else if(cameraName == "monocularCamera") {
        __isBinoocular = false;
    }

    if(__isStartDetect.load(std::memory_order_acquire)) {
        __isStartDetect.store(false, std::memory_order_release);
        if(__isDetectThread.joinable()) {
            __isDetectThread.join();
        }
    }

    __isStartDetect.store(true, std::memory_order_release);
    __isDetectThread = std::thread([&] {
        while(__isStartDetect.load(std::memory_order_acquire)) {
            bool isDetected = __isDetected;
            {
                std::lock_guard<std::mutex> gaurd(lockMutex);
                __isDetected =__camera->getCameraInfo().__isFind;
            }
            if(isDetected != __isDetected) {
                emit isDetectedChanged();
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        }
    });

    __depthItem->setHeight(__depthItem->width() * getStringAttribute("Pixels Of Height").toDouble() / getStringAttribute("Pixels Of Width").toDouble());
    __textureItem->setHeight(__textureItem->width() * getStringAttribute("Pixels Of Height").toDouble() / getStringAttribute("Pixels Of Width").toDouble());
}

bool SLCameraEngine::connect() {
    return __camera->connect();
}

bool SLCameraEngine::disConnect() {
    return __camera->disConnect();
}

bool SLCameraEngine::isConnect() {
    return __camera->isConnect();
}

bool SLCameraEngine::capture() {
    bool isSucess = false;

    if(__isOfflineMode) {
        isSucess = offLineCapture("../out/offlineData/L", "../out/offlineData/R");
    }
    else {
        isSucess = __camera->capture(__frameData);
    }
    
    //TODO@LiuYunhuang:由绑定的vtk渲染器进行渲染    
    __vtkProcessEngine->renderCloud(__frameData.__pointCloud);

    double minVal = FLT_MAX, maxVal = FLT_MAX;
    std::vector<float> depth = __frameData.__depthMap.reshape(1, 1);
    for (auto& val : depth) {
        if (val < 5) {
            continue;
        }

        minVal = val < minVal ? val : minVal;
    }
    cv::minMaxLoc(__frameData.__depthMap, nullptr, &maxVal);
    cv::Mat depthColor = (__frameData.__depthMap - minVal) / (maxVal - minVal) * 255;
    depthColor.convertTo(depthColor, CV_8UC1);
    cv::applyColorMap(depthColor, depthColor, cv::COLORMAP_JET);
    __depthItem->updateImage(QImage(depthColor.data, depthColor.cols, depthColor.rows, depthColor.step, QImage::Format_BGR888));
    __textureItem->updateImage(QImage(__frameData.__textureMap.data, __frameData.__textureMap.cols, __frameData.__textureMap.rows, depthColor.step, QImage::Format_BGR888));

    return isSucess;
}

bool SLCameraEngine::offLineCapture(const QString leftImgPath, const QString rightImgPath) {
    std::vector<cv::String> leftImgPaths, rightImgPaths;
    cv::glob(leftImgPath.toStdString(), leftImgPaths);
    cv::glob(rightImgPath.toStdString(), rightImgPaths);

    std::vector<cv::Mat> leftImgs, rightImgs;

    for (size_t i = 0; i < leftImgPaths.size(); ++i) {
        std::string imgPath = leftImgPath.toStdString() + "/" + std::to_string(i) + ".bmp";
        leftImgs.emplace_back(cv::imread(imgPath, cv::IMREAD_UNCHANGED));
    }

    for (size_t i = 0; i < rightImgPaths.size(); ++i) {
        std::string imgPath = rightImgPath.toStdString() + "/" + std::to_string(i) + ".bmp";
        rightImgs.emplace_back(cv::imread(imgPath, cv::IMREAD_UNCHANGED));
    }

    __camera->offLineCapture(leftImgs, rightImgs, __frameData);

    return true;
}

bool SLCameraEngine::setDepthCameraEnabled(const bool isEnabale) {
    return __camera->setDepthCameraEnabled(isEnabale);
}

QString SLCameraEngine::getStringAttribute(const QString attributeName) {
    std::string attributeVal;
    __camera->getStringAttribute(attributeName.toStdString(), attributeVal);
    return QString::fromStdString(attributeVal);
}

double SLCameraEngine::getNumbericalAttribute(const QString attributeName) {
    double val;
    __camera->getNumbericalAttribute(attributeName.toStdString(), val);
    return val;
}

bool SLCameraEngine::getBooleanAttribute(const QString attributeName) {
    bool val;
    __camera->getBooleanAttribute(attributeName.toStdString(), val);
    return val;
}

bool SLCameraEngine::setStringAttribute(const QString attributeName, const QString val) {
    return __camera->setStringAttribute(attributeName.toStdString(), val.toStdString());
}

bool SLCameraEngine::setNumbericalAttribute(const QString attributeName, const double val) {
    return __camera->setNumberAttribute(attributeName.toStdString(), val);
}

bool SLCameraEngine::setBooleanAttribute(const QString attributeName, const bool val) {
    return __camera->setBooleanAttribute(attributeName.toStdString(), val);
}

bool SLCameraEngine::resetCameraConfig() {
    return __camera->resetCameraConfig();
}

bool SLCameraEngine::updateCamera() {
    return __camera->updateCamera();
}

bool SLCameraEngine::enableAlignedMode(const bool isEnable) {
    __isAlignedMode = isEnable;
    return true;
}

bool SLCameraEngine::enableOfflineMode(const bool isEnable) {
    __isOfflineMode = isEnable;
    return true;
}

void SLCameraEngine::bindDepthAndTextureItem(ImagePaintItem* depthItem, ImagePaintItem* textureItem) {
    __depthItem = depthItem;
    __textureItem = textureItem;
}

bool SLCameraEngine::changeTo2DMode() {
    //将相机设置为硬触发模式
    __camera->setDepthCameraEnabled(true);
    __camera->updateCamera();
    //获取深度相机
    auto cameraFactory = __camera->getCameraFacrtory();
    std::string leftCameraName, manufactor;
    __camera->getStringAttribute("Left Camera Name", leftCameraName);
    __camera->getStringAttribute("2D Camera Manufactor", manufactor);
    sl::camera::CameraFactory::CameraManufactor camManufactor = manufactor == "Huaray" ? sl::camera::CameraFactory::Huaray : sl::camera::CameraFactory::Halcon;
    auto depthCamera = cameraFactory->getCamera(leftCameraName, camManufactor);
    //depthCamera->pause();
    //depthCamera->setTrigMode(sl::camera::TrigMode::trigContinous);
    depthCamera->pause();
    depthCamera->setEnumAttribute("TriggerMode", "Off");
    depthCamera->clearImgs();
    //depthCamera->setBooleanAttribute("AcquisitionFrameRateEnable", true);
    //depthCamera->setNumberAttribute("AcquisitionFrameRate", 30);

    return true;
}

bool SLCameraEngine::changeCameraExposureTime(const int exposureTime) {
    //获取深度相机
    auto cameraFactory = __camera->getCameraFacrtory();
    std::string leftCameraName, manufactor;
    __camera->getStringAttribute("Left Camera Name", leftCameraName);
    __camera->getStringAttribute("2D Camera Manufactor", manufactor);
    sl::camera::CameraFactory::CameraManufactor camManufactor = manufactor == "Huaray" ? sl::camera::CameraFactory::Huaray : sl::camera::CameraFactory::Halcon;
    auto depthCamera = cameraFactory->getCamera(leftCameraName, camManufactor);
    depthCamera->setNumberAttribute("ExposureTime", exposureTime);

    return true;
}

bool SLCameraEngine::continueCapture(const int channel) {
    auto rootWindow = qobject_cast<QQuickWindow*>(__qmlEngine->rootObjects().value(0));
    if(0 == channel) {
        __continuesItem = rootWindow->findChild<ImagePaintItem*>("continuesPaintItem");
        __continuesItem->setHeight(__continuesItem->width() * getStringAttribute("Pixels Of Height").toDouble() / getStringAttribute("Pixels Of Width").toDouble());
        __continuesItem->updateImage(QImage("../ui/icons/baseline_image_white_36dp.png"));
        QObject::connect(this, &SLCameraEngine::updateContinuesImg, __continuesItem, &ImagePaintItem::updateImage);
    }
    else if(1 == channel) {
        __calibrationPaintItem = rootWindow->findChild<ImagePaintItem*>("calibrationPaintItem");
        __calibrationPaintItem->setHeight(__continuesItem->width() * getStringAttribute("Pixels Of Height").toDouble() / getStringAttribute("Pixels Of Width").toDouble());
        __calibrationPaintItem->updateImage(QImage("../ui/icons/baseline_image_white_36dp.png"));
        QObject::connect(this, &SLCameraEngine::updateContinuesImg, __calibrationPaintItem, &ImagePaintItem::updateImage);
    }
    //获取深度相机
    auto cameraFactory = __camera->getCameraFacrtory();
    std::string leftCameraName, manufactor;
    __camera->getStringAttribute("Left Camera Name", leftCameraName);
    __camera->getStringAttribute("2D Camera Manufactor", manufactor);
    sl::camera::CameraFactory::CameraManufactor camManufactor = manufactor == "Huaray" ? sl::camera::CameraFactory::Huaray : sl::camera::CameraFactory::Halcon;
    auto depthCamera = cameraFactory->getCamera(leftCameraName, camManufactor);
    depthCamera->resume();

    __isFinishUpdateImg.store(false, std::memory_order_release);
    __updateImgThread = std::thread([&, depthCamera]{
        auto beginTime = std::chrono::steady_clock::now();
        while(!__isFinishUpdateImg.load(std::memory_order_acquire)) {
            //注意以下使用方法将出错，考虑优化导致
            //auto imgs = depthCamera->getImgs();
            if(!depthCamera->getImgs().empty()) {
                {
                    std::lock_guard<std::mutex> lockGaurd(__realTimeMutex);
                    __curRealTimeImg = depthCamera->popImg();
                }

                auto curTime = std::chrono::steady_clock::now();
                auto time = std::chrono::duration_cast<std::chrono::milliseconds>(curTime - beginTime).count() * (double)std::chrono::milliseconds::period::num / std::chrono::milliseconds::period::den;

                if(time > 0.03) {
                    if(__curRealTimeImg.type() == CV_8UC3) {
                        emit updateContinuesImg(QImage(__curRealTimeImg.data, __curRealTimeImg.cols, __curRealTimeImg.rows, __curRealTimeImg.step, QImage::Format_BGR888).copy());
                    }
                    else {
                        emit updateContinuesImg(QImage(__curRealTimeImg.data, __curRealTimeImg.cols, __curRealTimeImg.rows, __curRealTimeImg.step, QImage::Format_Grayscale8).copy());
                    }
                    beginTime = std::chrono::steady_clock::now();
                }
            }
        }
    });

    return true;
}

bool SLCameraEngine::stopCapture(const int channel) {
    //结束渲染线程
    __isFinishUpdateImg.store(true, std::memory_order_release);
    if(__updateImgThread.joinable()) {
        __updateImgThread.join();
    }
    //获取深度相机
    auto cameraFactory = __camera->getCameraFacrtory();
    std::string leftCameraName, manufactor;
    __camera->getStringAttribute("Left Camera Name", leftCameraName);
    __camera->getStringAttribute("2D Camera Manufactor", manufactor);
    sl::camera::CameraFactory::CameraManufactor camManufactor = manufactor == "Huaray" ? sl::camera::CameraFactory::Huaray : sl::camera::CameraFactory::Halcon;
    auto depthCamera = cameraFactory->getCamera(leftCameraName, camManufactor);
    //depthCamera->pause();
    //将相机设置为硬触发模式并重置曝光时间
    depthCamera->setEnumAttribute("TriggerMode", "On");
    //__camera->setDepthCameraEnabled(true);
    //__camera->updateCamera();
    double exposureTime;
    __camera->getNumbericalAttribute("ExposureTime", exposureTime);
    depthCamera->setNumberAttribute("ExposureTime", exposureTime);
    depthCamera->setBooleanAttribute("AcquisitionFrameRateEnable", false);
    //depthCamera->resume();
    depthCamera->clearImgs();

    if(0 == channel) {
        QObject::disconnect(this, &SLCameraEngine::updateContinuesImg, __continuesItem, &ImagePaintItem::updateImage);
    }
    else if(1 == channel) {
        QObject::disconnect(this, &SLCameraEngine::updateContinuesImg, __calibrationPaintItem, &ImagePaintItem::updateImage);
    }

    return true;
}

QString SLCameraEngine::logCurImg(const int index) {
    std::lock_guard<std::mutex> lockGaurd(__realTimeMutex);
    cv::imwrite("../out/handEyeImgs/" + std::to_string(index) + ".bmp", __curRealTimeImg);

    QString writePath = QDir::currentPath() + QString::fromStdString("/../out/handEyeImgs/" + std::to_string(index) + ".bmp");
    return writePath;
}

void SLCameraEngine::initHandEyeCaliIntrin() {
    auto rootWindow = qobject_cast<QQuickWindow*>(__qmlEngine->rootObjects().value(0));
    auto caliHandEyeLaunch = rootWindow->findChild<CaliHandEyeLaunch*>("caliHandEyeLaunch");
    auto info = __camera->getCameraInfo();
    caliHandEyeLaunch->initIntrinsic(info.__intrinsic, info.__distort);
}
