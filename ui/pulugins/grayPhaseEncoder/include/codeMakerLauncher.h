#ifndef __CODE_MAKE_LAUNCHER_H_
#define __CODE_MAKE_LAUNCHER_H_

#include <QObject>
//#include <QProperty>

#include "codeMaker.h"

class CodeMakerLauncher : public QObject {
    Q_OBJECT
  public:
    CodeMakerLauncher(QObject *parent = nullptr);
    virtual ~CodeMakerLauncher();
    /** \开始编码格雷码 **/
    Q_INVOKABLE void startEncoderGrayCode();
    /** \开始编码相移码 **/
    Q_INVOKABLE void startEncoderPhaseCode();
    /** \离焦图片 **/
    Q_INVOKABLE void blur(const int kSize);
    /** \设置全白编码标志位 **/
    Q_INVOKABLE inline void setWhiteMode(const bool state) { m_isWhiteMode = state; };
    /** \设置位移格雷码标志位 **/
    Q_INVOKABLE inline void setShiftGrayCodeMode(const bool state) {
        m_isShiftGrayCodeMode = state;
    };
    /** \设置四灰度格雷码标志位 **/
    Q_INVOKABLE inline void setFourFloorGrayCodeMode(const bool state) {
        m_isFourFloorGrayCodeMode = state;
    };
    /** \设置二元方波编码标志位 **/
    Q_INVOKABLE inline void setBinaryPhaseMode(const bool state) {
        m_isBinaryPhaseMode = state;
    };
    /** \设置OPWM编码标志位 **/
    Q_INVOKABLE inline void setOPWMMode(const bool state) { m_isOPWMMode = state; };
    /** \设置反向模式标志位 **/
    Q_INVOKABLE inline void setCounterMode(const bool state) { m_isCounterMode = state; };
    /** \设置误差扩散法标志位 **/
    Q_INVOKABLE inline void setPhaseErrorExpandMode(const bool state) {
        m_isPhaseErrorExpandMode = state;
    };
    /** \设置线移模式 **/
    Q_INVOKABLE inline void setShiftLineMode(const bool state) { m_isShiftLineMode = state; };
    /** \设置横向模式标志位 **/
    Q_INVOKABLE inline void setChangeYMode(const bool state) { m_isChangeYMode = state; };
    /** \设置图像长度 **/
    Q_INVOKABLE inline void setWidth(const int width) { m_width = width; };
    /** \设置图像宽度 **/
    Q_INVOKABLE inline void setHeight(const int height) { m_height = height; };
    /** \设置虚拟平面张数 **/
    Q_INVOKABLE inline void setImagePlanes(const int nums) { m_imagePlanes = nums; };
    /** \设置格雷码次数 **/
    Q_INVOKABLE inline void setGrayCodeTimes(const int grayTime) { m_grayCodeTimes = grayTime;};
    /** \设置相移次数 **/
    Q_INVOKABLE inline void setPhaseShiftTimes(const int shiftTime) { m_phaseShiftTimes = shiftTime; };
    /** \设置相移节距 **/
    Q_INVOKABLE inline void setPhasePatchPixels(const int patch) { m_phasePatchPixels = patch; };
    /** \设置一高度模式标志位 **/
    Q_INVOKABLE inline void setOneHeightMode(const bool state) { m_isOneHeightMode = state; };
    /** \设置一位深模式 **/
    Q_INVOKABLE inline void setIsOneBitMode(const bool state) { m_isOneBitMode = state; };
    /** \读取一高度模式标志位 **/
    Q_INVOKABLE inline void setCounterDirectionMode(const bool state) { m_isCounterDirectionMode = state; };
  private:
    grayPhaseEncoder::GrayEncoder *m_grayEncoder;
    grayPhaseEncoder::PhaseEncoder *m_phaseEncoder;
    bool m_isWhiteMode;
    bool m_isShiftGrayCodeMode;
    bool m_isFourFloorGrayCodeMode;
    bool m_isBinaryPhaseMode;
    bool m_isOPWMMode;
    bool m_isCounterMode;
    bool m_isPhaseErrorExpandMode;
    bool m_isChangeYMode;
    bool m_isOneHeightMode;
    bool m_isOneBitMode;
    bool m_isCounterDirectionMode;
    bool m_isShiftLineMode;
    int m_width;
    int m_height;
    int m_grayCodeTimes;
    int m_phaseShiftTimes;
    int m_imagePlanes;
    //除以100
    int m_phasePatchPixels;
    std::vector<cv::Mat> grayCodeImgs;
    std::vector<cv::Mat> phaseCodeImgs;
};

#endif //__CODE_MAKE_LAUNCHER_H_
