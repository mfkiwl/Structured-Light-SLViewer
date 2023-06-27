#include "CalibrationMaster/include/caliPacker.h"

CaliPacker::CaliPacker() : m_bundleInfo(nullptr) {}

CaliPacker::~CaliPacker() {}

void CaliPacker::bundleCaliInfo(CaliInfo &info) { m_bundleInfo = &info; }

void CaliPacker::readIntrinsic() {
    cv::FileStorage readYml("../out/intrinsic.yml", cv::FileStorage::READ);
    readYml["M1"] >> m_bundleInfo->M1;
    readYml["D1"] >> m_bundleInfo->D1;
    readYml["M2"] >> m_bundleInfo->M2;
    readYml["D2"] >> m_bundleInfo->D2;
    readYml.release();
}

void CaliPacker::writeCaliInfo(const CaliType &caliType) {
    if (caliType == LeftCamera) {
        cv::FileStorage caliMatrixOutPut("leftCameraIntrinsic.yml",
                                         cv::FileStorage::WRITE);
        caliMatrixOutPut << "M1" << m_bundleInfo->M1;
        caliMatrixOutPut << "D1" << m_bundleInfo->D1;
        caliMatrixOutPut << "S" << m_bundleInfo->imgSize;
        caliMatrixOutPut.release();
    } else if (caliType == StereoCamera) {
        cv::FileStorage intrinsicMatrixOutPut("../out/intrinsic.yml",
                                              cv::FileStorage::WRITE);
        cv::FileStorage extrinsicMatrixOutPut("../out/extrinsic.yml",
                                              cv::FileStorage::WRITE);
        intrinsicMatrixOutPut << "M1" << m_bundleInfo->M1;
        intrinsicMatrixOutPut << "D1" << m_bundleInfo->D1;
        intrinsicMatrixOutPut << "M2" << m_bundleInfo->M2;
        intrinsicMatrixOutPut << "D2" << m_bundleInfo->D2;
        extrinsicMatrixOutPut << "R1" << m_bundleInfo->R1;
        extrinsicMatrixOutPut << "P1" << m_bundleInfo->P1;
        extrinsicMatrixOutPut << "R2" << m_bundleInfo->R2;
        extrinsicMatrixOutPut << "P2" << m_bundleInfo->P2;
        extrinsicMatrixOutPut << "Q" << m_bundleInfo->Q;
        extrinsicMatrixOutPut << "R" << m_bundleInfo->R;
        extrinsicMatrixOutPut << "T" << m_bundleInfo->T;
        extrinsicMatrixOutPut << "E" << m_bundleInfo->E;
        extrinsicMatrixOutPut << "F" << m_bundleInfo->F;
        cv::Mat size = (cv::Mat_<double>(2, 1) << m_bundleInfo->imgSize.width,
                        m_bundleInfo->imgSize.height);
        extrinsicMatrixOutPut << "S" << size;
        if (!m_bundleInfo->epilinesA.empty()) {
            cv::imwrite("../out/epilinesA.tiff", m_bundleInfo->epilinesA);
            cv::imwrite("../out/epilinesB.tiff", m_bundleInfo->epilinesB);
            cv::imwrite("../out/epilinesC.tiff", m_bundleInfo->epilinesC);
        }
        intrinsicMatrixOutPut.release();
        extrinsicMatrixOutPut.release();
    }
}
