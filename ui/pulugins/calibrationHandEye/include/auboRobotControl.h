#ifndef __AUBO_ROBOT_CONTROL_H__
#define __AUBO_ROBOT_CONTROL_H__

#include <opencv2/opencv.hpp>

#include "robotControl.h"
#include "../thirdParty/aubo/include/serviceinterface.h"
#include "../thirdParty/aubo/include/robot_state.h"
#include "../thirdParty/aubo/include/robotiomatetype.h"
#include "../thirdParty/aubo/include/auboroboterror.h"
#include "../thirdParty/aubo/include/auborobotevent.h"

class AuboRobotControl : public RobotControl {
public:
    bool connect(const std::string robot_ip) override;
    bool disConnect() override;
    bool getCurPose(cv::Mat& translation, cv::Mat& rotation) override;
private:
    ServiceInterface robotService;
};

#endif //!__AUBO_ROBOT_CONTROL_H__
