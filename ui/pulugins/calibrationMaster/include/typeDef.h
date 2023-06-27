#ifndef TYPEDEF_H
#define TYPEDEF_H

#include <opencv2/opencv.hpp>

/**
 * @brief 存储有关标定矩阵的信息
 */
class CaliInfo {
  public:
    CaliInfo();
    ~CaliInfo();
    /** \左相机内参矩阵 */
    cv::Mat M1;
    /** \右相机内参矩阵 */
    cv::Mat M2;
    /** \左相机畸变参数矩阵 */
    cv::Mat D1;
    /** \右相机畸变参数矩阵 */
    cv::Mat D2;
    /** \左相机平移矩阵 */
    cv::Mat T1;
    /** \右相机平移矩阵 */
    cv::Mat T2;
    /** \左相机到右相机的旋转矩阵 */
    cv::Mat R1;
    /** \右相机到左相机的旋转矩阵 */
    cv::Mat R2;
    /** \左相机的重投影矩阵 */
    cv::Mat P1;
    /** \右相机的重投影矩阵 */
    cv::Mat P2;
    /** \归一化尺寸 */
    cv::Mat Q;
    /** \左相机与右相机之间的旋转矩阵 */
    cv::Mat R;
    /** \左相机与右相机之间的平移矩阵 */
    cv::Mat T;
    /** \左相机与右相机之间的本质矩阵 */
    cv::Mat E;
    /** \左相机与右相机之间的基本矩阵 */
    cv::Mat F;
    /** \左相机上的点对应在右相机上的极线：系数A */
    cv::Mat epilinesA;
    /** \左相机上的点对应在右相机上的极线：系数B */
    cv::Mat epilinesB;
    /** \左相机上的点对应在右相机上的极线：系数C */
    cv::Mat epilinesC;
    /** \图像大小 **/
    cv::Size imgSize;
};

enum CaliType { LeftCamera = 0, StereoCamera };

#endif // TYPEDEF_H
