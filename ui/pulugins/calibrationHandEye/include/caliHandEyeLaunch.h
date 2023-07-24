#ifndef __CALI_HAND_EYEY_LAUNCH_H__
#define __CALI_HAND_EYEY_LAUNCH_H__

#include <QObject>
#include <QVariantList>

#include <opencv2/opencv.hpp>

#include "auboRobotControl.h"
#include "calibrationHandEye.h"

#include "calibrationMaster/include/chessBoardCalibrator.h"
#include "calibrationMaster/include/circleGridCalibrator.h"
#include "calibrationMaster/include/concentricRingCalibrator.h"

class CaliHandEyeLaunch : public QObject{
    Q_OBJECT
public:
    CaliHandEyeLaunch();
    Q_INVOKABLE void initIntrinsic(const cv::Mat& intrinsic, const cv::Mat& distort);
    Q_INVOKABLE bool connect(const QString robotType, const QString robot_ip);
    Q_INVOKABLE bool disConnect();
    Q_INVOKABLE bool setTarget(const QString targetType, const QVariantList params);
    Q_INVOKABLE bool logPose(const QString imgPath);
    Q_INVOKABLE QVariantList calibrate();
    Q_INVOKABLE bool discard(const int index, const QString filePath);
private:
    cv::Mat __intrinsic;
    cv::Mat __distort;
    cv::Mat __rSolved;
    cv::Mat __tSolved;
    std::vector<cv::Mat> __poseRBaseToHand;
    std::vector<cv::Mat> __poseTBaseToHand;
    std::vector<cv::Mat> __poseRTargetToEye;
    std::vector<cv::Mat> __poseTTargetToEye;
    RobotControl* __robotControl;
    Calibrator* __calibrator;
    CalibrationHandEye* __handEyeCalibrator;
    cv::Size __boardSize;
    CalibrationHandEye::EyePlaceMethod __placeMethod;
    cv::HandEyeCalibrationMethod __handEyeCaliMethod;
    float __scaleFactor;
};

#endif //!__CALI_HAND_EYEY_LAUNCH_H__
