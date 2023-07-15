import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

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
