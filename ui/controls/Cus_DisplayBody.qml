import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material 2.15

import VTKRenderWindow 9.2
import VTKRenderItem 9.2
import VTKInteractiveWidget 9.2

Item {
    id:root
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color colorOnBackground: "#000000"
    property color textColor: "#000000"
    property color foreColor: "#000000"
    property color shaderColor: "#000000"
    property color clickColor: "#000000"
    property color borderColor: "#000000"
    property color outLineColor: "#000000"
    property color connectColor: "#000000"
    property color disConnectColor: "#000000"
    property color primaryColor: "#000000"
    property bool isDetected: false

    property string cameraJsonSource: ""
    property string softWareJsonSource: ""

    property int selectLeftUpX: -1
    property int selectLeftUpY: -1
    property int selectRightDownX: -1
    property int selectRightDownY: -1
    property bool isSelectedMode: false

    signal openCaliTool
    signal openEncodeTool
    signal changeCameraPropertyVal(var propertyName, var val, var propertyType)
    signal changeVtkPropertyVal(var propertyName, var val)

    signal connectCamera
    signal disConnectCamera

    signal drawSelectRec
    signal finishSelectRec

    function cancleSelect() {
        selectedMouseArea.hasPressed = false;
    }

    Material.theme: Material.Dark

    function changeToImgDiplay() {
        displayBodyView.replace(imgDisplayItem);
    }

    function changeToCloudDisplay() {
        displayBodyView.replace(vtkRenderWindow);
    }

    function resetConnectStatus() {
        cameraHelper.resetConnect();
    }

    Cus_CameraPropertyHelper {
        id: cameraHelper
        width: root.width * 1 / 5
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        backgroundColor: root.backgroundColor
        hoverColor: root.hoverColor
        clickColor: root.clickColor
        borderColor: root.borderColor
        outLineColor: root.outLineColor
        connectColor: root.connectColor
        disConnectColor: root.disConnectColor
        textColor: root.textColor
        jsonSource: root.cameraJsonSource
        isDetected: root.isDetected
        /*
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            verticalOffset: 0
            horizontalOffset: -2
            color: shaderColor
        }
        */
        onCameraPropertyChanged: function(propertyName, val, propertyType) {
            changeCameraPropertyVal(propertyName, val, propertyType);
        }

        onConnect: {
            connectCamera();
        }

        onDisConnect: {
            disConnectCamera();
        }
    }

    StackView {
        id: displayBodyView
        anchors.left: parent.left
        anchors.right: cameraHelper.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true

        Component.onCompleted: {
            displayBodyView.push(vtkRenderWindow);
        }

        Component.onDestruction: {
            displayBodyView.pop();
        }
    }

    VTKRenderWindow {
        id: vtkRenderWindow

        VTKRenderItem {
            objectName: "renderItem"
            renderWindow: vtkRenderWindow
            anchors.fill: parent
            focus: true

            MouseArea {
                id: selectedMouseArea
                anchors.fill: parent
                propagateComposedEvents: true
                hoverEnabled: true
                focus: true
                acceptedButtons: Qt.AllButtons

                property bool hasPressed: false

                onPressed: (mouse)=> {
                    if(mouse.button === Qt.LeftButton) {
                        if(root.isSelectedMode) {
                            root.selectLeftUpX = mouse.x;
                            root.selectLeftUpY = mouse.y;
                            selectedMouseArea.hasPressed = true;
                        }
                    }

                    if(mouse.button === Qt.RightButton) {
                        selectedMouseArea.hasPressed = false;
                        finishSelectRec();
                    }

                    mouse.accepted = false;
                }

                onPositionChanged: (mouse)=> {
                    if(root.isSelectedMode && selectedMouseArea.hasPressed) {
                        root.selectRightDownX = mouse.x;
                        root.selectRightDownY = mouse.y;
                        drawSelectRec();
                    }

                    mouse.accepted = false;
                }
            }
        }

        Rectangle {
            id: vtkRenderWindowProperty

            anchors.left: vtkRenderWindow.left
            anchors.top: vtkRenderWindow.top
            anchors.margins: 12
            width: 250
            height: vtkRenderWindow.height * 1 / 2
            color: root.foreColor
            radius: 12
            opacity: 0

            PropertyAnimation on opacity {
                id: recOpacityChanged
                from: 1
                to: 0
                duration: 3000
            }

            MouseArea {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 50
                propagateComposedEvents: true
                hoverEnabled: true

                onEntered: {
                    vtkRenderWindowProperty.opacity = 1;
                }

                onExited: {
                    recOpacityChanged.start();
                }

                Rectangle {
                    id: header
                    anchors.fill: parent
                    radius: vtkRenderWindowProperty.radius
                    color: root.foreColor

                    Text {
                        anchors.fill: parent
                        text: "Display Element"
                        color: root.textColor
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: parent.radius
                        color: parent.color
                    }
                }
            }

            Cus_JSONPropList {
                id: displayElementList
                anchors.fill: parent
                anchors.margins: 6
                anchors.topMargin: 50
                jsonSource: root.softWareJsonSource
                qureyString: "$.vtkDisplay[*]"
                textColor: root.textColor
                backgroundColor: root.foreColor
                hoverColor: root.hoverColor

                onPropertyChanged: function(propertyName, val, propertyType) {
                    changeVtkPropertyVal(propertyName, val);
                }
            }
        }
    }

    Rectangle {
        id: imgDisplayItem
        color: root.backgroundColor

        RowLayout {
            anchors.fill: parent

            Cus_LabelImage {
                id: depthImage
                itemObjectName: "depthItem"
                Layout.fillWidth: true
                Layout.fillHeight: true
                labelText: qsTr("深度图")
            }

            Cus_LabelImage {
                id: textureImage
                itemObjectName: "textureItem"
                Layout.fillWidth: true
                Layout.fillHeight: true
                labelText: qsTr("纹理图")
            }
        }
    }


    Cus_PluginBar {
        anchors.right: displayBodyView.right
        anchors.top: displayBodyView.top
        anchors.rightMargin: 12
        anchors.topMargin: 12
        width: 36
        height: displayBodyView.height * 1 / 3
        backgroundColor: root.backgroundColor
        hoverColor: root.hoverColor
        clickColor: root.clickColor
        borderColor: root.borderColor
        foreColor: root.primaryColor
        textColor: root.textColor

        onOpenCalibrationTool: {
            openCaliTool();
        }

        onOpenGrayPhaseTool: {
            openEncodeTool();
        }
    }
}
