import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.12

import ImagePaintItem 1.0

Rectangle {
    id: root
    property string labelText: ""
    property string itemObjectName: ""

    Material.theme: Material.Dark
    color: Qt.lighter(Material.background, 1.2)

    clip: true

    Rectangle {
        id: imgRec
        anchors.fill: parent
        clip: true
        color: parent.color

        ImagePaintItem {
            id: img
            objectName: itemObjectName
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 64
            height: 64

            DropShadow {
                z: -1
                anchors.fill: img
                horizontalOffset: 5
                verticalOffset: 5
                radius: 8.0
                color: Material.dropShadowColor
                source: img
                visible: true
            }

            MouseArea {
                cursorShape: Qt.OpenHandCursor
                anchors.fill: parent
                drag.target: img
                drag.axis: Drag.XAndYAxis

                onWheel: (wheel)=> {
                    var delta = wheel.angleDelta.y / 120;
                    if(delta > 0)
                        img.scale /= 0.9;
                    else
                        img.scale *= 0.9;
                }
            }
        }

        Rectangle {
            id: rootOperateRec
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 36
            width: 100
            height: 32
            radius: 4
            color: Qt.darker(root.color, 1.5)

            Label {
                text:labelText
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 6
                width: 50
                color: "white"
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.bold: true
                font.pointSize: 12
            }

            Cus_IconButton {
                id: reset
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height
                width: height
                iconSource: "qrc:/pulugins/calibrationMaster/ui/icon/origin.png"
                toolTipText: qsTr("重置比例")
                backgroundColor: rootOperateRec.color
                hoverColor: Material.accent
                clickColor: Material.highlightedButtonColor
                enableMouseArea: true

                onHasClicked: {
                    img.scale = 1;
                }
            }
        }
    }
}
