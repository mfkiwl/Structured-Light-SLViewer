import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15

import FramelessWindowHelper 1.0

Window {
    id: rootWindow
    width: 320
    height: 180
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    visible: true
    title: "Hand Eye Method"
    flags: Qt.WindowCloseButtonHint | Qt.Dialog

    Material.theme: Material.Dark

    color: Material.background

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6

        Rectangle {
            id: manualRec
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.margins: 6
            color: Material.background
            clip: true
            radius: 6

            Image {
                id: imgManual
                anchors.fill: parent
                anchors.margins: 36
                anchors.topMargin: 12
                fillMode: Image.PreserveAspectFit
                source: "qrc:/icons/baseline_save_as_white_36dp.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }

            Label {
                anchors.top: imgManual.bottom
                //anchors.topMargin: -36
                height: 24
                width: 100
                anchors.horizontalCenter: imgManual.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Manual calibration"
                color: "white"
            }

            ToolTip {
                id: manuToolTip
                anchors.centerIn: parent.Center
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    calibrationHandEyeLoader.setSource("");
                    calibrationHandEyeLoader.setSource("qrc:/pulugins/calibrationHandEye/ui/ManuaCalibrationHandEye.qml");
                    rootWindow.close();
                }

                onEntered: {
                    manualRec.color = Material.highlightedButtonColor;
                    manuToolTip.show(qsTr("Use manual calibration method, this need person decide every pose."));
                }

                onExited: {
                    manualRec.color = Material.background;
                    manuToolTip.close();
                }
            }
        }

        Rectangle {
            id: autoRec
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.margins: 6
            clip: true
            color: Material.background
            radius: 6

            Image {
                id: imgAuto
                anchors.fill: parent
                anchors.margins: 36
                anchors.topMargin: 12
                source: "qrc:/icons/baseline_settings_white_36dp.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                fillMode: Image.PreserveAspectFit
            }

            Label {
                anchors.top: imgAuto.bottom
                //anchors.topMargin: -36
                height: 24
                width: 100
                anchors.horizontalCenter: imgAuto.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Auto calibration"
                color: "white"
            }

            ToolTip {
                id: autoToolTip
                anchors.centerIn: parent.Center
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    calibrationHandEyeLoader.setSource("");
                    calibrationHandEyeLoader.setSource("qrc:/pulugins/calibrationHandEye/ui/AutoCalibrationHandEye.qml");
                    rootWindow.close();
                }

                onEntered: {
                    autoRec.color = Material.highlightedButtonColor;
                    autoToolTip.show(qsTr("Use autolized calibration method, this will auto plan pose to calibration."));
                }

                onExited: {
                    autoRec.color = Material.background;
                    autoToolTip.close();
                }
            }
        }
    }

    Loader {
        id: calibrationHandEyeLoader
    }
}
