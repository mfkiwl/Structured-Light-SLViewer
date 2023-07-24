import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.15

import "../../../controls/Global/"

Rectangle {
    id: rootRec
    color: Material.background
    clip: true

    ChartView {
        id: chartView
        title: "The zero point of target's error distribution"
        anchors.fill: parent
        legend.visible: true
        antialiasing: true
        theme: ChartView.ChartThemeDark

        ValueAxis {
            id: valueAxisX
            min: 0
            max: 20
        }

        ValueAxis {
            id: valueAxisError
            min: -5
            max: 5
        }

        LineSeries {
            id: seriesRmseLine
            axisX: valueAxisX
            axisY: valueAxisError
            style: Qt.SolidLine
            color: "blue"
        }

        LineSeries {
            id: seriesErrorLine
            axisX: valueAxisX
            axisY: valueAxisError
            style: Qt.DashLine
            color: "red"

        }
    }

    Connections {
        target: GlobalSignals

        function onCalibrateFinish(errorList) {
            valueAxisX.min = 0;
            valueAxisX.max = errorList.length + 1;

            var minError = -1, maxError = 9999999;
            for (var i = 0; i < errorList.length - 1; ++i) {
                seriesRmseLine.append(i + 1, errorList[errorList - 1]);
                seriesErrorLine.append(i + 1, errorList[i]);
                minError = minError < errorList[i] ? minError : errorList[i];
                maxError = maxError > errorList[i] ? maxError : errorList[i];
            }

            valueAxisError.min = minError - 1;
            valueAxisError.max = minError + 1;
        }
    }
}
