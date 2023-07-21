import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ComboBox {
    Material.theme: Material.Dark
    font.pointSize: 12

    property string propertyName: ""
    signal propertyValueChanged(var propertyName, var val, var propertyType)

    textRole: "name"

    onActivated: function(index) {
        propertyValueChanged(propertyName, index , "number");
    }
}
