import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.0
import "."

//REMEMBER TO CHANGE THE TIMER VALUES BACK TO NORMAL WHEN NOT TESTING

ScrollView {
    id: currentCupPage
    clip: true

    width: app.width; height: parent.height
    contentWidth: width; contentHeight: (chartStatRegion.y + chartStatRegion.height + 30)

    //temperature setting values
    property bool celciusScale: true
    property int currentTemp: 0
    property int targetTemp: 50

    //ongoing cup variables
    property bool cupGoing: false // is there a current cup active?
    property int chartTimeCounter: 0

    function updateStats() {
        currentDate.text = "<b>Date: </b>" + coffeeCupModel.getDate()
        currentStartTime.text = "<b>Start Time: </b>" + coffeeCupModel.getStartTime()
        currentMinTemp.text = "<b>Min Temp: </b>" + coffeeCupModel.getMinTemp()
        currentDuration.text = "<b>Duration: </b>" + intToTime(chartTimeCounter)
        currentMaxTemp.text = "<b>Max Temp: </b>" + coffeeCupModel.getMaxTemp()
        currentAvgTemp.text = "<b>Average Temp: </b>" + coffeeCupModel.getAvgTemp().toFixed(2)
    }

    function intToTime(totalSeconds) { // converts "s" to "m:ss"
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return (minutes + ":" + (seconds < 10 ? ("0"+seconds) : seconds))
    }

    function resetChart() {
        temperatureSeries.removePoints(0, temperatureSeries.count)
        chartTimeCounter = 0
        xAxis.min = 0
        xAxis.max = 600
    }

    Timer { // when bluetooth is available, have this timer poll for currentTemp data (5s) rather than having a random value
        interval: 1000; running: cupGoing; repeat: true; triggeredOnStart: true
        onTriggered: {
            currentTemp = Math.random()*((targetTemp+5)-(targetTemp-5))+targetTemp-5
            coffeeCupModel.enterCurrentTemp(currentTemp)
            updateStats()

            temperatureSeries.append(chartTimeCounter, currentTemp)
            if (chartTimeCounter > 600) {
                xAxis.min = xAxis.min + 60
                xAxis.max = xAxis.max + 60
            }
            chartTimeCounter = chartTimeCounter + 60
        }
    }

    Rectangle {
        id: currentCupHeader
        anchors.top: parent.top; anchors.topMargin: 20
        anchors.left: parent.left
        width: parent.width; height: currentCupHeaderText.height + 60

        Text {
            id: currentCupHeaderText
            anchors.top: parent.top
            anchors.left: parent.left; anchors.leftMargin: 20
            anchors.right: parent.right; anchors.rightMargin: 20
            text: "Current Cup Stats"
            font.pointSize: 48; minimumPointSize: 24
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            id: headerBtnLayout
            width: parent.width; height: 40;
            anchors.top: currentCupHeaderText.bottom; anchors.topMargin: 10
            anchors.left: parent.left

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    id: newCupBtn
                    Layout.leftMargin: 20
                    Layout.fillWidth: true; Layout.fillHeight: true
                    border.color: Style.border

                    enabled: !cupGoing
                    opacity: !cupGoing ? 1 : 0.5

                    Text {
                        id: newCupBtnTxt
                        anchors.centerIn: parent
                        text: "Start Cup"
                        font.pointSize: 18; minimumPointSize: 12
                        fontSizeMode: Text.Fit
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cupGoing = true
                            coffeeCupModel.startNewCup()
                            resetChart()
                        }
                        onPressed: {
                            parent.color = Style.sunkenBkg
                        }
                        onReleased: {
                            parent.color = "white"
                        }
                    }
                }

                Rectangle {
                    id: endCupBtn
                    Layout.leftMargin: 10; Layout.rightMargin: 10
                    Layout.fillWidth: true; Layout.fillHeight: true
                    border.color: Style.border

                    enabled: cupGoing
                    opacity: cupGoing ? 1 : 0.5

                    Text {
                        id: endCupBtnTxt
                        anchors.centerIn: parent
                        text: "End Cup"
                        font.pointSize: 18; minimumPointSize: 12
                        fontSizeMode: Text.Fit
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cupGoing = false
                            coffeeCupModel.endCurrentCup()
                        }
                        onPressed: {
                            parent.color = Style.sunkenBkg
                        }
                        onReleased: {
                            parent.color = "white"
                        }
                    }
                }

                Rectangle {
                    id: btConnectBtn
                    Layout.rightMargin: 20
                    width: 40; Layout.fillHeight: true; radius: 2
                    border.color: Style.border

                    Image {
                        anchors.centerIn: parent
                        scale: 2/7
                        source: "qrc:/icons/bluetooth.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {

                        }
                        onPressed: {
                            parent.color = Style.sunkenBkg
                        }
                        onReleased: {
                            parent.color = "white"
                        }
                    }
                }
            }

        }
    }

    Rectangle {
        id: headerControlsDiv
        anchors.top: currentCupHeader.bottom; anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter;
        width: parent.width - 40; height: 2
        color: Style.border
    }

    Rectangle {
        id: controlsRegion
        anchors.top: headerControlsDiv.bottom; anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        height: (temperatureControlsLayout.y + temperatureControlsLayout.height)

        enabled: cupGoing
        opacity: cupGoing ? 1 : 0.5

        RowLayout {
            id: temperatureValuesLayout
            anchors.top: parent.top;
            anchors.left: parent.left; anchors.right: parent.right
            height: 150
            spacing: 0

            ColumnLayout {
                spacing: 10

                Text {
                    id: currentTempHeader
                    Layout.leftMargin: 20; Layout.rightMargin: 10
                    Layout.alignment: Qt.AlignHCenter
                    text: "Current Temp."
                    font.pointSize: 24; minimumPointSize: 12
                    fontSizeMode: Text.Fit
                }

                Rectangle {
                    Layout.leftMargin: 20; Layout.rightMargin: 10
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: Style.sunkenBkg
                    border.color: Style.border

                    Text {
                        anchors.centerIn: parent
                        text: celciusScale ? currentTemp + "\u2103": ((currentTemp * 1.8) + 32).toFixed(1) + "\u2109"
                        font.pointSize: 42; minimumPointSize: 14
                        fontSizeMode: Text.Fit
                    }
                }
            }

            ColumnLayout {
                spacing: 10

                Text {
                    id: targetTempHeader
                    Layout.leftMargin: 10; Layout.rightMargin: 20
                    Layout.alignment: Qt.AlignHCenter
                    text: "Target Temp."
                    font.pointSize: 24; minimumPointSize: 12
                    fontSizeMode: Text.Fit
                }

                Rectangle {
                    Layout.leftMargin: 10; Layout.rightMargin: 20
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: Style.sunkenBkg
                    border.color: Style.border

                    Text {
                        anchors.centerIn: parent
                        text: celciusScale ? targetTemp + "\u2103": ((targetTemp * 1.8) + 32).toFixed(1) + "\u2109"
                        font.pointSize: 42; minimumPointSize: 14
                        fontSizeMode: Text.Fit
                    }
                }


            }
        }

        ColumnLayout {
            id: temperatureControlsLayout
            anchors.top: temperatureValuesLayout.bottom; anchors.topMargin: 10
            anchors.left: parent.left; anchors.right: parent.right
            spacing: 10

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "+/- Target Temperature:"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 18
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    id: targetTempIncBtn
                    width: 30;  height: 30
                    radius: 2
                    border.color: Style.border

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height - 6
                        width: 2
                        color: "black"
                    }
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: 2
                        width: parent.width - 6
                        color: "black"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            targetTemp = targetTemp + 1
                        }
                        onPressed: {
                            parent.color = Style.sunkenBkg
                        }
                        onReleased: {
                            parent.color = "white"
                        }
                    }
                }

                Rectangle {
                    id: targetTempDecBtn
                    width: 30;  height: 30; radius: 2
                    border.color: Style.border

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: 2
                        width: parent.width - 6
                        color: "black"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            targetTemp = targetTemp - 1
                        }
                        onPressed: {
                            parent.color = Style.sunkenBkg
                        }
                        onReleased: {
                            parent.color = "white"
                        }
                    }
                }

                Rectangle {
                    id: targetTempResetBtn
                    width: 30; height: 30; radius: 2
                    border.color: Style.border

                    Image {
                        anchors.centerIn: parent
                        anchors.margins: 1
                        source: "qrc:/icons/resetBtn.png"
                        scale: 0.9
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            targetTemp = 50
                        }
                        onPressed: {
                            parent.color = Style.sunkenBkg
                        }
                        onReleased: {
                            parent.color = "white"
                        }
                    }
                }

            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                text: "Temperature Scale:"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 18
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    width: 30;  height: 30
                    radius: 2
                    color: celciusScale ? Style.sunkenBkg : "white"
                    border.color: Style.border
                    Text {
                        anchors.centerIn: parent
                        text: "\u2103"
                        font.pointSize: parent.height/2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            celciusScale = true
                        }
                    }
                }

                Rectangle {
                    width: 30;  height: 30
                    radius: 2
                    color: celciusScale ? "white" : Style.sunkenBkg
                    border.color: Style.border
                    Text {
                        anchors.centerIn: parent
                        text: "\u2109"
                        font.pointSize: parent.height/2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            celciusScale = false
                        }
                    }
                }
            }

        }
    }

    Rectangle {
        id: controlsCurrentDiv
        anchors.top: controlsRegion.bottom; anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter;
        width: parent.width - 40; height: 2
        color: Style.border
    }

    Rectangle {
        id: chartStatRegion
        anchors.top: controlsCurrentDiv.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: (currentStatsConatiner.y + currentStatsConatiner.height)

        enabled: cupGoing
        opacity: cupGoing ? 1 : 0.5

//        Timer {
//            interval: 1000; running: cupGoing; repeat: true; triggeredOnStart: true
//            onTriggered: {
//                temperatureSeries.append(chartTimeCounter, currentTemp)
//                if (chartTimeCounter > 600) {
//                    xAxis.min = xAxis.min + 60
//                    xAxis.max = xAxis.max + 60
//                }
//                chartTimeCounter = chartTimeCounter + 60
//            }
//        }

        ChartView {
            id: temperatureChart
            anchors.top: chartStatRegion.top; anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40; height: 400
            antialiasing: true
            title: "Coffee Temperature Over the Past 10 Minutes"

            ValueAxis {
                id: xAxis
                titleText: "Time [s]"
                min: 0
                max: 600
                tickCount: 3
                minorTickCount: 4
            }
            ValueAxis {
                id: yAxis
                titleText: "Temperature [\u2103]"
                min: 20
                max: 80
                tickCount: 7
                minorTickCount: 1
            }

            SplineSeries{
                id: temperatureSeries
                name: "Temperature of Coffee"
                axisX: xAxis
                axisY: yAxis
            }
        }

        Text {
            id: currentStatsConatinerHeader
            anchors.top: temperatureChart.bottom; anchors.topMargin: 20
            anchors.left: parent.left; anchors.leftMargin: 30
            text: "Current Cup Stats"
            font.pointSize: 24
        }

        Rectangle {
            id: currentStatsConatiner
            anchors.top: currentStatsConatinerHeader.bottom; anchors.topMargin: 10
            anchors.left: parent.left; anchors.leftMargin: 20
            anchors.right: parent.right; anchors.rightMargin: 20
            height: (currentMaxTemp.y + currentMaxTemp.height + 20); radius: 5
            border.color: Style.border
            border.width: 2

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    id: currentDate
                    Layout.alignment: Qt.AlignCenter
                    text: "<b>Date: </b>"
                    font.pointSize: 14
                }
                Text {
                    id: currentStartTime
                    Layout.alignment: Qt.AlignCenter
                    text: "<b>Start Time: </b>"
                    font.pointSize: 14
                }
                Text {
                    id: currentDuration
                    Layout.alignment: Qt.AlignCenter
                    text: "<b>Duration: </b>"
                    font.pointSize: 14
                }
                Text {
                    id: currentAvgTemp
                    Layout.alignment: Qt.AlignCenter
                    text: "<b>Average Temp: </b>"
                    font.pointSize: 14
                }
                Text {
                    id: currentMinTemp
                    Layout.alignment: Qt.AlignCenter
                    text: "<b>Min Temp: </b>"
                    font.pointSize: 14
                }
                Text {
                    id: currentMaxTemp
                    Layout.alignment: Qt.AlignCenter
                    text: "<b>Max Temp: </b>"
                    font.pointSize: 14
                }
            }
        }
    }

}
