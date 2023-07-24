import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15

import ImagePaintItem 1.0
import "../../../controls/Global/"

Rectangle {
    id: rootRec
    color: Material.background
    clip: true

    property var targetBoardType: ["chessBoard", "circleBoard", "concentricCircleBoard"]

    ImagePaintItem {
        id: paintItem
        objectName: "calibrationPaintItem"
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: parent.width * 3 / 4
        height: width * 0.75
        anchors.bottomMargin: 100

        MouseArea {
            cursorShape: Qt.OpenHandCursor
            anchors.fill: paintItem
            drag.target: paintItem
            drag.axis: Drag.XAndYAxis

            onWheel: (wheel)=> {
                var delta = wheel.angleDelta.y / 120;
                if(delta > 0)
                    paintItem.scale /= 0.9;
                else
                    paintItem.scale *= 0.9;
            }
        }
    }

    ListModel {
        id: listModel
    }

    ListView {
        id: imgSavedView
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 6
        anchors.bottomMargin: 40
        height: 60
        orientation: Qt.Horizontal
        model: listModel

        property int imgSaved: 0

        delegate: Rectangle {
            id: miniImgRec
            height: imgSavedView.height
            width: height
            color: Material.background

            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: imgSource
            }

            Menu {
                id: menu

                MenuItem {
                    text: qsTr("Delete")
                    onTriggered: {
                        GlobalSignals.discard(imgSavedView.currentIndex, listModel.get(imgSavedView.currentIndex).imgSource);
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onEntered: {
                    miniImgRec.color = Material.highlightedButtonColor;
                }

                onExited: {
                    miniImgRec.color = Material.background;
                }

                onPressed: function(mouse) {
                    if(mouse.button === Qt.RightButton) {
                        menu.open();
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 6
        anchors.bottomMargin: 10
        color: Material.background
        height: 40

        RowLayout {
           anchors.fill: parent
           anchors.leftMargin: 6
           anchors.rightMargin: 6
           spacing: 24

           Button {
               id: openCamera
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "open camera"
               onClicked: {
                   GlobalSignals.changeTo2DMode();
                   GlobalSignals.changeCameraExposureTime(GlobalSignals.exposureTime);
                   GlobalSignals.startDispaly2d(1);
               }
           }

           Button {
               id: closeCamera
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "close camera"
               onClicked: {
                   GlobalSignals.stopDispaly2d(1);
               }
           }

           Button {
               id: save
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "save"
               onClicked: {
                   GlobalSignals.save(imgSavedView.imgSaved++);
               }
           }

           Button {
               id: calibrate
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "calibrate"
               onClicked: {
                   GlobalSignals.calibrate();
               }
           }
        }
    }

    Connections {
        target: GlobalSignals

        function onSucessImgPath(writePath) {
            listModel.append({
                 imgSource: "file:///" + writePath
            });
        }

        function onDiscard(index, filePath) {
            listModel.remove(index);
        }
    }
}
