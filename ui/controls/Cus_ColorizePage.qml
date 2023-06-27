import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Window {
    id: root
    width: 320
    height: 480
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    visible: true

    Material.theme: Material.Dark

    color: Material.background

    signal jetDepthColorMap
    signal uniformColorMap
    signal cancelColorMap

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 6

        Rectangle {
            id: jetColorizeMapButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: root.color
            radius: 6
            Image {
                source: "qrc:/icons/outline_gradient_white_36dp.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                anchors.leftMargin: 12
            }

            Label {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 36
                text: "jet depth color map"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    jetColorizeMapButton.color = Material.accent;
                }

                onExited: {
                    jetColorizeMapButton.color = root.color;
                }

                onPressed: {
                    jetDepthColorMap();
                }
            }
        }

        Rectangle {
            id: uniformColorMapButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: root.color
            radius: 6
            Image {
                source: "qrc:/icons/outline_palette_white_36dp.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                anchors.leftMargin: 12
            }

            Label {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 36
                text: "unifom color map"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    uniformColorMapButton.color = Material.accent;
                }

                onExited: {
                    uniformColorMapButton.color = root.color;
                }

                onPressed: {
                    uniformColorMap();
                }
            }
        }

        Rectangle {
            id: cancelColorMapButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: root.color
            radius: 6
            Image {
                source: "qrc:/icons/outline_format_color_reset_white_36dp.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                anchors.leftMargin: 12
            }

            Label {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 36
                text: "cancel color map"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    cancelColorMapButton.color = Material.accent;
                }

                onExited: {
                    cancelColorMapButton.color = root.color;
                }

                onPressed: {
                    cancelColorMap();
                }
            }
        }
    }
}
