import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    property string iconSource: ""
    property string toolTipText: ""
    property color backgroundColor: "#000000"
    property color hoverColor: "#000000"
    property color clickColor: "#000000"
    property bool enableMouseArea: true
    property bool checkMode: false
    property bool hasChecked: false
    signal hasClicked

    Material.theme: Material.Dark

    MouseArea {
        anchors.fill: parent
        enabled: enableMouseArea
        propagateComposedEvents: true
        hoverEnabled: true

        Rectangle {
            id: iconRec
            anchors.fill: parent
            color: backgroundColor
            radius: 4

            Image {
                id: iconImg
                anchors.fill: parent
                source: iconSource
                fillMode: Qt.KeepAspectRatioByExpanding
            }

            ToolTip {
                id: toolTip
            }
        }


        onClicked: {
            hasChecked = checkMode ? !hasChecked : hasChecked;
            hasClicked();
            iconRec.color = hoverColor;
        }

        onExited: {
            iconRec.color = hasChecked ? hoverColor : backgroundColor;
            toolTip.close();
        }

        onEntered: {
            iconRec.color = hoverColor;
            toolTip.show(toolTipText, 3000);
        }
    }
}
