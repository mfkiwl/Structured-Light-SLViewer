import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

SpinBox {
    id:root

    value: 0 * 100
    from: -100000 * 100
    to: 100000 * 100
    stepSize: 100

    property string propertyName: ""
    signal propertyValueChanged(var propertyName, var val, var propertyType)

    validator: DoubleValidator {
        bottom: Math.min(root.from, root.to)
        top:  Math.max(root.from, root.to)
    }

    textFromValue: function(value, locale) {
        return Number(value / 100).toLocaleString(locale, 'f', 2)
    }

    valueFromText: function(text, locale) {
        return Number.fromLocaleString(locale, text) * 100
    }

    onValueChanged: {
        propertyValueChanged(propertyName, root.value / 100, "number");
    }

    contentItem: TextInput {
        text: root.textFromValue(root.value, root.locale)
        font.pointSize: 10
        color: "white"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !root.editable
        validator: root.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }
}
