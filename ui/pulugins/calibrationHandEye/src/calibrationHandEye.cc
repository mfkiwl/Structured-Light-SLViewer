#include <calibrationHandEye/include/calibrationHandEye.h>

QVariantList CalibrationHandEye::calibrate(
    const std::vector<cv::Mat> &targetToCameraRotation,
    const std::vector<cv::Mat> &targetToCameraTranslation,
    const std::vector<cv::Mat> &gripperToBaseRotation,
    const std::vector<cv::Mat> &gripperToBaseTranslation, cv::Mat &solvedRotation,
    cv::Mat &solvedTranslation, EyePlaceMethod eyePlaceMethod,
    cv::HandEyeCalibrationMethod calibrationMethod, const float scaleFactor) {
    if(EyeInHand == eyePlaceMethod) {
        cv::calibrateHandEye(gripperToBaseRotation, gripperToBaseTranslation, targetToCameraRotation, targetToCameraTranslation, solvedRotation, solvedTranslation, calibrationMethod);

        cv::Mat cameraToGrpperTransform(4, 4, CV_64FC1, cv::Scalar(1));
        cameraToGrpperTransform(cv::Rect(0, 0, 3, 3)) = solvedRotation.clone();
        cameraToGrpperTransform(cv::Rect(3, 0, 1, 3)) = solvedTranslation.clone();
        
        std::vector<cv::Mat> targetToBaseTansforms;
        float sumX = 0, sumY = 0, sumZ = 0;
        for (size_t i = 0; i < targetToCameraRotation.size(); ++i) {
            cv::Mat gripperToBaseTransform(4, 4, CV_64FC1, cv::Scalar(1));
            gripperToBaseTransform(cv::Rect(0, 0, 3, 3)) = gripperToBaseRotation[i].clone();
            gripperToBaseTransform(cv::Rect(3, 0, 1, 3)) = gripperToBaseTranslation[i].clone();
            cv::Mat targetToCameraTransform(4, 4, CV_64FC1, cv::Scalar(1));
            targetToCameraTransform(cv::Rect(0, 0, 3, 3)) = targetToCameraRotation[i].clone();
            targetToCameraTransform(cv::Rect(3, 0, 1, 3)) = targetToCameraTranslation[i].clone();
            cv::Mat transformTargetToBase = gripperToBaseTransform * cameraToGrpperTransform * targetToCameraTransform;
            targetToBaseTansforms.emplace_back(transformTargetToBase);
            sumX += transformTargetToBase.ptr<double>(0)[3] / transformTargetToBase.ptr<double>(3)[3];
            sumY += transformTargetToBase.ptr<double>(1)[3] / transformTargetToBase.ptr<double>(3)[3];
            sumZ += transformTargetToBase.ptr<double>(2)[3] / transformTargetToBase.ptr<double>(3)[3];
        }

        float aX = sumX / targetToCameraRotation.size();
        float aY = sumY / targetToCameraRotation.size();
        float aZ = sumZ / targetToCameraRotation.size();
        QVariantList errorList;
        float rmse = 0;
        for (size_t i = 0; i < targetToCameraRotation.size(); ++i) {
            cv::Mat zeroPoint = cv::Mat::zeros(4, 1, CV_64FC1);
            zeroPoint.ptr<double>(3)[0] = 1;
            cv::Mat locZeroPoint = targetToBaseTansforms[i] * zeroPoint;
            double xBasePoint = locZeroPoint.ptr<double>(0)[0] / locZeroPoint.ptr<double>(3)[0];
            double yBasePoint = locZeroPoint.ptr<double>(1)[0] / locZeroPoint.ptr<double>(3)[0];
            double zBasePoint = locZeroPoint.ptr<double>(2)[0] / locZeroPoint.ptr<double>(3)[0];
            float error = std::sqrt(std::pow(xBasePoint - aX, 2) + std::pow(yBasePoint - aY, 2) + std::pow(zBasePoint - aZ, 2));
            errorList.append(QVariant(error));
            rmse += error * error;
        }

        rmse /= errorList.size();
        errorList.append(rmse);

        return errorList;
    }
    else if(EyeToHand == eyePlaceMethod) {
        std::vector<cv::Mat> gripperToBaseRotationInverse, gripperToBaseTranslationInverse;
        for (size_t i = 0; i < gripperToBaseRotation.size(); ++i) {
            gripperToBaseRotationInverse.emplace_back(gripperToBaseRotation[i].inv());
            gripperToBaseTranslationInverse.emplace_back(gripperToBaseTranslation[i].inv());
        }
        cv::calibrateHandEye(gripperToBaseRotationInverse, gripperToBaseTranslationInverse, targetToCameraRotation, targetToCameraTranslation, solvedRotation, solvedTranslation, calibrationMethod);
    }
}
