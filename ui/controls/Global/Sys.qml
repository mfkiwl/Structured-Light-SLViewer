pragma Singleton
import QtQuick 2.12
import QtQuick.Controls.Material 2.12

QtObject {
    /*
    property string primary: "#0d99ff"
    property string on_primary: "#ffffff"
    property string secondary: "#2c2c2c"
    property string on_secondary: "#ffffff"
    property string tertiary: "#848280"
    property string on_tertiary: "#492532"
    property string error: "#f24822"
    property string outline: "#601410"
    property string background: "#f5f5f5"
    property string on_background: "#2c2c2c"
    property string fore: "#1e1e1e"
    property string on_fore: "#ffffff"
    property string shadow: "#000000"
    property string connect: "#00ff00"
    property string disConnect: "#8e8f83"
    */
    Material.theme: Material.Dark

    property string primary: Material.primary
    property string on_primary: Material.primaryHighlightedTextColor
    property string secondary: Material.accent
    property string on_secondary: Material.primaryHighlightedTextColor
    property string tertiary: Material.buttonColor
    property string on_tertiary: Material.primary
    property string error: Material.Red
    property string outline: Material.dropShadowColor
    property string background: Material.background
    property string on_background: Qt.lighter(Material.background, 1.3)
    property string fore: Material.background
    property string on_fore: "white"
    property string shadow: Material.dropShadowColor
    property string connect: "green"
    property string disConnect: Material.dropShadowColor
}
