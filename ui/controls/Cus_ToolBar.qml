import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color textColor: "#000000"
    property color foreColor: "#000000"
    property color clickColor: "#000000"
    property color selectedColor: "#000000"
    property color borderColor: "#000000"

    signal capture
    signal continueCapture
    signal stopCapture
    signal updateCameraParams
    signal resetCameraParams
    signal enableOfflineMode(bool isEnable)
    signal enableAlignedMode(bool isEnable)

    signal cloudMode
    signal imageMode

    signal savePointCloud
    signal cutPointCloud
    signal getPointInfo
    signal filterPointCloud
    signal surfaceRestruction
    signal colorizeCloud

    //background
    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor

        RowLayout {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 6
            width: height * 3 / 4 * 6
            spacing: 12

            Cus_IconButton {
                id: userAccount
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_account_circle_white_36dp.png"
                toolTipText: "账户"
            }

            Cus_IconButton {
                id: cloudMessage
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_place_white_36dp.png"
                toolTipText: "点云信息模式"
                checkMode: true

                onHasClicked: {
                    getPointInfo();
                }
            }

            Cus_IconButton {
                id: userCurCloud
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_content_cut_white_36dp.png"
                toolTipText: "剪切点云模式"
                checkMode: true

                onHasClicked: {
                    cutPointCloud();
                }
            }

            Cus_IconButton {
                id: filterCloud
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_filter_alt_white_36dp.png"
                toolTipText: "过滤点云"

                onHasClicked: {
                    filterPointCloud();
                }
            }

            Cus_IconButton {
                id: meshCloud
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_deblur_white_36dp.png"
                toolTipText: "曲面化点云"

                onHasClicked: {
                    surfaceRestruction();
                }
            }

            Cus_IconButton {
                id: colorizedCloud
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_format_color_fill_white_36dp.png"
                toolTipText: "颜色化点云"

                onHasClicked: {
                    colorizeCloud();
                }
            }

            Cus_IconButton {
                id: saveCloud
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_save_as_white_36dp.png"
                toolTipText: "保存点云"

                onHasClicked: {
                    savePointCloud();
                }
            }
        }

        Cus_TabButtons {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: 230
            height: parent.height * 4 / 5
            depthIconSource: "qrc:/icons/baseline_image_white_36dp.png"
            cloudIconSource: "qrc:/icons/baseline_cloud_white_36dp.png"
            backgroundColor: Qt.darker(root.foreColor, 1.5)
            selectedColor: root.selectedColor
            hoverColor: root.hoverColor
            clickColor: root.clickColor
            textColor: root.textColor
            borderColor: root.borderColor

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: 2
                horizontalOffset: 2
                color: root.borderColor
            }

            onCloudClicked: {
                cloudMode();
            }

            onDepthClicked: {
                imageMode();
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 12
            width: height * 3 / 4 * 3
            layoutDirection: Qt.RightToLeft

            Cus_IconButton {
                id: stopRepeatCapture
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_stop_white_36dp.png"
                toolTipText: "停止重复捕获"

                onHasClicked: {
                    stopCapture();
                }
            }

            Cus_IconButton {
                id: repeatCapture
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_repeat_white_36dp.png"
                toolTipText: "重复捕获"

                onHasClicked: {
                    continueCapture();
                }
            }

            Cus_IconButton {
                id: captureOnce
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_play_arrow_white_36dp.png"
                toolTipText: "捕获一次"

                onHasClicked: {
                    capture();
                }
            }

            Cus_IconButton {
                id: keepMergeCloud
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_merge_white_36dp.png"
                checkMode: true
                toolTipText: "点云拼接模式"

                onHasClicked: {
                    enableAlignedMode(keepMergeCloud.hasChecked)
                }
            }

            Cus_IconButton {
                id: offlineMode
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_videocam_off_white_36dp.png"
                checkMode: true
                toolTipText: "离线重建模式"

                onHasClicked: {
                    enableOfflineMode(offlineMode.hasChecked)
                }
            }

            Cus_IconButton {
                id: updateCamera
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_update_white_36dp.png"
                toolTipText: "更新相机"

                onHasClicked: {
                    updateCameraParams();
                }
            }

            Cus_IconButton {
                id: resetCam
                Layout.preferredHeight: parent.height * 3 / 4
                Layout.preferredWidth: parent.height * 3 / 4
                backgroundColor: root.backgroundColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_restart_alt_white_36dp.png"
                toolTipText: "重置相机"

                onHasClicked: {
                    resetCameraParams();
                }
            }
        }
    }
}
