pragma Singleton
import QtQuick 2.12
import QtQuick.Controls.Material 2.12

QtObject {
    signal changeTo2DMode;
    signal changeCameraExposureTime(var exposureTime);
    signal startDispaly2d(var channel);
    signal stopDispaly2d(var channel);
    signal connectRobot(var robotName, var robotIp);
    signal disConnect;
    signal save(var index);
    signal sucessImgPath(var path);
    signal discard(var index, var filePath);
    signal getIntrisic();
    signal calibrate();
    signal setTarget(var targetType, var params);
    signal calibrateFinish(var errorList);
    property int exposureTime: 0
}
