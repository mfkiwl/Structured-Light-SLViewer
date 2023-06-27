import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.15
import QtQuick.Timeline 1.0
import QtQuick.Dialogs
import QtCore
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material 2.15

import ImageModel 1.0
import CodeMakerLauncher 1.0
import FramelessWindowHelper 1.0

ApplicationWindow{
    id:mainWindow
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint
    width: 1280
    height: 700
    minimumWidth: 640
    minimumHeight: 480
    visible: true
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2

    Material.theme: Material.Dark
    
    FramelessWindowHelper {

    }

    CodeMakerLauncher {
        id:codeMakerLauncher
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
            border.color: Material.background
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
                    width: 250
                    opacity: 0
                    color: Material.accent
                    text: qsTr("Gray-Phase Encoder Tool")
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
                    opacity: 0
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
                height: 2
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
                color: Qt.lighter(Material.background, 1.3)
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
                        rectangle7.color = Qt.darker(Material.highlightedButtonColor, 1.5);

                        mainWindow.close();
                    }

                    onReleased: {
                        rectangle7.color = Material.highlightedButtonColor;
                    }

                    onExited: {
                        rectangle7.color = Qt.lighter(Material.background, 1.3);
                    }

                }
            }
        }

        Rectangle {
            id: rectangle6
            color: Material.background
            border.color: Material.background
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

            Rectangle {
                id: buttonsImgOperate
                z: 2
                width: 180
                height: 50
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 30
                anchors.bottomMargin: 30
                color: Qt.lighter(Material.background, 1.3)
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
                    color: Qt.lighter(Material.background, 1.3)

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
                                expandImgRec.color = Qt.darker(Material.highlightedButtonColor, 1.5);
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
                    color: Qt.lighter(Material.background, 1.3)

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
                                resetImgRec.color = Qt.darker(Material.highlightedButtonColor, 1.5);
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
                    color: Qt.lighter(Material.background, 1.3)

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
                                miniMizeImgRec.color = Qt.darker(Material.highlightedButtonColor, 1.5);
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
            width: 450
            color: Material.background
            border.color: Material.dropShadowColor
            border.width: 2
            anchors.left: parent.left
            anchors.top: rectangle1.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: -2

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
                        id: grayGroupHeader
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.right: parent.right
                        height: parent.height / 12
                        color: Material.background;

                        Text {
                            font.pixelSize: 16
                            verticalAlignment: Text.AlignVCenter
                            font.weight: Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 8
                            width: 100
                            text: "Gray"
                            color: Material.primary
                        }

                        Rectangle {
                            id:imgBackground
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.height - 32
                            anchors.margins: 16
                            color: Material.background;

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
                                        grayImgListView.state === "expand" ? grayImgListView.state = "normal" : grayImgListView.state = "expand";
                                        parent.source = grayImgListView.state === "expand" ? "icon/nonExpand.png" : "icon/expand.png";
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
                            height: 2
                            color: Material.dropShadowColor
                        }
                    }

                    Rectangle {
                        id: phaseGroupHeader
                        anchors.left: parent.left
                        anchors.top: grayImgListView.bottom
                        anchors.right: parent.right
                        height: parent.height / 12
                        color: Material.background;

                        Text {
                            font.pixelSize: 16
                            verticalAlignment: Text.AlignVCenter
                            font.weight: Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 8
                            width: 100
                            text: "Phase"
                            color: Material.primary
                        }

                        Rectangle {
                            id:phaseImgBackground
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.height - 32
                            anchors.margins: 16
                            color: Material.background;

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
                                        phaseImgListView.state === "expand" ? phaseImgListView.state = "normal" : phaseImgListView.state = "expand";
                                        parent.source = phaseImgListView.state === "expand" ? "icon/nonExpand.png" : "icon/expand.png";
                                    }
                                    onEntered: {
                                        phaseImgBackground.color = Material.highlightedButtonColor;
                                    }

                                    onReleased: {
                                        phaseImgBackground.color = Material.highlightedButtonColor;
                                    }

                                    onExited: {
                                        phaseImgBackground.color = Material.background;
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
                            height: 2
                            color: Material.dropShadowColor
                        }
                    }

                    ListView {
                        id:grayImgListView
                        anchors.left: parent.left
                        anchors.top: grayGroupHeader.bottom
                        anchors.right: parent.right
                        clip: true
                        height:0
                        opacity: 0
                        cacheBuffer: 10000

                        model: grayListModel

                        ImageModel {
                            id:grayListModel
                        }

                        delegate: Rectangle {
                            id: grayGroupRec
                            border.width: 0
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            height: grayImgListView.height / 12
                            color: Material.background;

                            Rectangle {
                                id:grayExpandImgUrlName
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
                                        grayListModel.erase(filePathText.text);
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                focus: true
                                acceptedButtons: Qt.AllButtons

                                onEntered: parent.color = Material.highlightedButtonColor
                                onExited: parent.color = Material.background;
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
                                    target: grayImgListView
                                    height: (rectangle9.height - grayGroupHeader.height * 2) / 2
                                    opacity: 1
                                }
                            },
                            State {
                                name: "normal"
                                PropertyChanges {
                                    target: grayImgListView
                                    height: 0
                                    opacity: 0
                                }
                            }
                        ]
                    }

                    ListView {
                        id:phaseImgListView
                        anchors.top: phaseGroupHeader.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        clip: true
                        opacity: 0
                        height: 0

                        cacheBuffer: 10000

                        model: phaseListModel

                        ImageModel {
                            id:phaseListModel
                        }

                        delegate: Rectangle {
                            id: phaseGroupRec
                            border.width: 0
                            anchors.left:parent.left
                            anchors.right:parent.right
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            height: phaseImgListView.height / 12
                            color: Material.background;

                            Rectangle {
                                id:phaseExpandImgUrlName
                                width: parent.width / 2
                                height: parent.height
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                color: parent.color

                                Text {
                                    id:phaseFilePathText
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
                                id:phaseDeleteMenu

                                MenuItem {
                                    text: "delete"
                                    icon.source: "icon/delete.png"

                                    onTriggered: {
                                        phaseListModel.erase(phaseFilePathText.text);
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                focus: true
                                acceptedButtons: Qt.AllButtons

                                onEntered: parent.color = Material.highlightedButtonColor
                                onExited: parent.color = Material.background, 1.3;
                                onDoubleClicked: {
                                    displayImg.displayImgURL = "file:///" + FileName;
                                    shadow.visible = true;
                                }

                                onClicked: (mouse)=> {
                                    if(mouse.button === Qt.RightButton) {
                                        phaseDeleteMenu.open();
                                    }
                                }
                            }
                        }

                        states : [
                            State {
                                name: "expand"
                                PropertyChanges {
                                    target: phaseImgListView
                                    height: (rectangle9.height - phaseGroupHeader.height * 2) / 2
                                    opacity: 1
                                }
                            },
                            State {
                                name: "normal"
                                PropertyChanges {
                                    target: phaseImgListView
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

                    property int memberCount: 16

                    Column {
                        anchors.fill: parent
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        spacing: 6

                        property int componentHeight: (height - (rectangle10.memberCount - 1) * spacing) / rectangle10.memberCount

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight
                            color: Material.background

                            Text {
                                id: imgWidthText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Image width:")
                                color: Material.primary
                            }

                            SpinBox {
                                id:widthSpinBox
                                anchors.left: imgWidthText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - imgWidthText.width

                                value: 1920
                                from: 0
                                to: 100000
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
                                id: imgHeightText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Image height:")
                                color: Material.primary
                            }

                            SpinBox {
                                id:heightSpinBox
                                anchors.left: imgHeightText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - imgHeightText.width

                                value: 1080
                                from: 0
                                to: 100000
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
                                id: grayCodeTimesText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("GrayCode times:")
                                color: Material.primary
                            }

                            SpinBox {
                                id:grayCodeTimesSpinBox
                                anchors.left: grayCodeTimesText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - grayCodeTimesText.width

                                value: 6
                                from: 0
                                to: 1000000
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
                                id: phaseCodeTimesText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("PhaseCode times:")
                                color: Material.primary
                            }

                            SpinBox {
                                id: phaseCodeTimesSpinBox
                                anchors.left: phaseCodeTimesText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - phaseCodeTimesText.width
                                value: 4
                                from: 0
                                to: 10000
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
                                id: phasePatchPixelsText
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: parent.width / 2
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("PhasePatch pixels:")
                                color: Material.primary
                            }

                            SpinBox {
                                id: phasePatchPixelsSpinbox
                                anchors.left: phasePatchPixelsText.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width - phasePatchPixelsText.width
                                value: 6000
                                from: 0
                                to: 10000000
                                stepSize: 100
                                editable: true

                                validator: DoubleValidator {
                                    bottom: Math.min(phasePatchPixelsSpinbox.from, phasePatchPixelsSpinbox.to)
                                    top: Math.max(phasePatchPixelsSpinbox.from, phasePatchPixelsSpinbox.to)
                                }

                                textFromValue: function(value, locale) {
                                    return Number(value / 100).toLocaleString(locale, 'f', 2)
                                }

                                valueFromText: function(text, locale) {
                                    return Number.fromLocaleString(locale, text) * 100
                                }
                            }
                        }

                        GroupBox {
                            label: Label{
                                text: qsTr("Normal")
                                font.bold: true
                                color: "orange"
                                height: 20
                            }

                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight * 2
                            Grid {
                                anchors.fill: parent
                                columnSpacing: 6
                                CheckBox {
                                    id: isChangedModeYCB
                                    checked: false
                                    text: "honrizon"
                                }
                                CheckBox {
                                    id: isOneHeightModeCB
                                    checked: false
                                    text: "one height"
                                }
                                CheckBox {
                                    id: isOneBitModeCB
                                    checked: false
                                    text: "one bit"
                                }
                            }
                        }

                        GroupBox {
                            label: CheckBox {
                                id: grayCodeBox
                                Text{
                                    anchors.left: parent.right
                                    text: qsTr("GrayCode")
                                    font.bold: true
                                    color: "orange"
                                }
                                checked: true
                            }

                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight * 3.5

                            Grid {
                                anchors.fill: parent
                                rowSpacing: parent.height / 3
                                rows: 1
                                CheckBox {
                                    id: imagePlanesCB
                                    checked: false
                                    text: "image planes"
                                    width: 100
                                }
                                CheckBox {
                                    id: isFourFloorGrayCodeCB
                                    checked: false
                                    text: "four floor"
                                    width: 100
                                }
                                CheckBox {
                                    id: isShiftGrayCodeCB
                                    checked: false
                                    text: "shift graycode"
                                    width: 100
                                }
                                CheckBox {
                                    id: isShiftLineModeCB
                                    checked: false
                                    text: "shift line"
                                    width: 100
                                }
                            }
                        }

                        GroupBox {
                            label: CheckBox {
                                id: phaseCodeBox
                                Text{
                                    anchors.left: parent.right
                                    text: qsTr("PhaseCode")
                                    font.bold: true
                                    color: "orange"
                                }
                                checked: true
                            }
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.componentHeight * 5.7
                            Grid {
                                anchors.fill: parent
                                rowSpacing: parent.height / 3
                                columnSpacing: 6
                                columns: 3
                                CheckBox {
                                    id: isWhiteModeCB
                                    checked: false
                                    text: "white"
                                }
                                CheckBox {
                                    id: isBinaryPhaseModeCB
                                    checked: false
                                    text: "binary"
                                }
                                CheckBox {
                                    id: isOPWMModeCB
                                    checked: false
                                    text: "OPWM"
                                }
                                CheckBox {
                                    id: isCounterModeCB
                                    checked: false
                                    text: "counter mode"
                                }
                                CheckBox {
                                    id: isPhaseErrorExpandModeCB
                                    checked: false
                                    text: "error-expand"
                                }
                                CheckBox {
                                    id: isCounterDirectionModeCB
                                    checked: false
                                    text: "counter clockwise"
                                }
                            }
                        }

                        Button {
                            id: encoderButton
                            height: parent.componentHeight * 1.3
                            width: parent.width / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "encoder!"

                            onClicked: {
                                codeMakerLauncher.setWhiteMode(isWhiteModeCB.checked);
                                codeMakerLauncher.setShiftGrayCodeMode(isShiftGrayCodeCB.checked);
                                codeMakerLauncher.setFourFloorGrayCodeMode(isFourFloorGrayCodeCB.checked);
                                codeMakerLauncher.setBinaryPhaseMode(isBinaryPhaseModeCB.checked);
                                codeMakerLauncher.setOPWMMode(isOPWMModeCB.checked);
                                codeMakerLauncher.setCounterMode(isCounterModeCB.checked);
                                codeMakerLauncher.setPhaseErrorExpandMode(isPhaseErrorExpandModeCB.checked);
                                codeMakerLauncher.setShiftLineMode(isShiftLineModeCB.checked);
                                codeMakerLauncher.setChangeYMode(isChangedModeYCB.checked);
                                codeMakerLauncher.setWidth(widthSpinBox.value);
                                codeMakerLauncher.setHeight(heightSpinBox.value);
                                codeMakerLauncher.setImagePlanes(imagePlanesCB.checked);
                                codeMakerLauncher.setGrayCodeTimes(grayCodeTimesSpinBox.value);
                                codeMakerLauncher.setPhaseShiftTimes(phaseCodeTimesSpinBox.value);
                                codeMakerLauncher.setPhasePatchPixels(phasePatchPixelsSpinbox.value);
                                codeMakerLauncher.setOneHeightMode(isOneHeightModeCB.checked);
                                codeMakerLauncher.setIsOneBitMode(isOneBitModeCB.checked);
                                codeMakerLauncher.setCounterDirectionMode(isCounterDirectionModeCB.checked);
                                if(grayCodeBox.checkState === Qt.Checked) {
                                    codeMakerLauncher.startEncoderGrayCode();
                                    grayListModel.recurseImg("../out/gray/", widthSpinBox.value, heightSpinBox.value);
                                }
                                if(phaseCodeBox.checkState === Qt.Checked) {
                                    codeMakerLauncher.startEncoderPhaseCode();
                                    phaseListModel.recurseImg("../out/phase/", widthSpinBox.value, heightSpinBox.value);
                                }

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
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}D{i:14}D{i:25}
}
##^##*/
