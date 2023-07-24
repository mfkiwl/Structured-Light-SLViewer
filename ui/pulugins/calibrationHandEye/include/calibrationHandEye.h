#ifndef __CALIBATION_HAND_EYE_H__
#define __CALIBATION_HAND_EYE_H

#include <calibrationMaster/include/chessBoardCalibrator.h>
#include <calibrationMaster/include/circleGridCalibrator.h>
#include <calibrationMaster/include/concentricRingCalibrator.h>

#include <opencv2/opencv.hpp>

#include <QVariantList>

/** \@brief 手眼标定类 */
class CalibrationHandEye {
public:
  /** \@brief 传感器位置 */
  enum EyePlaceMethod {
    EyeInHand = 0, //眼在手上
    EyeToHand      //眼在手外
  };
  /**
   * @brief 进行手眼标定
   * 
   * @param cameraSolveRotation     各位姿下传感器求解所得旋转矩阵
   * @param cameraSolveTranslation  各位姿下传感器求解所得平移矩阵
   * @param robotRotation           各位姿下机器人旋转矩阵
   * @param robotTranslation        各位姿下机器人平移矩阵
   * @param solvedRotation          求解所得的旋转矩阵
   * @param solvedTranslation       求解所得的平移矩阵
   * @param scaleFactor             缩放系数(默认单位:m,默认缩放系数:1)
   * @return QVariantList 各位姿下x、y、z误差
   */
  QVariantList
  calibrate(const std::vector<cv::Mat> &cameraSolveRotation,
            const std::vector<cv::Mat> &cameraSolveTranslation,
            const std::vector<cv::Mat> &robotRotation,
            const std::vector<cv::Mat> &robotTranslation,
            cv::Mat &solvedRotation, cv::Mat &solvedTranslation,
            EyePlaceMethod eyePlaceMethod = EyeInHand,
            cv::HandEyeCalibrationMethod calibrationMethod = cv::HandEyeCalibrationMethod::CALIB_HAND_EYE_TSAI,
            const float scaleFactor = 1.f);
private:
};

#endif
