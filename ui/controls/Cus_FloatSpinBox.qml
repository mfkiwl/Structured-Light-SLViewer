import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

SpinBox {
    id:root

    value: 0 * 100
    from: -9999999999 * 100
    to: 9999999999 * 100
    stepSize: -1

    property string propertyName: ""
    signal propertyValueChanged(var propertyName, var val, var propertyType)

    validator: DoubleValidator {
        bottom: Math.min(root.from, root.to)
        top: Math.max(root.from, root.to)
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
}
