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
    property var targetBoardImgSource: ["qrc:/pulugins/calibrationHandEye/ui/icon/chessBoard.png", "qrc:/pulugins/calibrationHandEye/ui/icon/circleBoard.png", "qrc:/pulugins/calibrationHandEye/ui/icon/concentricCircle.png"]

    Image {
        id: paintItem
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: parent.width * 3 / 4
        height: width * 0.75
        anchors.bottomMargin: 160

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

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 6
        color: Material.background
        height: 160

        GridLayout {
           anchors.fill: parent
           anchors.leftMargin: 6
           anchors.rightMargin: 6
           rowSpacing: 12
           columnSpacing: 12
           rows: 2
           columns: 4

           Rectangle {
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background

               Text {
                   id: targetTypeText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
               }

               ComboBox {
                   id: targetType
                   anchors.left: targetTypeText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   model: targetBoardType
                   editable: true
                   currentIndex: 0

                   Component.onCompleted: {
                       paintItem.source = "";
                       paintItem.source = targetBoardImgSource[targetType.currentIndex];
                   }

                   onActivated: function(index) {
                       paintItem.source = "";
                       paintItem.source = targetBoardImgSource[index];
                   }
               }
           }

           Rectangle {
               Layout.fillHeight: true
               Layout.fillWidth: true
               color: Material.background
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4

               Text {
                   id: rowNumText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "rowNum"
                   color: "white"
               }

               SpinBox {
                   id: rowNum
                   anchors.left: rowNumText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 5
                   from: 0
                   to: 99999
                   editable: true
               }
           }

           Rectangle {
               Layout.fillHeight: true
               Layout.fillWidth: true
               color: Material.background
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4

               Text {
                   id: colNumText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "colNum"
                   color: "white"
               }

               SpinBox {
                   id: colNum
                   anchors.left: colNumText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 7
                   from: 0
                   to: 99999
                   editable: true
               }
           }

           Rectangle {
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background
               visible: targetType.currentIndex !== 2

               Text {
                   id: chessLengthOrCircleRadiusText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "length"
                   color: "white"
               }

               SpinBox {
                   id: chessLengthOrCircleRadius
                   anchors.left: chessLengthOrCircleRadiusText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 25 * 100
                   from: 0
                   to: 99999 * 100
                   editable: true

                   validator: DoubleValidator {
                       bottom: Math.min(chessLengthOrCircleRadius.from, chessLengthOrCircleRadius.to)
                       top: Math.max(chessLengthOrCircleRadius.from, chessLengthOrCircleRadius.to)
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
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background
               visible: targetType.currentIndex === 2

               Text {
                   id: outBigRadiusText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "outOut-R"
                   color: "white"
               }

               SpinBox {
                   id: outBigRadius
                   anchors.left: outBigRadiusText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 50 * 100
                   from: 0
                   to: 99999 * 100
                   editable: true

                   validator: DoubleValidator {
                       bottom: Math.min(outBigRadius.from, outBigRadius.to)
                       top: Math.max(outBigRadius.from, outBigRadius.to)
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
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background
               visible: targetType.currentIndex === 2

               Text {
                   id: outSmallRadiusText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "outIn-R"
                   color: "white"
               }

               SpinBox {
                   id: outSmallRadius
                   anchors.left: outSmallRadiusText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 40 * 100
                   from: 0
                   to: 99999 * 100
                   editable: true

                   validator: DoubleValidator {
                       bottom: Math.min(outSmallRadius.from, outSmallRadius.to)
                       top: Math.max(outSmallRadius.from, outSmallRadius.to)
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
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background
               visible: targetType.currentIndex === 2

               Text {
                   id: innerBigRadiusText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "inOut-R"
                   color: "white"
               }

               SpinBox {
                   id: innerBigRadius
                   anchors.left: innerBigRadiusText.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 30 * 100
                   from: 0
                   to: 99999 * 100
                   editable: true

                   validator: DoubleValidator {
                       bottom: Math.min(innerBigRadius.from, innerBigRadius.to)
                       top: Math.max(innerBigRadius.from, innerBigRadius.to)
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
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background
               visible: targetType.currentIndex === 2

               Text {
                   id: innerSmallRadiusText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "inIn-R"
                   color: "white"
               }

               SpinBox {
                   id: innerSmallRadius
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 20 * 100
                   from: 0
                   to: 99999 * 100
                   editable: true


                   validator: DoubleValidator {
                       bottom: Math.min(innerSmallRadius.from, innerSmallRadius.to)
                       top: Math.max(innerSmallRadius.from, innerSmallRadius.to)
                   }

                   textFromValue: function(value, locale) {
                       return Number(value / 100).toLocaleString(locale, 'f', 2)
                   }

                   valueFromText: function(text, locale) {
                       return Number.fromLocaleString(locale, text) * 100
                   }
               }
           }

           ComboBox {
               id: eyePlaceComboBox
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               model: ["eyeInHand", "eyeToHand"]
           }

           ComboBox {
               id: methodComboBox
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               model: ["Tsai", "Andreff", "Park", "Daniilidis", "Horaud"]
           }

           Rectangle {
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               color: Material.background
               visible: targetType.currentIndex === 2

               Text {
                   id: scaleFactorText
                   anchors.left: parent.left
                   width: 40
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   text: "scale"
                   color: "white"
               }

               SpinBox {
                   id: scaleFactor
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.right: parent.right
                   anchors.leftMargin: 4
                   value: 1 * 100
                   from: 0
                   to: 99999 * 100
                   editable: true


                   validator: DoubleValidator {
                       bottom: Math.min(scaleFactor.from, scaleFactor.to)
                       top: Math.max(scaleFactor.from, scaleFactor.to)
                   }

                   textFromValue: function(value, locale) {
                       return Number(value / 100).toLocaleString(locale, 'f', 2)
                   }

                   valueFromText: function(text, locale) {
                       return Number.fromLocaleString(locale, text) * 100
                   }
               }
           }

           Button {
               Layout.fillHeight: true
               Layout.fillWidth: true
               Layout.maximumHeight: parent.height / 3
               Layout.maximumWidth: parent.width / 4
               text: "set it!"

               onPressed: {
                   if(targetType.currentIndex == 2) {
                       var targetParams = [eyePlaceComboBox.currentText, methodComboBox.currentText, scaleFactor.value / 100.0, rowNum.value, colNum.value, outBigRadius.value / 100.0, outSmallRadius.value / 100.0, innerBigRadius.value / 100.0, innerSmallRadius.value / 100.0];
                       GlobalSignals.setTarget(targetBoardType[targetType.currentIndex], targetParams);
                   }
                   else {
                       var targetParams = [eyePlaceComboBox.currentText, methodComboBox.currentText, scaleFactor.value / 100.0, rowNum.value, colNum.value, chessLengthOrCircleRadius.value / 100.0];
                       GlobalSignals.setTarget(targetBoardType[targetType.currentIndex], targetParams);
                   }
               }
           }
        }
    }
}

