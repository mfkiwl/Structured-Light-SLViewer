#include "calibrationHandEye/include/caliHandEyeLaunch.h"

#include <QFile>

CaliHandEyeLaunch::CaliHandEyeLaunch() : __robotControl(nullptr), __calibrator(nullptr) {

}

bool CaliHandEyeLaunch::connect(const QString robotType, const QString robot_ip) {
    if("aubo" == robotType) {
        __robotControl = new AuboRobotControl();
    }
    else if("ur" == robotType) {
        //TODO@LiuYunhuang:增加UR支持
    }

    return __robotControl->connect(robot_ip.toStdString());
}

bool CaliHandEyeLaunch::disConnect() {
    return __robotControl->disConnect();
}

bool CaliHandEyeLaunch::setTarget(const QString targetType, const QVariantList params) {
    if("eyeInHand" == params[0].toString().toStdString()) {
        __placeMethod = CalibrationHandEye::EyeInHand;
    }
    else if("eyeToHand" == params[0].toString().toStdString()){
        __placeMethod = CalibrationHandEye::EyeToHand;
    }

    if("Tsai" == params[1].toString().toStdString()) {
        __handEyeCaliMethod = cv::HandEyeCalibrationMethod::CALIB_HAND_EYE_TSAI;
    }
    else if("Andreff" == params[1].toString().toStdString()) {
        __handEyeCaliMethod = cv::HandEyeCalibrationMethod::CALIB_HAND_EYE_ANDREFF;
    }
    else if("Park" == params[1].toString().toStdString()) {
        __handEyeCaliMethod = cv::HandEyeCalibrationMethod::CALIB_HAND_EYE_PARK;
    }
    else if("Daniilidis" == params[1].toString().toStdString()) {
        __handEyeCaliMethod = cv::HandEyeCalibrationMethod::CALIB_HAND_EYE_DANIILIDIS;
    }
    else if("Horaud" == params[1].toString().toStdString()) {
        __handEyeCaliMethod = cv::HandEyeCalibrationMethod::CALIB_HAND_EYE_HORAUD;
    }

    __scaleFactor = params[2].toFloat();
    __boardSize = cv::Size(params[3].toInt(), params[4].toInt());

    if(__calibrator) {
        delete __calibrator;
        __calibrator = nullptr;
    }

    if(targetType == "chessBoard") {
        __calibrator = new ChessBoardCalibrator();
        __calibrator->setDistance(params[5].toFloat());
    }
    else if(targetType == "circleBoard") {
        __calibrator = new ChessBoardCalibrator();
        __calibrator->setDistance(params[5].toFloat());
    }
    else if(targetType == "concentricCircleBoard") {
        __calibrator = new ChessBoardCalibrator();
        __calibrator->setRadius(std::vector<float>{params[5].toFloat(), params[6].toFloat(), params[7].toFloat(), params[8].toFloat(), params[9].toFloat()});
    }
}

bool CaliHandEyeLaunch::logPose(const QString imgPath) {
    //检测角点
    cv::Mat img = cv::imread(imgPath.toStdString(), 0);
    std::vector<cv::Point2f> boardPoints;
    bool isFind = __calibrator->findFeaturePoints(img, __boardSize, boardPoints);
    if(!isFind) {
        return false;
    }
    //计算机器人末端位姿
    cv::Mat translation, rotation;
    __robotControl->getCurPose(translation, rotation);
    __poseRBaseToHand.emplace_back(rotation);
    __poseTBaseToHand.emplace_back(translation);
    //计算标定板到传感器位姿
    auto worldPoints = __calibrator->worldPoints();
    cv::Mat rVec, tVec, rMatrix;
    cv::solvePnPRefineLM(worldPoints, boardPoints, __intrinsic, __distort, rVec, tVec);
    cv::Rodrigues(rVec, rMatrix);
    __poseRTargetToEye.emplace_back(rMatrix);
    __poseTTargetToEye.emplace_back(tVec);

    if(__poseRBaseToHand.empty()) {
        cv::FileStorage poseWrite("../out/handEyeImgs/poses.yml", cv::FileStorage::WRITE);
        poseWrite << "poseRobotR_" + std::to_string(__poseRBaseToHand.size() - 1) << rotation;
        poseWrite << "poseRobotT_" + std::to_string(__poseRBaseToHand.size() - 1) << translation;
        poseWrite << "poseTargetR_" + std::to_string(__poseRBaseToHand.size() - 1) << rMatrix;
        poseWrite << "poseTargetT_" + std::to_string(__poseRBaseToHand.size() - 1) << tVec;
        poseWrite.release();
    }
    else {
        cv::FileStorage poseWrite("../out/handEyeImgs/robotPose.yml", cv::FileStorage::APPEND);
        poseWrite << "poseRobotR_" + std::to_string(__poseRBaseToHand.size() - 1) << rotation;
        poseWrite << "poseRobotT_" + std::to_string(__poseRBaseToHand.size() - 1) << translation;
        poseWrite << "poseTargetR_" + std::to_string(__poseRBaseToHand.size() - 1) << rMatrix;
        poseWrite << "poseTargetT_" + std::to_string(__poseRBaseToHand.size() - 1) << tVec;
        poseWrite.release();
    }

    return true;
}

void CaliHandEyeLaunch::initIntrinsic(const cv::Mat& intrinsic, const cv::Mat& distort) {
    __intrinsic = intrinsic;
    __distort = distort;
}

QVariantList CaliHandEyeLaunch::calibrate() {
    if(__handEyeCalibrator) {
        delete __handEyeCalibrator;
        __handEyeCalibrator = nullptr;
    }

    __handEyeCalibrator = new CalibrationHandEye();
    auto errorList = __handEyeCalibrator->calibrate(__poseRTargetToEye, __poseTTargetToEye, __poseRBaseToHand, __poseTBaseToHand, __rSolved, __tSolved, __placeMethod, __handEyeCaliMethod, __scaleFactor);
    return errorList;
}

bool CaliHandEyeLaunch::discard(const int index, const QString filePath) {
    //删除文件
    std::string absPath = filePath.toStdString().substr(8);
    std::cout << absPath << std::endl;
    QFile fileTemp(QString::fromStdString(absPath));
    fileTemp.remove();
    //角点检测失败情况
    if((int)__poseRTargetToEye.size() - 1 < index) {
        //无需做任何事情，系统不存入任何数据
    }
    else {
        __poseRBaseToHand.erase(__poseRBaseToHand.begin() + index);
        __poseTBaseToHand.erase(__poseTBaseToHand.begin() + index);
        __poseRTargetToEye.erase(__poseRTargetToEye.begin() + index);
        __poseTTargetToEye.erase(__poseTTargetToEye.begin() + index);
    }

    return true;
}
