import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ComboBox {
    Material.theme: Material.Dark

    property string propertyName: ""
    signal propertyValueChanged(var propertyName, var val, var propertyType)

    onValueChanged: {
        propertyValueChanged(propertyName, currentIndex, "number");
    }
}
