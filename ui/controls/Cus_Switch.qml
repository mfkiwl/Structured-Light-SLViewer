import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Switch {
    id: control
    anchors.fill: parent
    checkable: true
    checked: isConnect

    property bool isConnect: false

    Material.theme: Material.Dark
}
