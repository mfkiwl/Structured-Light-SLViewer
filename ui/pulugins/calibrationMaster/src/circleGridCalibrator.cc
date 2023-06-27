#include "CalibrationMaster/include/circleGridCalibrator.h"

CircleGridCalibrator::CircleGridCalibrator() {}

CircleGridCalibrator::~CircleGridCalibrator() {}

bool CircleGridCalibrator::findFeaturePoints(
    const cv::Mat &img, const cv::Size &featureNums,
    std::vector<cv::Point2f> &points, const ThreshodMethod threshodType) {
    CV_Assert(!img.empty());
    points.clear();

    bool isFind = cv::findCirclesGrid(img, featureNums, points, cv::CALIB_CB_SYMMETRIC_GRID | cv::CALIB_CB_ADAPTIVE_THRESH | cv::CALIB_CB_CLUSTERING);
    cv::Mat imgCounter;
    if(!isFind) {
        imgCounter = 255 - img;
        isFind = cv::findCirclesGrid(imgCounter, featureNums, points, cv::CALIB_CB_SYMMETRIC_GRID | cv::CALIB_CB_ADAPTIVE_THRESH | cv::CALIB_CB_CLUSTERING);
        if (!isFind) {
            return false;
        }
        cv::find4QuadCornerSubpix(imgCounter, points, featureNums);
    }
    else {
        cv::find4QuadCornerSubpix(img, points, featureNums);
    }


    return isFind;
}

double CircleGridCalibrator::calibrate(const std::vector<cv::Mat> &imgs,
                                       cv::Mat &intrinsic, cv::Mat &distort,
                                       const cv::Size &featureNums,
                                       float &process,
                                       const ThreshodMethod threshodType,
                                       const bool blobBlack) {
    m_imgPoints.clear();
    m_worldPoints.clear();

    std::vector<cv::Point3f> worldPointsCell;
    for (int i = 0; i < featureNums.height; ++i) {
        for (int j = 0; j < featureNums.width; ++j) {
            worldPointsCell.emplace_back(
                cv::Point3f(j * m_distance, i * m_distance, 0));
        }
    }
    for (int i = 0; i < imgs.size(); ++i)
        m_worldPoints.emplace_back(worldPointsCell);

    for (int i = 0; i < imgs.size(); ++i) {
        std::vector<cv::Point2f> imgPointCell;
        if (!findFeaturePoints(imgs[i], featureNums, imgPointCell)) {
            return -999999;
        } else {
            m_imgPoints.emplace_back(imgPointCell);

            cv::Mat imgWithFeature = imgs[i].clone();
            if (imgWithFeature.type() == CV_8UC1) {
                cv::cvtColor(imgWithFeature, imgWithFeature,
                             cv::COLOR_GRAY2BGR);
            }

            cv::drawChessboardCorners(imgWithFeature, featureNums, imgPointCell,
                                      true);

            cv::imwrite("imgWithFeature" + std::to_string(static_cast<float>(i + 1) / imgs.size()) + ".png",
                        imgWithFeature);

            process = static_cast<float>(i + 1) / imgs.size();
        }
    }

    std::vector<cv::Mat> rvecs, tvecs;
    double error =
        cv::calibrateCamera(m_worldPoints, m_imgPoints, imgs[0].size(),
                            intrinsic, distort, rvecs, tvecs);
    return error;
}
