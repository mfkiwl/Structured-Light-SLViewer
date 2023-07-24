import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15

Rectangle {
    id: rootRec

    color: Material.background

    property bool isConnect: false

    Label {
        id: cameraLable
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 2
        text: qsTr("camera connect state")
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        anchors.left: cameraLable.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 2
        anchors.leftMargin: 24
        width: height
        radius: width / 2
        border.width: width / 6
        border.color: "gray"
        color: rootRec.isConnect ? "green" : "black"
    }
}
