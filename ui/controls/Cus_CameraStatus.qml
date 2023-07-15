import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    property string iconSource: ""
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color clickColor: "#000000"
    property color borderColor: "#000000"
    property color outLineColor: "#000000"
    property color connectColor: "#000000"
    property color disConnectColor: "#000000"
    property color textColor: "#000000"

    property bool isConnect: false
    property bool isDetected: false

    signal switchConnect
    signal switchDisConnect

    Rectangle {
        anchors.fill: parent
        color: backgroundColor
        border.width: 2
        border.color: borderColor

        Rectangle {
            id: cameraStateRec
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width / 2
            color: backgroundColor

            Image {
                id: iconImg
                source: iconSource
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 2
                width: height
                scale: Qt.KeepAspectRatioByExpanding
            }

            Rectangle {
                anchors.left: iconImg.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.margins: 2
                anchors.leftMargin: 12
                width: height
                radius: height / 2
                color: outLineColor

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: height * 2 / 3
                    color: root.isDetected ? connectColor : disConnectColor
                }
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: cameraStateRec.right
            color: backgroundColor

            Cus_Switch {
                id: switcher
                anchors.fill: parent
                isConnect: root.isConnect

                onPositionChanged: {
                    //TODO(@Liu Yunhuang):加入相机连接关闭
                    if(position === 1) {
                        root.isConnect = true;
                        switchConnect();
                    }
                    else {
                        root.isConnect = false;
                        switchDisConnect();
                    }
                }
            }
        }
    }
}
