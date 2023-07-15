import QtQuick 2.12

Item {
    id: root
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color textColor: "#000000"
    property color foreColor: "#000000"
    property color clickColor: "#000000"
    property color borderColor: "#000000"
    property color outLineColor: "#000000"
    property color connectColor: "#000000"
    property color disConnectColor: "#000000"
    property bool isDetected: false

    property string jsonSource: ""

    signal cameraPropertyChanged(var propertyName, var val, var propertyType)
    signal connect
    signal disConnect

    function resetConnect() {
        cameraStatus.isConnect = false;
    }

    Rectangle {
        anchors.fill: parent
        color: parent.backgroundColor

        Cus_CameraStatus {
            id: cameraStatus
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            height: 24
            width: 150
            backgroundColor: root.backgroundColor
            hoverColor: root.hoverColor
            clickColor: root.clickColor
            borderColor: root.borderColor
            outLineColor: root.outLineColor
            connectColor: root.connectColor
            disConnectColor: root.disConnectColor
            textColor: root.textColor
            isDetected: root.isDetected
            iconSource: "qrc:/icons/baseline_photo_camera_white_36dp.png"

            onSwitchConnect: {
                connect();
            }

            onSwitchDisConnect: {
                disConnect();
            }
        }

        Cus_CameraPropertyList {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 48
            selectionColor: root.backgroundColor
            hoverColor: root.hoverColor
            textColor: root.textColor
            jsonSource: root.jsonSource
            backgroundColor: root.backgroundColor

            onPropertyListValChanged: function(propertyName, val, propertyType) {
                cameraPropertyChanged(propertyName, val, propertyType);
            }
        }
    }
}
