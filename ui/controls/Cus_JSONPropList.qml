import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ListView {
    id: root

    property string jsonSource: ""
    property color textColor: "#ffffff"
    property color selectionColor: "#212121"
    property color hoverColor: "#000000"
    property color backgroundColor: "#000000"
    property string qureyString: ""

    signal propertyChanged(var propertyName, var val, var propertyType)

    clip: true
    spacing: 6
    focus: true
    currentIndex: 0

    JSONListModel {
        id: jsonModel
        source: jsonSource

        query: qureyString
    }

    model: jsonModel.model

    delegate: Rectangle {
        width: ListView.view.width
        height: 30
        color: root.backgroundColor

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            focus: true
            propagateComposedEvents: true

            onEntered: {
                parent.color = root.hoverColor;
            }

            onExited: {
                parent.color = root.backgroundColor
            }
        }

        Text {
            anchors.fill: parent
            color: root.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: qsTr(model.title)
            clip: true
            font.underline: true
        }

        Loader {
            id: loader
            anchors.right: parent.right
            height: parent.height
            width: 130
        }

        Connections {
            target: loader.item
            function onPropertyValueChanged(propertyName, val, propertyType) {
                propertyChanged(propertyName, val, propertyType);
            }
        }

        Component.onCompleted: {
            if(model.type === "string") {
                loader.setSource("qrc:/controls/Cus_Label.qml", {
                                 "propertyName": model.title,
                                 "color": textColor,
                                 "text": model.data
                                 });
            }
            else if(model.type === "number") {
                loader.setSource("qrc:/controls/Cus_FloatSpinBox.qml", {
                                 "propertyName": model.title,
                                 "editable": model.editable,
                                 "value": model.data * 100
                                 });
            }
            else if(model.type === "bool") {
                loader.setSource("qrc:/controls/Cus_CheckBox.qml", {
                                 "propertyName": model.title,
                                 "checked": model.data,
                                 });
            }
            else if(model.type === "enum") {
                loader.setSource("qrc:/controls/Cus_EnumBox.qml", {
                                 "editable": model.editable,
                                 "model": model.model
                                 });
            }
        }
    }
}
