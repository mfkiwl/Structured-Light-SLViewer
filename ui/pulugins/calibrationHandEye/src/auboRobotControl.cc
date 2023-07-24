#include "calibrationHandEye/include/auboRobotControl.h"

bool AuboRobotControl::connect(const std::string robot_ip) {
    bool ret = robotService.robotServiceLogin(robot_ip.c_str(), 8899, "aubo", "123456");
    if(aubo_robot_namespace::InterfaceCallSuccCode != ret) {
        printf("aubo robot connect service failure!\n");
        return false;
    }

    bool isRealRobotExist = false;
    ret = robotService.robotServiceGetIsRealRobotExist(isRealRobotExist);
    if(aubo_robot_namespace::InterfaceCallSuccCode == ret) {
        if(!isRealRobotExist) {
            printf("real robot dosn't exist!\n");
            return false;
        }
    }

    aubo_robot_namespace::ROBOT_SERVICE_STATE result;
    //Tool dynamics parameter
    aubo_robot_namespace::ToolDynamicsParam toolDynamicsParam;
    memset(&toolDynamicsParam, 0, sizeof(toolDynamicsParam));
    ret = robotService.rootServiceRobotStartup(toolDynamicsParam,
               6        /*Collision level*/,
               true     /*Whether to allow reading poses defaults to true*/,
               true,    /*Leave the default to true */
               1000,    /*Leave the default to 1000 */
               result); /*Robot arm initialization*/

    if(ret == aubo_robot_namespace::InterfaceCallSuccCode) {
        printf("Robot arm initialization succeeded.\n");
    }
    else {
        printf("Robot arm initialization failed.\n");
    }

    robotService.robotServiceInitGlobalMoveProfile();

    return true;
}

bool AuboRobotControl::disConnect() {
    robotService.robotServiceRobotShutdown();
    robotService.robotServiceLogout();

    return true;
}

bool AuboRobotControl::getCurPose(cv::Mat& translation, cv::Mat& rotation) {
    aubo_robot_namespace::JointParam param;
    robotService.robotServiceGetJointAngleInfo(param);
    aubo_robot_namespace::wayPoint_S wayPoints;
    robotService.robotServiceRobotFk(param.jointPos, 6, wayPoints);

    std::cout << param.jointPos[0] << "," << param.jointPos[1] << "," << param.jointPos[2] << "," << param.jointPos[3] << "," << param.jointPos[4] << "," << param.jointPos[5] << std::endl;
    std::vector<aubo_robot_namespace::wayPoint_S> ikWayPoint;
    robotService.robotServiceRobotIk(wayPoints.cartPos.position, wayPoints.orientation, ikWayPoint);
    for (size_t i = 0; i < ikWayPoint.size(); ++i) {
        std::cout << ikWayPoint[i].jointpos[0] << "," << ikWayPoint[i].jointpos[1] << "," << ikWayPoint[i].jointpos[2] << "," << ikWayPoint[i].jointpos[3] << "," << ikWayPoint[i].jointpos[4] << "," << ikWayPoint[i].jointpos[5] << std::endl;
    }

    translation = cv::Mat(3, 1, CV_64FC1, cv::Scalar(0));
    translation.ptr<double>(0)[0] = wayPoints.cartPos.position.x;
    translation.ptr<double>(1)[0] = wayPoints.cartPos.position.y;
    translation.ptr<double>(2)[0] = wayPoints.cartPos.position.z;

    rotation = cv::Mat(3, 3, CV_64FC1, cv::Scalar(0));
    double w = wayPoints.orientation.w;
    double x = wayPoints.orientation.x;
    double y = wayPoints.orientation.y;
    double z = wayPoints.orientation.z;
    rotation = (cv::Mat_<double>(3, 3) << 1-2*y*y-2*z*z, 2*x*y-2*w*z, 2*x*z+2*w*y,
                                          2*x*y+2*w*z, 1-2*x*x-2*z*z, 2*y*z-2*w*x,
                                          2*x*z-2*w*y, 2*y*z+2*w*x, 1-2*x*x-2*y*y);

    return true;
}
