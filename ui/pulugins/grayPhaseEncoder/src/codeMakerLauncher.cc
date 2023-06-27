#include "grayPhaseEncoder/include/codeMakerLauncher.h"

#include <QImage>

#include <strstream>

CodeMakerLauncher::CodeMakerLauncher(QObject *parent)
    : QObject(parent), m_grayEncoder(nullptr), m_phaseEncoder(nullptr)
    , m_isWhiteMode(false), m_isShiftGrayCodeMode(false), m_isFourFloorGrayCodeMode(false)
    , m_isBinaryPhaseMode(false), m_isOPWMMode(false), m_isCounterMode(false)
    , m_isPhaseErrorExpandMode(false), m_isChangeYMode(false), m_isOneHeightMode(false)
    , m_isOneBitMode(false), m_isCounterDirectionMode(false)
    , m_width(1920), m_height(1080), m_grayCodeTimes(6), m_phaseShiftTimes(4)
    , m_imagePlanes(0), m_phasePatchPixels(6000), m_isShiftLineMode(false) { }

CodeMakerLauncher::~CodeMakerLauncher() {
    if(m_grayEncoder) {
        delete m_grayEncoder;
    }

    if(m_phaseEncoder) {
        delete m_phaseEncoder;
    }
}

void CodeMakerLauncher::startEncoderGrayCode()
{
    if (m_isShiftLineMode) {
        const int shiftNum = std::ceil(m_width / std::pow(2, m_grayCodeTimes));
        for (size_t i = 0; i < shiftNum; ++i) {
            std::strstream fileName, fileNameCounter;
            fileName << "../out/phase/blackWhiteImage" << i << ".bmp";
            fileNameCounter << "../out/phase/blackWhiteImageCounter" << i << ".bmp";
            std::string writeFileName, writeFileNameCounter;
            fileName >> writeFileName;
            fileNameCounter >> writeFileNameCounter;
            
            cv::Mat img = grayPhaseEncoder::elencode::createBWShiftCode(m_width, m_height, m_grayCodeTimes, i);
            cv::Mat counterImg = 255 - img;
            cv::imwrite(writeFileName, img);
            cv::imwrite(writeFileNameCounter, counterImg);
        }

        return;
    }

    if (nullptr != m_grayEncoder) {
        delete m_grayEncoder;
    }

    m_grayEncoder = new grayPhaseEncoder::GrayEncoder(cv::Size(m_width, m_height));
    m_grayEncoder->setChangeModeY(m_isChangeYMode);
    m_grayEncoder->setIsOneHeightMode(m_isOneHeightMode);
    m_grayEncoder->setShiftGrayCodeState(m_isShiftGrayCodeMode);
    m_grayEncoder->setCounterFirstBit(m_isCounterMode);
    m_grayEncoder->setFourFloorMode(m_isFourFloorGrayCodeMode);

    grayCodeImgs.clear();
    for (int i = 1; i <= m_grayCodeTimes; ++i)
    {
        cv::Mat grayCodeImage;
        m_grayEncoder->creatGrayImage(i, m_imagePlanes, m_grayCodeTimes).copyTo(grayCodeImage);
        std::strstream fileName;
        fileName << "../out/gray/GrayCodeImage" << i << ".bmp";
        std::string writeFileName;
        fileName >> writeFileName;
        grayCodeImgs.push_back(grayCodeImage);
        if (m_isFourFloorGrayCodeMode) {
            const float threshod = 128;
            grayCodeImgs[i - 1].convertTo(grayCodeImgs[i - 1], CV_32FC1);
            for (int k = 0; k < grayCodeImgs[i - 1].rows; k++) {
                float* ptr_phaseEncodeImage = grayCodeImgs[i - 1].ptr<float>(k);
                for (int m = 0; m < grayCodeImgs[i - 1].cols; m++) {
                    const float inputPixel = ptr_phaseEncodeImage[m];
                    ptr_phaseEncodeImage[m] = (inputPixel < threshod ? 0 : 255);
                    const float error = inputPixel - ptr_phaseEncodeImage[m];
                    if (m + 1 < grayCodeImgs[i - 1].cols) {
                        ptr_phaseEncodeImage[m + 1] += 7.0f / 16.0f * error;
                    }
                    if (k + 1 < grayCodeImgs[i - 1].rows) {
                        float* ptr_NextRow = grayCodeImgs[i - 1].ptr<float>(k + 1);
                        ptr_NextRow[m] += 5.0f / 16.0f * error;
                        if (m - 1 >= 0) {
                            ptr_NextRow[m - 1] += 3.0f / 16.0f * error;
                        }
                        if (m + 1 < grayCodeImgs[i - 1].cols) {
                            ptr_NextRow[m + 1] += 1.0f / 16.0f * error;
                        }
                    }
                }
            }
            grayCodeImgs[i - 1].convertTo(grayCodeImgs[i - 1], CV_8UC1);

        }
        if (m_isOneBitMode) {
            QImage img(grayCodeImgs[i-1].cols, grayCodeImgs[i - 1].rows, QImage::Format_Mono);
            for (int j = 0; j < grayCodeImgs[i - 1].rows; j++) {
                for (int k = 0; k < grayCodeImgs[i - 1].cols; k++) {
                    if (grayCodeImgs[i - 1].at<uchar>(j, k) == 0)
                        img.setPixel(k, j, 0);
                    else
                        img.setPixel(k, j, 1);
                }
            }
            img.save(QString::fromStdString(writeFileName),"bmp",100);
        }
        else {
            cv::imwrite(writeFileName, grayCodeImage);
        }
    }
}

