import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

CheckBox {
    id: root

    Material.theme: Material.Dark
    
    property string propertyName: ""
    signal propertyValueChanged(var propertyName, var val, var propertyType)

    contentItem: Text {
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Enable")
        color: "white"
    }

    onCheckStateChanged: {
        propertyValueChanged(propertyName, root.checkState === Qt.Checked, "bool");
    }
}
