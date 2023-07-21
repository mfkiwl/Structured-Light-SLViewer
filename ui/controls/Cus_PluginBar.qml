import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Item {
    id: root
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color textColor: "#000000"
    property color foreColor: "#000000"
    property color clickColor: "#000000"
    property color selectedColor: "#000000"
    property color borderColor: "#000000"
    property real opacityNorml: 0.6

    opacity: opacityNorml

    signal openCalibrationTool
    signal openGrayPhaseTool

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        focus: true
        propagateComposedEvents: true

        onEntered: {
            parent.opacity = 1;
        }

        onExited: {
            parent.opacity = opacityNorml;
        }

        //background
        Rectangle {
            anchors.fill: parent
            color: root.backgroundColor
            radius: 4

            Column {
                anchors.fill: parent
                anchors.topMargin: 2
                spacing: 6

                Cus_IconButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 6 / 7
                    height: parent.width * 6 / 7
                    enableMouseArea: true
                    backgroundColor: root.foreColor
                    hoverColor: root.hoverColor
                    clickColor: root.clickColor
                    iconSource: "qrc:/icons/outline_grid_white_36dp.png"
                    toolTipText: qsTr("标定工具@Author LiuYunhuang")

                    onHasClicked: {
                        openCalibrationTool();
                    }
                }

                Cus_IconButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 6 / 7
                    height: parent.width * 6 / 7
                    enableMouseArea: true
                    backgroundColor: root.foreColor
                    hoverColor: root.hoverColor
                    clickColor: root.clickColor
                    iconSource: "qrc:/icons/outline_filter_b_and_w_white_36dp.png"
                    toolTipText: qsTr("格雷相移码生成工具@Author LiuYunhuang")

                    onHasClicked: {
                        openGrayPhaseTool();
                    }
                }
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: 2
                horizontalOffset: 2
                color: shaderColor
            }
        }
    }
}
