#include "calibrationMaster/include/calibrateLaucher.h"

CalibrateLaucher::CalibrateLaucher(QObject *parent)
    : m_progress(0), m_imgProcessIndex(0), m_isFinish(false) {
    m_caliPaker.bundleCaliInfo(m_info);
}

CalibrateLaucher::~CalibrateLaucher() {
    for (auto calibrator : m_calibrators)
        delete calibrator;
}

void CalibrateLaucher::addCalibrator(const QList<QString> &imgPaths,
                                     const BoardType &boradType) {
    if (!imgPaths.size())
        return;

    Calibrator *calibrator = nullptr;

    switch (boradType) {
    case chess: {
        calibrator = new ChessBoardCalibrator();
        break;
    }
    case circleGrid: {
        calibrator = new CircleGridCalibrator();
        break;
    }
    case concentricCircle: {
        calibrator = new ConcentricRingCalibrator();
        break;
    }
    }

    m_calibrators.emplace_back(calibrator);

    for (int i = 0; i < imgPaths.size(); ++i) {
        cv::Mat img = cv::imread(imgPaths.value(i).toStdString(), 0);
        calibrator->emplace(img);
    }
}

void CalibrateLaucher::setRingRadius(const QVector4D radius) {
    if (!m_calibrators.size())
        return;

    std::vector<float> ringRadius = { radius.x(), radius.y(), radius.z(), radius.w() };

    for (auto& calibrator : m_calibrators) {
        calibrator->setRadius(ringRadius);
    }
}

void CalibrateLaucher::clearCalibrator() { m_calibrators.clear(); }

void CalibrateLaucher::calibrate(const int rowNum, const int colNum,
                                 const float trueDistance) {
    if (!m_calibrators.size())
        return;

    m_curCaliType = CaliType::LeftCamera;

    if (m_calibrationThread.joinable()) {
        m_calibrationThread.join();
    }

    m_isFinish.store(false, std::memory_order_release);
    m_updateThread = std::thread(&CalibrateLaucher::timer_timeout_slot, this);

    m_calibrators[0]->setDistance(trueDistance);
    m_calibrationThread = std::thread([&, colNum, rowNum] {
        double error = m_calibrators[0]->calibrate(
            m_calibrators[0]->imgs(), m_info.M1, m_info.D1,
            cv::Size(colNum, rowNum), m_progress);

        m_caliPaker.writeCaliInfo(CaliType::LeftCamera);

        emit errorReturn(error);

        m_isFinish.store(true, std::memory_order_release);
        if (m_updateThread.joinable()) {
            m_updateThread.join();
        }
    });

    return;
}

void CalibrateLaucher::stereoCalibrate(const int rowNum, const int colNum,
                                       const float trueDistance,
                                       const bool isFixIntrinsic,
                                       const bool isOuputEpilorLine) {
    if (m_calibrators.size() < 2)
        return;

    m_curCaliType = CaliType::StereoCamera;

    if (m_calibrationThread.joinable()) {
        m_calibrationThread.join();
    }

    m_isFinish.store(false, std::memory_order_release);
    m_updateThread = std::thread(&CalibrateLaucher::timer_timeout_slot, this);

    m_calibrators[0]->setDistance(trueDistance);
    m_calibrators[1]->setDistance(trueDistance);
    m_calibrationThread = std::thread([&, colNum, rowNum, isFixIntrinsic, isOuputEpilorLine] {
        m_calibrators[0]->calibrate(m_calibrators[0]->imgs(), m_info.M1,
                                    m_info.D1, cv::Size(colNum, rowNum),
                                    m_progress);
        m_calibrators[1]->calibrate(m_calibrators[1]->imgs(), m_info.M2,
                                    m_info.D2, cv::Size(colNum, rowNum),
                                    m_progress);

        std::vector<std::vector<cv::Point3f>> worldPoints =
            m_calibrators[0]->worldPoints();
        std::vector<std::vector<cv::Point2f>> imgPointsL =
            m_calibrators[0]->imgPoints();
        std::vector<std::vector<cv::Point2f>> imgPointsR =
            m_calibrators[1]->imgPoints();
        m_info.imgSize = m_calibrators[0]->imgSize();

        if(worldPoints.size() != imgPointsL.size() || worldPoints.size() != imgPointsR.size() ||
        imgPointsL.size() != imgPointsR.size()) {
            emit errorReturn(-9999);

            m_isFinish.store(true, std::memory_order_release);
            if (m_updateThread.joinable()) {
                m_updateThread.join();
            }
        }

        if (isFixIntrinsic)
            m_caliPaker.readIntrinsic();

        double error =
            cv::stereoCalibrate(worldPoints, imgPointsL, imgPointsR, m_info.M1,
                                m_info.D1, m_info.M2, m_info.D2, m_info.imgSize,
                                m_info.R, m_info.T, m_info.E, m_info.F);
        cv::stereoRectify(m_info.M1, m_info.D1, m_info.M2, m_info.D2,
                          m_info.imgSize, m_info.R, m_info.T, m_info.R1,
                          m_info.R2, m_info.P1, m_info.P2, m_info.Q, 0);

        if (isOuputEpilorLine)
            findEpilines(m_calibrators[0]->imgs()[0].rows,
                         m_calibrators[0]->imgs()[0].cols, m_info.F,
                         m_info.epilinesA, m_info.epilinesB, m_info.epilinesC);

        m_caliPaker.writeCaliInfo(CaliType::StereoCamera);

        emit errorReturn(error);

        m_isFinish.store(true, std::memory_order_release);
        if (m_updateThread.joinable()) {
            m_updateThread.join();
        }
    });

    return;
}

