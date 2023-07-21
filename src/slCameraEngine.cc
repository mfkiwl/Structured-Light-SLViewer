#include <slCameraEngine.h>

#include <pcl/io/ply_io.h>

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
    __depthItem->updateImage(QImage(depthColor.data, depthColor.cols, depthColor.rows, QImage::Format_RGB888).copy());
    __textureItem->updateImage(QImage(__frameData.__textureMap.data, __frameData.__textureMap.cols, __frameData.__textureMap.rows, QImage::Format_RGB888));

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

bool SLCameraEngine::getStringAttribute(const QString attributeName, QString& val) {
    std::string attributeVal;
    bool isSucess = __camera->getStringAttribute(attributeName.toStdString(), attributeVal);
    val = QString::fromStdString(attributeVal);
    return isSucess;
}

bool SLCameraEngine::getNumbericalAttribute(const QString attributeName, double& val) {
    return __camera->getNumbericalAttribute(attributeName.toStdString(), val);
}

bool SLCameraEngine::getBooleanAttribute(const QString attributeName, bool& val) {
    return __camera->getBooleanAttribute(attributeName.toStdString(), val);
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

bool SLCameraEngine::continueCapture() {
    //TODO@LiuYunhuang:增加连续拍照支持

    return true;
}

bool SLCameraEngine::stopCapture() {
    //TODO@LiuYunhuang:增加停止拍照支持

    return true;
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
