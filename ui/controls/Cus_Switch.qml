import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Switch {
    id: control
    anchors.fill: parent
    checkable: true
    checked: isConnect

    property bool isConnect: false

    Material.theme: Material.Dark
}