QString CalibrateLaucher::displayStereoRectify() {
    cv::Mat rectifyImg;
    rectify(m_calibrators[0]->imgs()[0], m_calibrators[1]->imgs()[0], m_info,
            rectifyImg);
    imwrite("../out/rectify.bmp", rectifyImg);

    return QDir::currentPath() + "/../out/rectify.bmp";
}

void CalibrateLaucher::findEpilines(const int rows, const int cols,
                                    const cv::Mat &fundermental,
                                    cv::Mat &epilinesA, cv::Mat &epilinesB,
                                    cv::Mat &epilinesC) {
    CV_Assert(!fundermental.empty());

    epilinesA = cv::Mat(rows, cols, CV_32FC1, cv::Scalar(0.f));
    epilinesB = cv::Mat(rows, cols, CV_32FC1, cv::Scalar(0.f));
    epilinesC = cv::Mat(rows, cols, CV_32FC1, cv::Scalar(0.f));

    std::vector<cv::Point2f> points;
    std::vector<cv::Vec3f> epilinesVec;
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            cv::Point2f imgPoint(j, i);
            points.emplace_back(imgPoint);
        }
    }

    computeCorrespondEpilines(points, 1, fundermental, epilinesVec);
    for (int i = 0; i < rows; ++i) {
        auto ptrEpilinesA = epilinesA.ptr<float>(i);
        auto ptrEpilinesB = epilinesB.ptr<float>(i);
        auto ptrEpilinesC = epilinesC.ptr<float>(i);
        for (int j = 0; j < cols; ++j) {
            ptrEpilinesA[j] = epilinesVec[cols * i + j][0];
            ptrEpilinesB[j] = epilinesVec[cols * i + j][1];
            ptrEpilinesC[j] = epilinesVec[cols * i + j][2];
        }
    }
}

void CalibrateLaucher::rectify(const cv::Mat &leftImg, const cv::Mat &rightImg,
                               const CaliInfo &info, cv::Mat &rectifyImg) {
    rectifyImg = cv::Mat(leftImg.rows, leftImg.cols * 2, CV_8UC1);
    cv::Mat img_rect_Left =
        rectifyImg(cv::Rect(0, 0, rectifyImg.cols / 2, rectifyImg.rows));
    cv::Mat img_rect_Right = rectifyImg(
        cv::Rect(rectifyImg.cols / 2, 0, rectifyImg.cols / 2, rectifyImg.rows));

    cv::Mat copyImgLeft, copyImgRight;
    leftImg.copyTo(copyImgLeft);
    rightImg.copyTo(copyImgRight);

    cv::Mat map_x_left, map_x_right, map_y_left, map_y_right;
    initUndistortRectifyMap(info.M1, info.D1, info.R1, info.P1, info.imgSize,
                            CV_16SC2, map_x_left, map_y_left);
    initUndistortRectifyMap(info.M2, info.D2, info.R2, info.P2, info.imgSize,
                            CV_16SC2, map_x_right, map_y_right);
    remap(copyImgLeft, img_rect_Left, map_x_left, map_y_left, cv::INTER_LINEAR);
    remap(copyImgRight, img_rect_Right, map_x_right, map_y_right,
          cv::INTER_LINEAR);

    cvtColor(rectifyImg, rectifyImg, cv::COLOR_GRAY2BGR);

    for (int i = 0; i < 50; i++) {
        line(rectifyImg, cv::Point(0, rectifyImg.rows / 50 * i),
             cv::Point(rectifyImg.cols, rectifyImg.rows / 50 * i),
             cv::Scalar(0, 255, 0), 1);
    }
}

void CalibrateLaucher::timer_timeout_slot() {
    float progressStereo = 0.f;
    float progressPre = m_progress;
    while (!m_isFinish.load(std::memory_order_acquire)) {
        if (progressPre != m_progress) {
            progressPre = m_progress;

            emit drawKeyPointsChanged(
                "file:///" +
                QFileInfo("imgWithFeature" +
                          QString::fromStdString(std::to_string(m_progress)) +
                          ".png")
                    .absoluteFilePath());

            if (CaliType::LeftCamera == m_curCaliType) {
                emit progressChanged(m_progress);
            } else {
                progressStereo +=
                    progressStereo < 0.5
                        ? m_progress / 2.f - progressStereo
                        : m_progress / 2.f - (progressStereo - 0.5);
                emit progressChanged(progressStereo);
            }
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(30));
    }
}

void CalibrateLaucher::exit() {
    if (m_calibrationThread.joinable()) {
        m_calibrationThread.join();
    }

    if (m_updateThread.joinable()) {
        m_updateThread.join();
    }
}
