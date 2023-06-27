import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    property color background: "#000000"
    property color textColor: "#000000"
    property string textString: ""

    Material.theme: Material.Dark

    signal hasClicked(var x, var y)

    Rectangle {
        width: 36
        height: 40
        color: background

        Text {
            anchors.fill: parent
            text: qsTr(textString)
            font.pointSize: 10
            font.bold: true
            font.family: "Arial Black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: textColor
            style: Text.Raised
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                hasClicked(root.x, root.y);
            }
        }
    }
}
