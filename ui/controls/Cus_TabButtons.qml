import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Item {
    property string depthIconSource: ""
    property string cloudIconSource: ""
    property color backgroundColor: "#000000"
    property color selectedColor: "#000000"
    property color hoverColor: "#000000"
    property color clickColor: "#000000"
    property color textColor: "#000000"
    property color borderColor: "#000000"
    property bool isDepthTab: false

    property int borderWidth: 2

    signal depthClicked
    signal cloudClicked

    enabled: true

    Material.theme: Material.Dark

    Rectangle {
        anchors.fill: parent
        color: backgroundColor
        border.width: borderWidth
        border.color: borderColor
        radius: 6

        Rectangle {
            id: depthImgRec
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 1
            width: parent.width / 2
            border.color: borderColor
            border.width: isDepthTab ? borderWidth : 0
            color: isDepthTab ? selectedColor : backgroundColor
            radius: 2

            Image {
                id: leftImg
                anchors.left: parent.left
                anchors.leftMargin: 4
                height: parent.height
                width: parent.height
                source: depthIconSource
                fillMode: Qt.KeepAspectRatioByExpanding
            }

            Label {
                anchors.left: leftImg.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 12
                font.bold: true
                text: "深度/纹理图"
                color: textColor
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true

                onClicked: {
                    depthClicked();
                    isDepthTab = true;
                    depthImgRec.color = clickColor;
                    depthImgRec.color = hoverColor;
                    cloudRec.color = backgroundColor;
                    depthImgRec.border.width = borderWidth;
                    cloudRec.border.width = 0;
                }

                onExited: {
                    if(isDepthTab) {
                        depthImgRec.color = selectedColor;
                    }
                    else {
                        depthImgRec.color = backgroundColor;
                    }
                }

                onEntered: {
                    if(!isDepthTab) {
                        depthImgRec.color = hoverColor;;
                    }
                }
            }
        }

        Rectangle {
            id: cloudRec
            anchors.left: depthImgRec.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 1
            border.color: borderColor
            border.width: isDepthTab ? 0 : borderWidth
            color: isDepthTab ? backgroundColor : selectedColor
            radius: 2

            Image {
                id: rightImg
                height: parent.height
                width: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 4
                source: cloudIconSource
                fillMode: Qt.KeepAspectRatioByExpanding
            }

            Label {
                anchors.left: rightImg.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 12
                font.bold: true
                text: "点云"
                color: textColor
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true

                onClicked: {
                    cloudClicked();
                    isDepthTab = false;
                    cloudRec.color = clickColor;
                    cloudRec.color = hoverColor;
                    depthImgRec.color = backgroundColor;
                    depthImgRec.border.width = 0;
                    cloudRec.border.width = borderWidth;
                }

                onExited: {
                    if(isDepthTab) {
                        cloudRec.color = backgroundColor;
                    }
                    else {
                        cloudRec.color = selectedColor;
                    }
                }

                onEntered: {
                    if(isDepthTab) {
                        cloudRec.color = hoverColor;;
                    }
                }
            }
        }
    }
}
