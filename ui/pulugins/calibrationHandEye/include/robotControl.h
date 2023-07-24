#ifndef __ROBOT_CONTROL_H__
#define __ROBOT_CONTROL_H__

#include <opencv2/opencv.hpp>

//机器人控制
class RobotControl {
public:
    virtual bool connect(const std::string robot_ip) = 0;
    virtual bool disConnect() = 0;
    virtual bool getCurPose(cv::Mat& translation, cv::Mat& rotation) = 0;
private:
};

#endif //!__ROBOT_CONTROL_H__
