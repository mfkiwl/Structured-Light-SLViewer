import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Label {
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignRight
    clip: true

    Material.theme: Material.Dark

    property string propertyName: ""

    signal propertyValueChanged(var propertyName, var value)
}