void CodeMakerLauncher::startEncoderPhaseCode()
{
    if (nullptr == m_phaseEncoder) {
        delete m_phaseEncoder;
    }

    if(!m_isOneHeightMode) {
        m_phaseEncoder = new grayPhaseEncoder::PhaseEncoder(cv::Size(m_width, m_height));
    }
    else {
        if(m_isChangeYMode) {
            m_phaseEncoder = new grayPhaseEncoder::PhaseEncoder(cv::Size(1, m_width));
        }
        else {
            m_phaseEncoder = new grayPhaseEncoder::PhaseEncoder(cv::Size(m_width, 1));
        }
    }

    m_phaseEncoder->setBinaryPhaseCode(m_isBinaryPhaseMode);
    m_phaseEncoder->setOPWMCode(m_isOPWMMode);
    m_phaseEncoder->setCounterMode(m_isCounterMode);
    m_phaseEncoder->setWhiteMode(m_isWhiteMode);
    m_phaseEncoder->setPhaseErrorExpandMode(m_isPhaseErrorExpandMode);
    m_phaseEncoder->setChangeModeY(m_isChangeYMode);
    m_phaseEncoder->setCounterDirection(m_isCounterDirectionMode);

    m_phaseEncoder->creatPhaseImage(m_phaseShiftTimes, m_phasePatchPixels / 100.f);
    phaseCodeImgs.clear();
    for (int i = 0; i < m_phaseShiftTimes; i++) {
        std::string fileName = "../out/phase/phaseShiftImage" + std::to_string(i+1) + ".bmp";
        cv::Mat phaseShiftImg = cv::imread(fileName, 0);
        phaseCodeImgs.push_back(phaseShiftImg);
        if (m_isOneBitMode) {
            QImage img(phaseShiftImg.cols, phaseShiftImg.rows, QImage::Format_Mono);
            for (int j = 0; j < phaseShiftImg.rows; j++) {
                for (int k = 0; k < phaseShiftImg.cols; k++) {
                    if (phaseShiftImg.at<uchar>(j, k) == 0)
                        img.setPixel(k, j, 0);
                    else
                        img.setPixel(k, j, 1);
                }
            }
            img.save(QString::fromStdString(fileName), "bmp", 100);
        }
    }
}

