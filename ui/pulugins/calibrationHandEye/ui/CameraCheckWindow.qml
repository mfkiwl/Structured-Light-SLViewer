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

    ImagePaintItem {
        id: paintItem
        objectName: "continuesPaintItem"
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: parent.width * 3 / 4
        height: width * 0.75
        anchors.bottomMargin: 50

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
        anchors.bottomMargin: 10
        color: Material.background
        height: 40

        RowLayout {
           anchors.fill: parent
           anchors.leftMargin: 6
           anchors.rightMargin: 6
           spacing: 24

           Button {
               id: switchTo2DMode
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "switchTo2DMode"
               onClicked: {
                    GlobalSignals.changeTo2DMode();
               }
           }

           SpinBox {
               id: exposureTimeSpinBox
               value: GlobalSignals.exposureTime
               editable: true
               from: 0
               to: 9999999

               onValueChanged: {
                   GlobalSignals.changeCameraExposureTime(value);
               }
           }

           Button {
               id: display
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "display"
               onClicked: {
                   GlobalSignals.startDispaly2d(0);
               }
           }

           Button {
               id: stop
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "stop"
               onClicked: {
                   GlobalSignals.stopDispaly2d(0);
               }
           }
        }
    }
}
