import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    color: backgroundColor

    property color selectionColor: "#212121"
    property color hoverColor: "#000000"
    property color backgroundColor: "#000000"
    property string jsonSource: ""
    property color textColor: "#ffffff"

    signal propertyListValChanged(var propertyName, var val, var propertyType)

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        Cus_ListHeader {
            Layout.preferredHeight: 24
            Layout.preferredWidth: parent.width
            selectionColor: root.selectionColor
            hoverColor: root.hoverColor
            textColor: root.textColor
            backgroundColor: root.backgroundColor
            headerText: "相机信息"

            onCompress: {
                cameraInfoList.visible = 0;
            }
            onExpand: {
                cameraInfoList.visible = 1;
            }
        }

        Cus_JSONPropList {
            id: cameraInfoList
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width
            jsonSource: root.jsonSource
            textColor: root.textColor
            hoverColor: root.hoverColor
            backgroundColor: root.backgroundColor
            qureyString: "$.camera.info[*]"

            onPropertyChanged: function(propertyName, val, propertyType) {
                propertyListValChanged(propertyName, val, propertyType);
            }
        }

        Cus_ListHeader {
            Layout.preferredHeight: 24
            Layout.preferredWidth: parent.width
            selectionColor: root.selectionColor
            hoverColor: root.hoverColor
            textColor: root.textColor
            backgroundColor: root.backgroundColor
            headerText: "预处理"

            onCompress: {
                preProcessList.visible = 0;
            }
            onExpand: {
                preProcessList.visible = 1;
            }
        }

        Cus_JSONPropList {
            id: preProcessList
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width
            jsonSource: root.jsonSource
            textColor: root.textColor
            hoverColor: root.hoverColor
            backgroundColor: root.backgroundColor
            qureyString: "$.camera.preProcess[*]"

            onPropertyChanged: function(propertyName, val, propertyType) {
                propertyListValChanged(propertyName, val, propertyType);
            }
        }

        Cus_ListHeader {
            Layout.preferredHeight: 24
            Layout.preferredWidth: parent.width
            selectionColor: root.selectionColor
            hoverColor: root.hoverColor
            textColor: root.textColor
            backgroundColor: root.backgroundColor
            headerText: "后处理"

            onCompress: {
                afterProcessList.visible = 0;
            }
            onExpand: {
                afterProcessList.visible = 1;
            }
        }

        Cus_JSONPropList {
            id: afterProcessList
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width
            jsonSource: root.jsonSource
            textColor: root.textColor
            hoverColor: root.hoverColor
            backgroundColor: root.backgroundColor
            qureyString: "$.camera.afterProcess[*]"

            onPropertyChanged: function(propertyName, val, propertyType){
                propertyListValChanged(propertyName, val, propertyType);
            }
        }
    }

    states : [
        State {
            name: "expand"
            PropertyChanges {
                target: root
                //height: root.parent.height
                //opacity: 1
            }
        },
        State {
            name: "normal"
            PropertyChanges {
                target: root
                //height: 0
                //opacity: 0
            }
        }
    ]
}
