import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color textColor: "#000000"
    property color foreColor: "#000000"
    property color clickColor: "#000000"
    signal closeWindow
    signal minimumWindow
    signal maximumWindow

    signal cameraViewPortPressed(var x, var y)

    //fore background
    Rectangle {
        anchors.fill: parent
        color: foreColor
        //Icon
        Cus_IconButton {
            id: applicationIcon
            anchors.left: parent.left
            anchors.top: parent.top
            height: parent.height
            width: height
            backgroundColor: parent.color
            enableMouseArea: false
            iconSource: "qrc:/icons/application.ico"
        }

        //Main Tool Button
        RowLayout {
            anchors.left: applicationIcon.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.bottomMargin: 0
            width: 36 * 6
            spacing: 12

            Cus_MainMenuButton {
                id: fileMainTool
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: 36
                background: foreColor
                textColor: root.textColor
                textString: "文件"
            }

            Cus_MainMenuButton {
                id: toolMainTool
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: 36
                background: foreColor
                textColor: root.textColor
                textString: "工具"
            }

            Cus_MainMenuButton {
                id: viewMainTool
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: 36
                background: foreColor
                textColor: root.textColor
                textString: "视图"

                onHasClicked: function(x, y) {
                    cameraViewPortPressed(x, y);
                }
            }

            Cus_MainMenuButton {
                id: helpMainTool
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: 36
                background: foreColor
                textColor: root.textColor
                textString: "帮助"
            }

        }

        //window operator
        RowLayout {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 12
            anchors.bottomMargin: 0
            layoutDirection: Qt.RightToLeft
            width: 48 * 4
            spacing: 12

            Cus_IconButton {
                id: closeWindowTool
                Layout.preferredHeight: parent.height * 2 / 3
                Layout.preferredWidth: parent.height * 2 / 3
                backgroundColor: root.foreColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_close_white_36dp.png"
                toolTipText: qsTr("关闭")

                onHasClicked: {
                    closeWindow();
                }
            }

            Cus_IconButton {
                id: fullScreenWindowTool
                Layout.preferredHeight: parent.height * 2 / 3
                Layout.preferredWidth: parent.height * 2 / 3
                backgroundColor: root.foreColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_open_in_full_white_36dp.png"
                toolTipText: qsTr("最大化")

                onHasClicked: {
                    maximumWindow();
                }
            }

            Cus_IconButton {
                id: compressWindowTool
                Layout.preferredHeight: parent.height * 2 / 3
                Layout.preferredWidth: parent.height * 2 / 3
                backgroundColor: root.foreColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/outline_minimize_white_36dp.png"
                toolTipText: qsTr("最小化")

                onHasClicked: {
                    minimumWindow();
                }
            }

            Cus_IconButton {
                id: help
                Layout.preferredHeight: parent.height * 2 / 3
                Layout.preferredWidth: parent.height * 2 / 3
                backgroundColor: root.foreColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_help_outline_white_36dp.png"
                toolTipText: qsTr("帮助")
            }

            Cus_IconButton {
                id: info
                Layout.preferredHeight: parent.height * 2 / 3
                Layout.preferredWidth: parent.height * 2 / 3
                backgroundColor: root.foreColor
                hoverColor: root.hoverColor
                clickColor: root.clickColor
                iconSource: "qrc:/icons/baseline_info_white_36dp.png"
                toolTipText: qsTr("信息")
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "* SLView---A power tool designed by Liu Yunhuang"
            color: root.textColor
            font.pointSize: 10
            font.italic: true
            font.bold: true
            IconImage {
                anchors.left: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 12
                source: "qrc:/icons/outline_emoji_emotions_white_36dp.png"
            }
        }
    }
}
