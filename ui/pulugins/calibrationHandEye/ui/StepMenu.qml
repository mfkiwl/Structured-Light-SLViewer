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
    clip: true

    property int curStep: 0
    property var stepName: ["camera check", "robot check", "target check", "calibration", "result"]

    ListView {
        anchors.fill: parent
        anchors.margins: 4

        model: ListModel{
            ListElement {
                title: "camera check"
            }

            ListElement {
                title: "robot check"
            }

            ListElement {
                title: "target check"
            }

            ListElement {
                title: "calibration"
            }

            ListElement {
                title: "result"
            }
        }

        delegate: Rectangle {
            id: stepRec
            height: rootRec.height / 5
            width: parent.width
            color: stepName[curStep] === title ? Material.highlightedButtonColor : Qt.lighter(Material.background, 1.3)
            enabled: stepName[curStep] === title
            radius: 4


            PropertyAnimation {
                target: stepRec
                property: "color"
                duration: 2000
                easing.type: Easing.InOutQuad
                from: Qt.lighter(Material.background, 1.3)
                to: Material.highlightedButtonColor
                running: stepName[curStep] === title
                loops: Animation.Infinite
            }

            Image {
                id: stepIcon
                source: "qrc:/icons/application.ico"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 12
                anchors.bottom: parent.bottom
                sourceSize.height: parent.height * 1 / 3
                sourceSize.width: sourceSize.height
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                fillMode: Image.PreserveAspectFit
            }

            Label {
                anchors.left: stepIcon.right
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: title
            }
        }
    }
}
