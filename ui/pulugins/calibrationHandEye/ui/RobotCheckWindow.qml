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

    property var robotNames: ["aubo", "ur", "gene"]

    Image {
        id: paintItem
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

           ComboBox {
               id: robotComboBox
               property var robotImg: ["qrc:/pulugins/calibrationHandEye/ui/icon/aubo.jpg", "qrc:/pulugins/calibrationHandEye/ui/icon/aubo.jpg", "qrc:/pulugins/calibrationHandEye/ui/icon/aubo.jpg"]
               model: robotNames
               Layout.fillHeight: true
               Layout.fillWidth: true
               editable: true

               onAccepted: {
                    paintItem.source = robotImg[currentIndex];
               }

               Component.onCompleted: {
                   paintItem.source = robotImg[currentIndex];
               }
           }

           TextEdit {
               id: robotIp
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "127.0.0.1"
               color: "white"
               horizontalAlignment: Qt.AlignHCenter
               verticalAlignment: Qt.AlignVCenter
           }

           Button {
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "connect robot"
               onClicked: {
                   GlobalSignals.connectRobot(robotNames[robotComboBox.currentIndex], robotIp.text);
               }
           }

           Button {
               Layout.fillHeight: true
               Layout.fillWidth: true
               text: "disConnect"
               onClicked: {
                   GlobalSignals.disConnect();
               }
           }
        }
    }
}