void CodeMakerLauncher::blur(const int kSize) {
    cv::Mat img_0_;
    cv::Mat img_1_;
    cv::Mat img_2_;
    phaseCodeImgs[0].copyTo(img_0_);
    phaseCodeImgs[1].copyTo(img_1_);
    phaseCodeImgs[2].copyTo(img_2_);

    double minVal;
    double maxVal;
    cv::minMaxIdx(img_0_, &minVal, &maxVal);
    if (2 > maxVal) {
        img_0_.convertTo(img_0_, CV_8U, 255);
        img_1_.convertTo(img_1_, CV_8U, 255);
        img_2_.convertTo(img_2_, CV_8U, 255);
    }

    cv::GaussianBlur(img_0_, img_0_, cv::Size(kSize, kSize),kSize / 3);
    cv::GaussianBlur(img_1_, img_1_, cv::Size(kSize, kSize), kSize / 3);
    cv::GaussianBlur(img_2_, img_2_, cv::Size(kSize, kSize), kSize / 3);

    std::vector<cv::Mat> idealImgs;
    m_phaseEncoder->createImgeableImg(m_phaseShiftTimes, m_phasePatchPixels / 100.f, idealImgs);

    float errorSum = 0;
    float error = 0;
    const uchar* ptr_img_0_ = img_0_.ptr<uchar>(img_0_.rows / 2);
    const uchar* ptr_img_1_ = img_1_.ptr<uchar>(img_0_.rows / 2);
    const uchar* ptr_img_2_ = img_2_.ptr<uchar>(img_0_.rows / 2);
    const float* ptr_idea_0_ = idealImgs[0].ptr<float>(img_0_.rows / 2);
    const float* ptr_idea_1_ = idealImgs[1].ptr<float>(img_0_.rows / 2);
    const float* ptr_idea_2_ = idealImgs[2].ptr<float>(img_0_.rows / 2);
    QList<QPointF> pointList;
    std::vector<float> wrapPhase;
    float minError = FLT_MAX;
    float maxError = -FLT_MAX;
    for (int j = 2 * m_phasePatchPixels / 100; j < 3 * m_phasePatchPixels / 100; j++) {
        float wrapPhase_dethering = atan2f(std::sqrt(3) * (ptr_img_0_[j] - ptr_img_2_[j]), 2 * ptr_img_1_[j] - ptr_img_0_[j] - ptr_img_2_[j]);
        float wrapPhase_idea = atan2f(std::sqrt(3) * (ptr_idea_0_[j] - ptr_idea_2_[j]), 2 * ptr_idea_1_[j] - ptr_idea_0_[j] - ptr_idea_2_[j]);
        float absDifference = wrapPhase_dethering - wrapPhase_idea;
        if (std::abs(absDifference) < 6.3 && std::abs(absDifference) > 6.2)
            absDifference = 0.005;
        error = std::pow(absDifference, 2);
        errorSum += error;
        pointList.push_back(QPointF(wrapPhase_idea, absDifference));
        wrapPhase.push_back(wrapPhase_idea);
        if (absDifference < minError)
            minError = absDifference;
        if (absDifference > maxError)
            maxError = absDifference;
    }
    std::sort(wrapPhase.begin(), wrapPhase.end());
    QList<QPointF> pointListSort;
    for (int i = 0; i < wrapPhase.size(); i++) {
        for (int j = 0; j < pointList.size(); j++) {
            if (pointList[j].x() == wrapPhase[i]) {
                pointListSort.push_back(pointList[j]);
                break;
            }
        }
    }
    /*
    if (chart) {
        delete chart;
        chart = nullptr;
    }
    if (chatShow) {
        delete chatShow;
        chatShow = nullptr;
    }
    chatShow = new chartShow(this);
    chart = new Chart(this, QString::fromUtf8("相位误差图"));
    chart->setAxis(QString::fromUtf8("相位 rad"), -CV_PI, CV_PI, 10, QString::fromUtf8("相位误差 rad"), 2 * minError, 2 * maxError, 20);
    chart->buildChart(pointListSort);
    QHBoxLayout* phLayout = new QHBoxLayout(chatShow);
    phLayout->addWidget(chart);
    chatShow->show();
    float averageError = std::sqrt(errorSum / (ui.patchDistance->value()));
    ui.phase_messageBox->append(QString::fromUtf8("当前离焦度下相位误差为：") + QString::fromStdString(std::to_string(averageError)));
    */
}
