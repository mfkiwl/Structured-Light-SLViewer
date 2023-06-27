import QtQuick 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    id: root
    color: backgroundColor

    property color selectionColor: "#000000"
    property color hoverColor: "#000000"
    property color textColor: "#000000"
    property color backgroundColor: "#000000"
    property string headerText: "text"

    property bool isExpand: true

    signal expand
    signal compress

    Material.theme: Material.Dark

    Text {
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        width: parent.width
        style: Text.Raised
        text: headerText
        font.weight: Font.DemiBold
        font.pixelSize: 14
        color: Qt.lighter(backgroundColor, 5)
    }

    Rectangle {
        id: imgBackground
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height
        anchors.margins: 4
        color: backgroundColor

        Image {
            anchors.fill: parent
            source: "qrc:/icons/baseline_expand_more_white_36dp.png"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                focus: true
                hoverEnabled: true
                onPressed: {
                    isExpand = !isExpand;
                    parent.source = isExpand ? "qrc:/icons/baseline_expand_more_white_36dp.png" : "qrc:/icons/baseline_expand_less_white_36dp.png";
                    if(isExpand) {
                        expand();
                    }
                    else {
                        compress();
                    }
                }
                onEntered: {
                    imgBackground.color = root.hoverColor;
                }

                onExited: {
                    imgBackground.color = root.selectionColor;
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        height: 1
        color: root.textColor
    }
}
