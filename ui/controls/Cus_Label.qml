import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Label {
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignRight
    clip: true
    font.bold: true
    font.pointSize: 10

    Material.theme: Material.Dark

    property string propertyName: ""

    signal propertyValueChanged(var propertyName, var value)
}
