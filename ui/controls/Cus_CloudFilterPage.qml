import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Window {
    width: 320
    height: 480
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    visible: true
    title: "cloud filter"
    flags: Qt.WindowCloseButtonHint | Qt.Dialog

    Material.theme: Material.Dark

    color: Material.background

    signal filterCloudPressed(var stdThreshold, var meanK)

    GroupBox {
        id: staticRemoval
        anchors.fill: parent
        anchors.margins: 12
        anchors.bottomMargin: 200
        focus: true
        title: "Static removal"

        ColumnLayout {
            anchors.fill: parent

            Rectangle {
                Layout.preferredHeight: 50
                Layout.preferredWidth: parent.width
                color: Material.background

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: 50
                    width: 100
                    text: "std threshold"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Cus_FloatSpinBox {
                    id: stdThreshold
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 180
                    value: 1 * 100
                }
            }

            Rectangle {
                Layout.preferredHeight: 50
                Layout.preferredWidth: parent.width
                color: Material.background

                Label {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: 50
                    width: 100
                    text: "mean K"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Cus_FloatSpinBox {
                    id: meanK
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 50
                    width: 180
                    value: 50 * 100
                }
            }
        }
    }

    Button {
        id: filterButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: 50
        anchors.margins: 12
        text: "filter!"

        onClicked: {
            filterCloudPressed(stdThreshold.value / 100.0, meanK.value / 100.0)
        }
    }
}
