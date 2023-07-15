import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.12
//import QtQuick.Timeline 1.0
import QtQuick.Dialogs 1.2
//import QtCore
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.12

import CameraModel 1.0
import PaintItem 1.0
import CalibrateLaucher 1.0
import FramelessWindowHelper 1.0

ApplicationWindow{
    id:mainWindow
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint
    minimumWidth: 720
    minimumHeight: 480
    width: 1080
    height: 640
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    //minimumWidth: 640
    //minimumHeight: 480
    visible: true

    Material.theme: Material.Dark
    
    FramelessWindowHelper {

    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: Material.background

        border.color: Material.dropShadowColor

        Rectangle {
            id: rectangle1
            height: 45
            color: Material.background
            border.color: Material.dropShadowColor
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.OpenHandCursor
            property point pressPos
            onPressed: pressPos = Qt.point(mouse.x, mouse.y)
            onPositionChanged: {
                mainWindow.x += mouse.x - pressPos.x
                mainWindow.y += mouse.y - pressPos.y
            }
        }

            Rectangle {
                id: rectangle2
                width: 45
                color: Material.background
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.topMargin: 8
                anchors.leftMargin: 8

                Image {
                    id: image
                    anchors.fill: parent
                    source: "icon/application.ico"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                id: rectangle3
                width: 500
                color: Material.background
                anchors.left: rectangle2.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8
                anchors.bottomMargin: 0
                anchors.topMargin: 0

                Text {
                    id: text1
                    width: 150
                    opacity: 1
                    color: Material.textSelectionColor
                    text: qsTr("Calibrate Tool")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 35
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1
                    styleColor: Material.dropShadowColor
                    style: Text.Raised
                    font.capitalization: Font.MixedCase
                    fontSizeMode: Text.Fit
                    textFormat: Text.PlainText
                    font.family: "Verdana"
                    font.styleName: "Bold Italic"
                }

                Text {
                    id: text3
                    opacity: 1
                    text: qsTr("by @Liu Yunhuang")
                    anchors.left: text1.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 0
                    anchors.leftMargin: 8
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    color: Material.primary
                }
            }

            Rectangle {
                id: rectangle5
                y: 152
                height: 1
                color: Material.dropShadowColor
                border.color: Material.dropShadowColor
                border.width: 0
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
            }

            Rectangle {
                id: rectangle7
                width: 120
                color: Material.dropShadowColor
                radius: 20
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.topMargin: 8
                anchors.rightMargin: 16

                Text {
                    id: text2
                    text: qsTr("Exit")
                    anchors.fill: parent
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 0
                    font.weight: Font.DemiBold
                    color: Material.primary
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    focus: true

                    onEntered: {
                        rectangle7.color = Material.highlightedButtonColor;
                    }

                    onPressed: {
                        rectangle7.color = Material.buttonColor;

                        calibrateLaucher.exit();
                        mainWindow.close();
                    }

                    onReleased: {
                        rectangle7.color = Material.highlightedButtonColor;
                    }

                    onExited: {
                        rectangle7.color = Material.dropShadowColor;
                    }

                }
            }

            Rectangle {
                id: rectangle8
                x: 2160
                width: 120
                color: Material.dropShadowColor
                radius: 20
                anchors.right: rectangle7.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                anchors.rightMargin: 8
                Text {
                    id: text4
                    text: qsTr("Choose Folder")
                    anchors.fill: parent
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.weight: Font.DemiBold
                    color: Material.primary
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    focus: true

                    onEntered: {
                        rectangle8.color = Material.highlightedButtonColor;
                    }

                    onPressed: {
                        rectangle8.color = Material.buttonColor;
                        folderDialog.open();
                    }

                    onReleased: {
                        rectangle8.color = Material.highlightedButtonColor;
                    }

                    onExited: {
                        rectangle8.color = Material.dropShadowColor;
                    }

                    FolderDialog {
                        id:folderDialog

                        property bool isLeftDir: true

                        currentFolder:StandardPaths.standardLocations(StandardPaths.DesktopLocation)[0]
                        title: "请选择左相机拍摄图片文件夹"

                        onAccepted: {
                            currentFolder = folder;

                            if(!folderDialog.isLeftDir) {
                                rightListModel.recurseImg(currentFolder);
                                //rightImgListView.update();
                                title = "请选择左相机拍摄图片文件夹";
                            }
                            else {
                                leftListModel.recurseImg(currentFolder);
                                //leftImgListView.update();
                                title = "请选择右相机拍摄图片文件夹";
                                folderDialog.open();
                            }

                            folderDialog.isLeftDir = !folderDialog.isLeftDir;
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rectangle6
            color: Material.background
            border.color: Material.dropShadowColor
            anchors.left: rectangle4.right
            anchors.right: parent.right
            anchors.top: rectangle1.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: -1
            anchors.bottomMargin: 0
            anchors.topMargin: -1
            clip: true

            Image {
                id:displayImg
                z: 1
                x: parent.width / 2 - width / 2
                y: parent.height / 2 - height / 2
                width: parent.width - 40
                height: parent.height - 40
                //anchors.fill: parent
                //anchors.margins: 20

                property string displayImgURL: "icon/img.png"

                source: displayImgURL
                fillMode: Image.PreserveAspectFit
                clip: true
                mipmap: false
                cache:false
                antialiasing: true

                MouseArea {
                    cursorShape: Qt.OpenHandCursor
                    anchors.fill: displayImg
                    drag.target: displayImg
                    drag.axis: Drag.XAndYAxis

                    onWheel: (wheel)=> {
                        var delta = wheel.angleDelta.y / 120;
                        if(delta > 0)
                            displayImg.scale /= 0.9;
                        else
                            displayImg.scale *= 0.9;
                    }
                }
            }

            DropShadow {
                id: shadow
                z: -1
                anchors.fill: displayImg
                horizontalOffset: 5
                verticalOffset: 5
                radius: 8.0
                color: Material.dropShadowColor
                source: displayImg
                visible: false
            }

            Rectangle {
                id: buttonsImgOperate
                z: 2
                width: 180
                height: 50
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 30
                anchors.bottomMargin: 30
                color: Qt.lighter(Material.background, 1.3);
                radius: 20

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: false
                    verticalOffset: 2
                    horizontalOffset: 2
                    color: Material.dropShadowColor
                }

                MouseArea {
                    anchors.fill: parent
                    focus: true
                    hoverEnabled: true

                    onEntered: parent.opacity  = 0.5
                    onExited: parent.opacity = 1.0
                }

                Rectangle {
                    id:expandImgRec
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width/3
                    radius: parent.radius
                    color: Qt.lighter(Material.background, 1.3);

                    Image {
                        anchors.fill: parent
                        anchors.margins: 16
                        source: "icon/plus.png"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            focus: true

                            onEntered: {
                                expandImgRec.color = Material.highlightedButtonColor;
                            }

                            onPressed: {
                                expandImgRec.color = Material.buttonColor;
                                displayImg.scale /= 0.9;
                            }

                            onReleased: {
                                expandImgRec.color = Material.highlightedButtonColor;
                            }

                            onExited: {
                                expandImgRec.color = Qt.lighter(Material.background, 1.3);
                            }

                        }
                    }
                }

                Rectangle {
                    id:resetImgRec
                    anchors.left: expandImgRec.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width/3
                    radius: parent.radius
                    color: Qt.lighter(Material.background, 1.3);

                    Image {
                        anchors.fill: parent
                        anchors.margins: 16
                        source: "icon/origin.png"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            focus: true

                            onEntered: {
                                resetImgRec.color = Material.highlightedButtonColor;
                            }

                            onPressed: {
                                resetImgRec.color = Material.buttonColor;
                                displayImg.scale = 1.0;
                                displayImg.x = rectangle6.width / 2 - displayImg.width / 2
                                displayImg.y = rectangle6.height / 2 - displayImg.height / 2
                            }

                            onReleased: {
                                resetImgRec.color = Material.highlightedButtonColor;
                            }

                            onExited: {
                                resetImgRec.color = Qt.lighter(Material.background, 1.3);
                            }

                        }
                    }
                }

                Rectangle {
                    id:miniMizeImgRec
                    anchors.left: resetImgRec.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width/3
                    radius: parent.radius
                    color: Qt.lighter(Material.background, 1.3);

                    Image {
                        anchors.fill: parent
                        anchors.margins: 16
                        source: "icon/decrease.png"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            focus: true

                            onEntered: {
                                miniMizeImgRec.color = Material.highlightedButtonColor;
                            }

                            onPressed: {
                                miniMizeImgRec.color = Material.buttonColor;
                                displayImg.scale *= 0.9;
                            }

                            onReleased: {
                                miniMizeImgRec.color = Material.highlightedButtonColor;
                            }

                            onExited: {
                                miniMizeImgRec.color = Qt.lighter(Material.background, 1.3);
                            }

                        }
                    }
                }
            }
        }

        Rectangle {
            id: rectangle4
            width: 300
            color: Material.background
            border.color: Material.dropShadowColor
            anchors.left: parent.left
            anchors.top: rectangle1.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: -1

            SwipeView {
                id: swipeView
                anchors.fill: parent
                anchors.rightMargin: 8
                anchors.leftMargin: 8
                anchors.bottomMargin: 8
                anchors.topMargin: 8

                currentIndex: pageIndicator.currentIndex
                interactive: true
                clip: true
                orientation: Qt.Horizontal
                state: "normal"

                Rectangle {
                    id: rectangle9
                    color: Material.background
                    border.width: 0

                    Rectangle {
                        id: leftGroupHeader
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.right: parent.right
                        height: parent.height / 12
                        color: Material.background

                        Text {
                            font.pixelSize: 16
                            verticalAlignment: Text.AlignVCenter
                            font.weight: Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 8
                            width: 100
                            text: "Left"
                            color: Material.primary
                        }

                        Rectangle {
                            id:imgBackground
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.height - 32
                            anchors.margins: 16
                            color: Material.background

                            Image {
                                anchors.fill: parent
                                source: "icon/expand.png"
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter

                                MouseArea {
                                    anchors.fill: parent
                                    focus: true
                                    hoverEnabled: true
                                    onPressed: {
                                        leftImgListView.state === "expand" ? leftImgListView.state = "normal" : leftImgListView.state = "expand";
                                        parent.source = leftImgListView.state === "expand" ? "icon/nonExpand.png" : "icon/expand.png";
                                    }
                                    onEntered: {
                                        imgBackground.color = Material.highlightedButtonColor;
                                    }

                                    onReleased: {
                                        imgBackground.color = Material.highlightedButtonColor;
                                    }

                                    onExited: {
                                        imgBackground.color = Material.background;
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            height: 1
                            color: Material.dropShadowColor
                        }
                    }

                    Rectangle {
                        id: rightGroupHeader
                        anchors.left: parent.left
                        anchors.top: leftImgListView.bottom
                        anchors.right: parent.right
                        height: parent.height / 12
                        color: Material.background

                        Text {
                            font.pixelSize: 16
                            verticalAlignment: Text.AlignVCenter
                            font.weight: Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 8
                            width: 100
                            text: "Right"
                            color: Material.primary
                        }

                        Rectangle {
                            id:rightImgBackground
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.height - 32
                            anchors.margins: 16
                            color: Material.background

                            Image {
                                anchors.fill: parent
                                source: "icon/expand.png"
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter

                                MouseArea {
                                    anchors.fill: parent
                                    focus: true
                                    hoverEnabled: true
                                    onPressed: {
                                        rightImgListView.state === "expand" ? rightImgListView.state = "normal" : rightImgListView.state = "expand";
                                        parent.source = rightImgListView.state === "expand" ? "icon/nonExpand.png" : "icon/expand.png";
                                    }
                                    onEntered: {
                                        rightImgBackground.color = Material.highlightedButtonColor;
                                    }

                                    onReleased: {
                                        rightImgBackground.color = Material.highlightedButtonColor;;
                                    }

                                    onExited: {
                                        rightImgBackground.color = Material.background;;
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            height: 1
                            color: Material.dropShadowColor
                        }
                    }

                    ListView {
                        id:leftImgListView
                        anchors.left: parent.left
                        anchors.top: leftGroupHeader.bottom
                        anchors.right: parent.right
                        clip: true
                        height:0
                        opacity: 0
                        cacheBuffer: 10000

                        model: leftListModel

                        CameraModel {
                            id:leftListModel
                        }

                        delegate: Rectangle {
                            id: leftGroupRec
                            border.width: 0
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            height: leftImgListView.height / 12
                            color: Material.background

                            Rectangle {
                                id:leftExpandImgUrlName
                                width: parent.width / 2
                                height: parent.height
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                color: parent.color

                                Text {
                                    id: filePathText
                                    anchors.fill: parent
                                    anchors.centerIn: parent.Center
                                    clip: true
                                    elide: Text.ElideMiddle
                                    text: qsTr(FileName)
                                    verticalAlignment: Qt.AlignVCenter
                                    color: Material.primary
                                }
                            }

                            Rectangle {
                                height: parent.height
                                width: height
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                color: parent.color

                                Image {
                                    anchors.fill: parent
                                    source: "icon/img.png"
                                    verticalAlignment: Qt.AlignVCenter
                                    horizontalAlignment: Qt.AlignHCenter
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Menu {
                                id:deleteMenu

                                MenuItem {
                                    text: "delete"
                                    icon.source: "icon/delete.png"

                                    onTriggered: {
                                        leftListModel.erase(filePathText.text);
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                focus: true
                                acceptedButtons: Qt.AllButtons

                                onEntered: parent.color = Material.accent
                                onExited: parent.color = Material.background
                                onDoubleClicked: {
                                    displayImg.displayImgURL = "file:///" + FileName;
                                    shadow.visible = true;
                                }
                                onClicked: (mouse)=> {
                                    if(mouse.button === Qt.RightButton) {
                                        deleteMenu.open();
                                    }
                                }
                            }
                        }

                        states : [
                            State {
                                name: "expand"
                                PropertyChanges {
                                    target: leftImgListView
                                    height: (rectangle9.height - leftGroupHeader.height * 2) / 2
                                    opacity: 1
                                }
                            },
                            State {
                                name: "normal"
                                PropertyChanges {
                                    target: leftImgListView
                                    height: 0
                                    opacity: 0
                                }
                            }
                        ]
                    }

                    ListView {
                        id:rightImgListView
                        anchors.top: rightGroupHeader.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        clip: true
                        opacity: 0
                        height: 0

                        cacheBuffer: 10000

                        model: rightListModel

                        CameraModel {
                            id:rightListModel
                        }

                        delegate: Rectangle {
                            id: rightGroupRec
                            border.width: 0
                            anchors.left:parent.left
                            anchors.right:parent.right
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            height: rightImgListView.height / 12
                            color: Material.background

                            Rectangle {
                                id:rightExpandImgUrlName
                                width: parent.width / 2
                                height: parent.height
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                color: parent.color

                                Text {
                                    id:rightFilePathText
                                    anchors.fill: parent
                                    anchors.centerIn: parent.Center
                                    clip: true
                                    elide: Text.ElideMiddle
                                    text: qsTr(FileName)
                                    color: Material.primary
                                }
                            }

                            Rectangle {
                                height: parent.height
                                width: height
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                color: parent.color

                                Image {
                                    anchors.fill: parent
                                    source: "icon/img.png"
                                    verticalAlignment: Qt.AlignVCenter
                                    horizontalAlignment: Qt.AlignHCenter
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Menu {
                                id:rightDeleteMenu

                                MenuItem {
                                    text: "delete"
                                    icon.source: "icon/delete.png"

                                    onTriggered: {
                                        rightListModel.erase(rightFilePathText.text);
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                focus: true
                                acceptedButtons: Qt.AllButtons

                                onEntered: parent.color = Material.accent
                                onExited: parent.color = Material.background
                                onDoubleClicked: {
                                    displayImg.displayImgURL = "file:///" + FileName;
                                    shadow.visible = true;
                                }

                                onClicked: (mouse)=> {
                                    if(mouse.button === Qt.RightButton) {
                                        rightDeleteMenu.open();
                                    }
                                }
                            }
                        }

                        states : [
                            State {
                                name: "expand"
                                PropertyChanges {
                                    target: rightImgListView
                                    height: (rectangle9.height - leftGroupHeader.height * 2) / 2
                                    opacity: 1
                                }
                            },
                            State {
                                name: "normal"
                                PropertyChanges {
                                    target: rightImgListView
                                    height: 0
                                    opacity: 0
                                }
                            }
                        ]
                    }
                }

                Rectangle {
                    id: rectangle10
                    color: Material.background
                    border.width: 0
                    clip: true

                    property int memberCount: 12

                    Column {
                        anchors.fill: parent
                        anchors.topMargin: 10
                        spacing: 20

                        property int componentHeight: (height - (rectangle10.memberCount - 1) * spacing) / rectangle10.memberCount

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight
                            color: Material.background

                            Text {
                                id: rowFeatureText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Row feature number:")
                                color: Material.primary
                            }

                            SpinBox {
                                id:rowSpinBox
                                anchors.left: rowFeatureText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - rowFeatureText.width

                                value: 11
                                from: 0
                                to: 100
                                stepSize: 1
                                editable: true
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight
                            color: Material.background

                            Text {
                                id: colFeatureText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Col feature number:")
                                color: Material.primary
                            }

                            SpinBox {
                                id:colSpinBox
                                anchors.left: colFeatureText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - colFeatureText.width

                                value: 8
                                from: 0
                                to: 100
                                stepSize: 1
                                editable: true
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight
                            color: Material.background

                            Text {
                                id: trueDistFeatureText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("True distance:")
                                color: Material.primary
                            }

                            SpinBox {
                                id:trueDistSpinBox
                                anchors.left: trueDistFeatureText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - trueDistFeatureText.width

                                value: 25 * 100
                                from: 0
                                to: 100 * 100
                                stepSize: 100
                                editable: true

                                validator: DoubleValidator {
                                    bottom: Math.min(trueDistSpinBox.from, trueDistSpinBox.to)
                                    top: Math.max(trueDistSpinBox.from, trueDistSpinBox.to)
                                }

                                textFromValue: function(value, locale) {
                                    return Number(value / 100).toLocaleString(locale, 'f', 2)
                                }

                                valueFromText: function(text, locale) {
                                    return Number.fromLocaleString(locale, text) * 100
                                }
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight
                            color: Material.background

                            Text {
                                id: boardTypeText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Board type:")
                                color: Material.primary
                            }

                            ComboBox {
                                id:boardTypeComBox
                                anchors.left: boardTypeText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - boardTypeText.width
                                model: ["chess", "circle grid", "concentric cicle"]
                            }
                        }

                        Rectangle {
                            id: concentricRadius
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight * 2
                            color: Material.background

                            visible: boardTypeComBox.currentIndex === 2

                            Text {
                                id: trueRadiusText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 5
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Radius:")
                                color: Material.primary
                            }
                            
                            Grid {
                                rows: 2
                                columns: 2
                                rowSpacing: 5
                                columnSpacing: 5
                                anchors.left: trueRadiusText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - trueRadiusText.width
                                SpinBox {
                                    id:outRadiusSpinBox
                                    width: (parent.width - 2 * parent.rowSpacing) / 2
                                    value: 0.75 * 100
                                    from: 0
                                    to: 100 * 100
                                    stepSize: 100
                                    editable: true

                                    validator: DoubleValidator {
                                        bottom: Math.min(outRadiusSpinBox.from, outRadiusSpinBox.to)
                                        top: Math.max(outRadiusSpinBox.from, outRadiusSpinBox.to)
                                    }

                                    textFromValue: function(value, locale) {
                                        return Number(value / 100).toLocaleString(locale, 'f', 2)
                                    }

                                    valueFromText: function(text, locale) {
                                        return Number.fromLocaleString(locale, text) * 100
                                    }
                                }

                                SpinBox {
                                    id:outInnerRadiusSpinBox
                                    width: (parent.width - 2 * parent.rowSpacing) / 2
                                    value: 1.5 * 100
                                    from: 0
                                    to: 100 * 100
                                    stepSize: 100
                                    editable: true

                                    validator: DoubleValidator {
                                        bottom: Math.min(outInnerRadiusSpinBox.from, outInnerRadiusSpinBox.to)
                                        top: Math.max(outInnerRadiusSpinBox.from, outInnerRadiusSpinBox.to)
                                    }

                                    textFromValue: function(value, locale) {
                                        return Number(value / 100).toLocaleString(locale, 'f', 2)
                                    }

                                    valueFromText: function(text, locale) {
                                        return Number.fromLocaleString(locale, text) * 100
                                    }
                                }

                                SpinBox {
                                    id:innerRadiusSpinBox
                                    width: (parent.width - 2 * parent.rowSpacing) / 2
                                    value: 2.25 * 100
                                    from: 0
                                    to: 100 * 100
                                    stepSize: 100
                                    editable: true

                                    validator: DoubleValidator {
                                        bottom: Math.min(innerRadiusSpinBox.from, innerRadiusSpinBox.to)
                                        top: Math.max(innerRadiusSpinBox.from, innerRadiusSpinBox.to)
                                    }

                                    textFromValue: function(value, locale) {
                                        return Number(value / 100).toLocaleString(locale, 'f', 2)
                                    }

                                    valueFromText: function(text, locale) {
                                        return Number.fromLocaleString(locale, text) * 100
                                    }
                                }

                                SpinBox {
                                    id:innerInnerRadiusSpinBox
                                    width: (parent.width - 2 * parent.rowSpacing) / 2
                                    value: 3 * 100
                                    from: 0
                                    to: 100 * 100
                                    stepSize: 100
                                    editable: true

                                    validator: DoubleValidator {
                                        bottom: Math.min(innerInnerRadiusSpinBox.from, innerInnerRadiusSpinBox.to)
                                        top: Math.max(innerInnerRadiusSpinBox.from, innerInnerRadiusSpinBox.to)
                                    }

                                    textFromValue: function(value, locale) {
                                        return Number(value / 100).toLocaleString(locale, 'f', 2)
                                    }

                                    valueFromText: function(text, locale) {
                                        return Number.fromLocaleString(locale, text) * 100
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight
                            color: Material.background

                            CheckBox {
                                id:fixIntrinsic
                                width: parent.width / 2
                                height: parent.componentHeight
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                text: "fix intrinsic"
                            }

                            CheckBox {
                                id:epilorLineOutPut
                                width: parent.width / 2
                                height: parent.componentHeight
                                anchors.left: fixIntrinsic.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                text: "epilor-line output"
                            }
                        }

                        Button {
                            id:calibrateLeftCamera
                            height: parent.componentHeight
                            width: parent.width / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "calibrate l-cam"

                            onClicked: {
                                calibrateError.text = "Wait for calculate...";
                                calibrateLaucher.clearCalibrator();
                                calibrateLaucher.addCalibrator(leftListModel.imgPaths(), boardTypeComBox.currentIndex);
                                if(concentricRadius.visible) {
                                    calibrateLaucher.setRingRadius(Qt.vector4d(outRadiusSpinBox.value, outInnerRadiusSpinBox.value,
                                        innerRadiusSpinBox.value, innerInnerRadiusSpinBox.value));
                                }
                                var error = calibrateLaucher.calibrate(rowSpinBox.value, colSpinBox.value, trueDistSpinBox.value / 100);
                                calibrateError.text = "Error:" + error;
                            }
                        }

                        Button {
                            id:stereoCalibrate
                            height: parent.componentHeight
                            width: parent.width / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "stereo calibrate"

                            onClicked: {
                                calibrateError.text = "Wait for calculate...";
                                calibrateLaucher.clearCalibrator();
                                calibrateLaucher.addCalibrator(leftListModel.imgPaths(), boardTypeComBox.currentIndex);
                                calibrateLaucher.addCalibrator(rightListModel.imgPaths(), boardTypeComBox.currentIndex);
                                if(concentricRadius.visible) {
                                    calibrateLaucher.setRingRadius(Qt.vector4d(outRadiusSpinBox.value, outInnerRadiusSpinBox.value,
                                        innerRadiusSpinBox.value, innerInnerRadiusSpinBox.value));
                                }
                                var error = calibrateLaucher.stereoCalibrate(rowSpinBox.value, colSpinBox.value, trueDistSpinBox.value / 100, fixIntrinsic.checkState === Qt.Checked, epilorLineOutPut.checkState === Qt.Checked);
                                calibrateError.text = "Error:" + error;
                            }
                        }

                        Button {
                            id:epilorRectify
                            height: parent.componentHeight
                            width: parent.width / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "epilor rectify"

                            onClicked: {
                                var imgPath = calibrateLaucher.displayStereoRectify();
                                displayImg.displayImgURL = "file:///" + imgPath;
                                shadow.visible = false;
                            }
                        }

                        Rectangle {
                            height: parent.componentHeight * 2 / 3
                            width: parent.width
                            color: Material.background

                            Column {
                                anchors.fill: parent
                                spacing: 5

                                Text {
                                    id:calibrateError
                                    height: parent.height - 4
                                    width: parent.width

                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter

                                    text: "nan"
                                    color: Material.primary
                                }

                                Rectangle {
                                    height: 1
                                    width: parent.width * 3 / 4
                                    color: Material.dropShadowColor
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        Rectangle {
                            height: parent.componentHeight
                            width: parent.width
                            color: Material.background

                            ProgressBar {
                                id: progressBar
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                height: parent.height * 2 / 3
                                width: parent.width * 3 / 4

                                from: 0
                                to: 100
                            }
                        }
                    }
                }
            }

            PageIndicator {
                id: pageIndicator
                y: 0
                height: 20
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                count: swipeView.count
                currentIndex: swipeView.currentIndex
                interactive: true
            }
        }

        CalibrateLaucher {
            id:calibrateLaucher
        }

        Connections {
            target: calibrateLaucher

            onDrawKeyPointsChanged: function(path) {
                displayImg.displayImgURL = path;
                shadow.visible = true;
            }

            onErrorReturn: function(error) {
                calibrateError.text = "Error:" + error;
            }

            onProgressChanged: function(progress) {
                progressBar.value = progress * 100;
            }
        }
        /*
        Timeline {
            id: timeline
            animations: [
                TimelineAnimation {
                    id: timelineAnimation
                    loops: 1
                    running: true
                    duration: 2000
                    to: 2000
                    from: 0
                }
            ]
            enabled: true
            startFrame: 0
            endFrame: 2000

            KeyframeGroup {
                target: text1
                property: "opacity"
                Keyframe {
                    frame: 0
                    value: 0
                }

                Keyframe {
                    frame: 2000
                    value: 1
                }
            }

            KeyframeGroup {
                target: text3
                property: "opacity"
                Keyframe {
                    frame: 0
                    value: 0
                }

                Keyframe {
                    frame: 2000
                    value: 1
                }
            }
        }
        */
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}D{i:14}D{i:25}
}
##^##*/
