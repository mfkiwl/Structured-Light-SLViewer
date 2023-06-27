import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root

    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color textColor: "#000000"
    property color foreColor: "#000000"

    property string labelText: ""
    property double progressVal: 0

    Material.theme: Material.Dark

    Rectangle {
        anchors.fill: parent
        color: backgroundColor

        Image {
            id: img
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 6
            width: height
            height: parent.height * 3 / 4
            source: "qrc:/icons/outline_info_white_36dp.png"


            NumberAnimation {
                target: img
                property: "opacity"
                duration: 5000
                from: 0
                to: 1
                running: true
                loops: Animation.Infinite
                easing.type: Easing.Linear
            }
        }

        Label {
            anchors.left: img.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 6
            width: 200
            text: root.labelText
            color: hoverColor
            verticalAlignment: Qt.AlignVCenter
        }

        ProgressBar {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 6
            width: 400
            from: 0
            to: 1
            value: progressVal
        }
    }
}
