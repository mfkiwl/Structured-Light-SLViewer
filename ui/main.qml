import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material 2.15

import FramelessWindowHelper 1.0
import SLCameraEngine 1.0
import VTKProcessEngine 1.0
import "./controls/Global"
import "./controls"

ApplicationWindow {
    id: mainWindow
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    minimumWidth: 1280
    minimumHeight: 720
    color: Sys.background
    visible: true

    Material.theme: Material.Dark

    FramelessWindowHelper {

    }

    //MenuBar
    menuBar: Cus_MenuBar {
        id: menuBar
        backgroundColor: Sys.background
        hoverColor: Sys.secondary
        textColor: Sys.on_fore
        foreColor: Sys.fore
        width: parent.width
        height: 40

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            cursorShape: Qt.OpenHandCursor
            property point pressPos

            onPressed: function(mouse) {
                pressPos = Qt.point(mouse.x, mouse.y);
            }

            onPositionChanged: function(mouse) {
                mainWindow.x += mouse.x - pressPos.x;
                mainWindow.y += mouse.y - pressPos.y;
            }
        }

        onCloseWindow: {
            displayBody.changeToCloudDisplay();
            mainWindow.close();
        }

        onMinimumWindow: {
            mainWindow.visibility = "Minimized";
        }

        onMaximumWindow: {
            mainWindow.visibility = "Maximized";
        }

        onCameraViewPortPressed: function(x, y) {
            cameraViewPortSetMenu.x = x;
            cameraViewPortSetMenu.y = y;
            cameraViewPortSetMenu.open();
        }
    }

    Menu {
        id: cameraViewPortSetMenu
        MenuItem {
            icon.source: "qrc:/icons/ccViewXneg.png"
            text: "left"

            onTriggered: {
                vtkProcessEngine.setCameraViewPort(-500, 0, 0, -499, 0, 0, 0, -1, 0);
            }
        }

        MenuItem {
            icon.source: "qrc:/icons/ccViewXpos.png"
            text: "right"

            onTriggered: {
                vtkProcessEngine.setCameraViewPort(500, 0, 0, 499, 0, 0, 0, -1, 0);
            }
        }

        MenuItem {
            icon.source: "qrc:/icons/ccViewYneg.png"
            text: "front"

            onTriggered: {
                vtkProcessEngine.setCameraViewPort(0, 0, -500, 0, 0, -499, 0, -1, 0);
            }
        }

        MenuItem {
            icon.source: "qrc:/icons/ccViewYpos.png"
            text: "back"

            onTriggered: {
                vtkProcessEngine.setCameraViewPort(0, 0, 500, 0, 0, 499, 0, -1, 0);
            }
        }

        MenuItem {
            icon.source: "qrc:/icons/ccViewZneg.png"
            text: "up"

            onTriggered: {
                vtkProcessEngine.setCameraViewPort(0, 0, 500, 0, 0, 499, 0, 1, 0);
            }
        }

        MenuItem {
            icon.source: "qrc:/icons/ccViewZpos.png"
            text: "under"

            onTriggered: {
                vtkProcessEngine.setCameraViewPort(0, 500, 0, 0, 499, 0, 0, 0, -1);
            }
        }
    }

    //Tool Bar
    header: Cus_ToolBar {
        id: toolBar
        anchors.top: menuBar.bottom
        anchors.left: menuBar.left
        anchors.right: menuBar.right
        height: 42
        backgroundColor: Sys.background
        hoverColor: Sys.secondary
        textColor: Sys.on_fore
        foreColor: Sys.fore
        clickColor: Sys.on_primary
        selectedColor: Sys.secondary
        borderColor: Sys.fore
        /*
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            verticalOffset: 2
            horizontalOffset: 2
            color: Sys.shadow
        }
        */
        onCapture: {
            slCameraEngine.capture();
        }

        onContinueCapture: {
            slCameraEngine.continueCapture();
        }

        onStopCapture: {
            slCameraEngine.stopCapture();
        }

        onEnableAlignedMode: function(isEnable) {
            slCameraEngine.enableAlignedMode(isEnable);
        }

        onEnableOfflineMode: function(isEnable) {
            slCameraEngine.enableOfflineMode(isEnable);
        }

        onUpdateCameraParams: {
            slCameraEngine.updateCamera();
        }

        onResetCameraParams: {
            slCameraEngine.resetCameraConfig();
        }

        onCloudMode: {
            //TODO@LiuYunhuang:增加点云切换模式
            displayBody.changeToCloudDisplay();
        }

        onImageMode: {
            //TODO@LiuYunhuang:增加图片切换模式
            displayBody.changeToImgDiplay();
        }

        onSavePointCloud: {
            vtkProcessEngine.saveCloud("../out/" + Qt.formatDateTime(new Date(),"yyyy-MM-dd-HH-mm-ss") + ".ply");
        }

        onCutPointCloud: {
            vtkProcessEngine.isEnableArea = !vtkProcessEngine.isEnableArea;
            vtkProcessEngine.enableAreaSelected(vtkProcessEngine.isEnableArea);

            if(!vtkProcessEngine.isEnableArea) {
                statusBar.labelText = "status: idle...";
            }
            else {
                statusBar.labelText = "status: please click first point to start make a select region..."
            }
        }

        onGetPointInfo: {
            vtkProcessEngine.isEnablePointInfoMode = !vtkProcessEngine.isEnablePointInfoMode;
            vtkProcessEngine.enablePointInfo(vtkProcessEngine.isEnablePointInfoMode);

            if(!vtkProcessEngine.isEnableArea) {
                statusBar.labelText = "status: idle..."
            }
            else {
                statusBar.labelText = "status: please click a point to get the info..."
            }
        }

        onFilterPointCloud: {
            toolPageLoader.source = "";
            toolPageLoader.source = "qrc:/controls/Cus_CloudFilterPage.qml";
        }

        onSurfaceRestruction: {
            vtkProcessEngine.surfaceRestruction();
        }

        onColorizeCloud: {
            toolPageLoader.source = "";
            toolPageLoader.source = "qrc:/controls/Cus_ColorizePage.qml";
        }
    }

    ColorDialog {
        id: colorDialog

        onAccepted: {
            vtkProcessEngine.colorizeCloud(colorDialog.currentColor);
            colorDialog.close();
        }
    }

    Loader {
        id: toolPageLoader
    }

    Connections {
        target: toolPageLoader.item

        function onFilterCloudPressed(stdThreshold, meanK) {
            vtkProcessEngine.statisticalOutRemoval(stdThreshold, meanK);
        }

        function onJetDepthColorMap() {
            vtkProcessEngine.jetDepthColorMap();
        }

        function onUniformColorMap() {
            colorDialog.open();
        }

        function onCancelColorMap() {
            vtkProcessEngine.cancelColorizeCloud();
        }
    }

    Cus_DisplayBody {
        id: displayBody
        anchors.fill: parent
        backgroundColor: Qt.lighter(Sys.background, 1.2)
        shaderColor: Sys.shadow
        colorOnBackground: Sys.on_background
        textColor: Sys.on_fore
        foreColor: Sys.fore
        clickColor: Sys.on_tertiary
        borderColor: Sys.shadow
        outLineColor: Sys.tertiary
        connectColor: Sys.connect
        disConnectColor: Sys.disConnect
        hoverColor: Sys.secondary
        primaryColor: Sys.tertiary
        anchors.bottomMargin: 24
        isDetected: slCameraEngine.isDetected
        cameraJsonSource: ""
        softWareJsonSource: ":/../../json/software.json"
        isSelectedMode: vtkProcessEngine.isEnableArea
        focus: true
        Keys.enabled: true

        Keys.onPressed: {
            if(event.key === Qt.Key_Escape) {
                displayBody.cancleSelect();
                canvas.width = -1;
                canvas.height = -1;
                canvas.requestPaint();
            }

            event.accepted = false;
        }

        onOpenCaliTool: {
            pluginLoader.source = "";
            pluginLoader.source = "qrc:/pulugins/calibrationMaster/ui/calibrationMaster.qml";
        }

        onOpenEncodeTool: {
            pluginLoader.source = "";
            pluginLoader.source = "qrc:/pulugins/grayPhaseEncoder/ui/grayPhaseEncoder.qml";
        }

        onChangeCameraPropertyVal: function(propertyName, val, propertyType) {
            console.log(val)
            if(propertyType === "bool") {
                slCameraEngine.setBooleanAttribute(propertyName, val);
            }
            else if(propertyType === "number") {
                slCameraEngine.setNumbericalAttribute(propertyName, val);
            }
        }

        onChangeVtkPropertyVal: function(propertyName, val, propertyType) {
            if(propertyName === "Axes") {
                vtkProcessEngine.enableAxes(val);
            }
            else if(propertyName === "Grid") {
                vtkProcessEngine.enableGrid(val);
            }
            else if(propertyName === "Orientation") {
                vtkProcessEngine.enableOriention(val);
            }
            else if(propertyName === "Color Bar") {
                vtkProcessEngine.enableColorBar(val);
            }
            else if(propertyName === "Mesh") {
                vtkProcessEngine.enableMesh(val);
            }
            else if(propertyName === "Cloud") {
                vtkProcessEngine.enableCloud(val);
            }
        }

        onConnectCamera: {
            if(!slCameraEngine.connect()) {
                messageDialog.text = qsTr("相机连接失败，请检查相机是否存在或被占用。");
                messageDialog.open();
                resetConnectStatus();
            }
        }

        onDisConnectCamera: {
            slCameraEngine.disConnect();
        }

        onDrawSelectRec: {
            canvas.x = displayBody.selectLeftUpX;
            canvas.y = displayBody.selectLeftUpY;
            canvas.width = Math.abs(displayBody.selectRightDownX - displayBody.selectLeftUpX);
            canvas.height = Math.abs(displayBody.selectRightDownY - displayBody.selectLeftUpY);
            canvas.requestPaint();
            statusBar.labelText = "Please select region through click screen...";
        }

        onFinishSelectRec: {
            if(vtkProcessEngine.isEnableArea) {
                canvas.width = -1;
                canvas.height = -1;
                canvas.requestPaint();

                selectRegionMenu.x = displayBody.selectRightDownX;
                selectRegionMenu.y = displayBody.selectRightDownY;
                selectRegionMenu.open();

                statusBar.labelText = "Select region Finished...";
            }
        }
    }

    Menu {
        id: selectRegionMenu

        MenuItem {
            text: "remain inner"
            icon.source: "qrc:/icons/outer.png"

            onTriggered: {
                vtkProcessEngine.clip(true);
            }
        }

        MenuItem {
            text: "remain outer"
            icon.source: "qrc:/icons/outline_crop_square_white_36dp.png"

            onTriggered: {
                vtkProcessEngine.clip(false);
            }
        }

        MenuItem {
            text: "discard"
            icon.source: "qrc:/icons/outline_reply_white_36dp.png"

            onTriggered: {
                vtkProcessEngine.cancelClip();
                selectRegionMenu.close();
            }
        }
    }

    MessageDialog {
        id: messageDialog
        buttons: MessageDialog.Close
    }

    Loader {
        id: pluginLoader
    }

    SLCameraEngine {
        id: slCameraEngine
        objectName: "slCameraEngine"
    }

    VTKProcessEngine {
        id: vtkProcessEngine
        objectName: "vtkProcessEngine"

        property bool isEnableArea: false
        property bool isEnablePointInfoMode: false

        Component.onDestruction: {
            vtkProcessEngine.release();
        }

        onProgressValChanged: {
            statusBar.progressVal = vtkProcessEngine.progressVal;
        }

        onStatusLabelChanged: {
            statusBar.labelText = vtkProcessEngine.statusLabel;
        }
    }

    Canvas{
        id:canvas
        z: 1000
        onPaint: {
            var ctx = getContext("2d");
            ctx.fillStyle = Sys.secondary
            ctx.strokeStyle = Sys.secondary
            ctx.lineWidth = 4
            ctx.lineJoin = "round"
            ctx.fillRect(0, 0, width, height)
            ctx.clearRect(ctx.lineWidth,ctx.lineWidth,width - ctx.lineWidth,height - ctx.lineWidth)
            ctx.strokeRect(0, 0, width, height)
        }
    }

    Cus_StatusBar {
        id: statusBar
        objectName: "statusBar"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: displayBody.bottom
        anchors.bottom: parent.bottom
        backgroundColor: Sys.background
        hoverColor: Sys.secondary
        labelText: "status: idle..."
        progressVal: 0
        /*
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            verticalOffset: -2
            horizontalOffset: 2
            color: Sys.shadow
        }
        */
    }

    Loader {
        id: welconPageLoader
    }

    Connections {
        target: welconPageLoader.item
        function onCameraSelected(cameraJsonPath, cameraPropertyJsonPath, cameraName) {
            slCameraEngine.configCamera(cameraJsonPath, cameraName);
            displayBody.cameraJsonSource = cameraPropertyJsonPath;
        }
    }

    Component.onCompleted: {
        welconPageLoader.source = "";
        welconPageLoader.source = "qrc:/controls/Cus_WelconPage.qml";
    }
}
