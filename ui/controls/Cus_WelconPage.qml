import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtWebEngine 1.8

import FramelessWindowHelper 1.0

ApplicationWindow {
    id: root
    flags: Qt.FramelessWindowHint | Qt.CoverWindow | Qt.WindowMinimizeButtonHint | Qt.WindowStaysOnTopHint
    width: 640
    height: 480
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    visible: true

    Material.theme: Material.Dark

    color: Material.background

    signal cameraSelected(var cameraJsonPath, var cameraPropertyJsonPath, var cameraName)

    FramelessWindowHelper {

    }

    SwipeView {
        id: view
        currentIndex: tabBar.currentIndex
        anchors.fill: parent

        WebEngineView {
            id:webView
            settings.javascriptEnabled : true
            settings.pluginsEnabled:true
            url: "https://github.com/Yunhuang-Liu"
        }

        Rectangle {
            color: Qt.darker(Material.background, 1.3)

            GridView {
                anchors.fill: parent
                anchors.margins: 24

                model: ListModel {
                    ListElement {
                        name: "binoocularCamera"
                        jsonCameraPropertyPath: "qrc:/json/binoocularCameraConfig.json"
                        jsonCameraConfigPath: "../ui/json/binoocularCameraConfig.json"
                        cover: "qrc:/icons/binoocularCamera.png"
                        toolTipText: "双目结构光立体相机@Liu Yunhuang"
                    }
                }

                delegate: Rectangle {
                    width: 200
                    height: 150
                    border.width: 4
                    border.color: Material.dropShadowColor

                    Column {
                        anchors.fill: parent
                        anchors.margins: 4
                        Rectangle {
                            height: parent.height - 20
                            width: parent.width
                            clip: true

                            Image {
                                anchors.fill: parent
                                anchors.centerIn: parent.Center
                                source: cover
                                fillMode: Qt.KeepAspectRatioByExpanding
                            }
                        }

                        Rectangle {
                            id: cameraName
                            height: 20
                            width: parent.width
                            color: Material.primary

                            Text {
                                anchors.fill: parent
                                text: qsTr(name)
                                color: "white"
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                                font.pointSize: 12
                                font.bold: true
                            }
                        }
                    }

                    ToolTip {
                        id: toolTip
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        focus: true
                        propagateComposedEvents: true

                        onEntered: {
                            cameraName.color = Material.highlightedButtonColor;
                            toolTip.show(toolTipText, 2000)
                        }

                        onExited: {
                            cameraName.color = Material.primary;
                        }

                        onClicked: {
                            cameraSelected(jsonCameraConfigPath, jsonCameraPropertyPath, name);
                            root.close();
                        }
                    }
                }
            }
        }
    }

    PageIndicator {
         id: indicator

         count: view.count
         currentIndex: tabBar.currentIndex

         anchors.bottom: view.bottom
         anchors.horizontalCenter: parent.horizontalCenter
     }

    header: TabBar {
        id: tabBar
        currentIndex: view.currentIndex
        TabButton {
            text: qsTr("欢迎")
        }

        TabButton {
            text: qsTr("相机")
        }
    }
}
