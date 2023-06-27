#ifndef CALIBRATELAUCHER_H
#define CALIBRATELAUCHER_H

#include <filesystem>
#include <thread>

#include <QDir>
#include <QUrl>
#include <QObject>
#include <QString>
#include <QFileInfo>
#include <QVector4D>

#include "caliPacker.h"
#include "chessBoardCalibrator.h"
#include "circleGridCalibrator.h"
#include "concentricRingCalibrator.h"
#include "typeDef.h"

class CalibrateLaucher : public QObject {
    Q_OBJECT
    Q_PROPERTY(float progress READ progress NOTIFY progressChanged)
  public:
    enum BoardType { chess = 0, circleGrid, concentricCircle };
    explicit CalibrateLaucher(QObject *parent = nullptr);
    ~CalibrateLaucher();
    Q_INVOKABLE void addCalibrator(const QList<QString> &imgPaths,
                                   const BoardType &boradType);
    Q_INVOKABLE void clearCalibrator();
    Q_INVOKABLE void setRingRadius(const QVector4D radius);
    Q_INVOKABLE void calibrate(const int rowNum, const int colNum,
                                 const float trueDistance);
    Q_INVOKABLE void stereoCalibrate(const int rowNum, const int colNum,
                                       const float trueDistance,
                                       const bool isFixIntrinsic,
                                       const bool isOuputEpilorLine);
    Q_INVOKABLE QString displayStereoRectify();
    Q_INVOKABLE void exit();
    float progress() { return m_progress; }
  signals:
    void progressChanged(float progress);
    void drawKeyPointsChanged(const QString path);
    void errorReturn(const double error);
  private:
    void findEpilines(const int rows, const int cols,
                      const cv::Mat &fundermental, cv::Mat &epilinesA,
                      cv::Mat &epilinesB, cv::Mat &epilinesC);
    void rectify(const cv::Mat &leftImg, const cv::Mat &rightImg,
                 const CaliInfo &info, cv::Mat &rectifyImg);
    std::vector<Calibrator *> m_calibrators;
    CaliInfo m_info;
    CaliPacker m_caliPaker;
    float m_progress;
    int m_imgProcessIndex;
    std::atomic_bool m_isFinish;
    std::thread m_updateThread;
    std::thread m_calibrationThread;
    CaliType m_curCaliType;
  public slots:
    void timer_timeout_slot();
};

#endif // CALIBRATELAUCHER_H
