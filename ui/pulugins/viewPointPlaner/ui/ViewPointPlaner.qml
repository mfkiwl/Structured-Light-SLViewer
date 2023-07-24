import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15

import FramelessWindowHelper 1.0
import ViewPointPlannerLaunch 1.0

import "../../../controls/Global/"

ApplicationWindow{
    id:mainWindow
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint
    minimumWidth: 720
    minimumHeight: 480
    width: 1080
    height: 640
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    visible: true

    Material.theme: Material.Dark

    property bool isConnect: false

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
            clip: true

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
                    width: 200
                    opacity: 1
                    color: Material.textSelectionColor
                    text: qsTr("View Point Planner Tool")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 8
                    font.pointSize: 35
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
                    font.pointSize: 12
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
                    font.pointSize: 12
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
                id: nextRec
                width: 120
                color: Material.dropShadowColor
                radius: 20
                anchors.right: rectangle7.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.topMargin: 8
                anchors.rightMargin: 16

                Text {
                    text: qsTr("Next")
                    anchors.fill: parent
                    font.pointSize: 12
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
                        nextRec.color = Material.highlightedButtonColor;
                    }

                    onPressed: {
                        nextRec.color = Material.buttonColor;
                        if(stepMenu.curStep + 1 > 2) {
                            stepMenu.curStep = 0;
                        }
                        else {
                            stepMenu.curStep += 1;
                        }
                    }

                    onReleased: {
                        nextRec.color = Material.highlightedButtonColor;
                    }

                    onExited: {
                        nextRec.color = Material.dropShadowColor;
                    }

                }
            }
        }

        StepMenu {
            id: stepMenu
            width: 200
            border.color: Material.dropShadowColor
            anchors.left: parent.left
            anchors.top: rectangle1.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: -1
            curStep: 0
            clip: true
        }

        SwipeView {
            id: windowView
            anchors.left: stepMenu.right
            anchors.right: parent.right
            anchors.top: rectangle1.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: -1
            currentIndex: stepMenu.curStep
            clip: true
            interactive: false

        }

        ViewPointPlannerLaunch {
            id: viewPointPlannerLaunch
            objectName: "viewPointPlannerLaunch"
        }

        MessageDialog {
            id: messageDialog
        }

        Connections {
            target: GlobalSignals

        }
    }
}

