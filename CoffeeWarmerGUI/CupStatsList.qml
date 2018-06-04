import QtQuick 2.9
import QtQuick.Controls 2.2
import "."

ListView {
    id: list
    model: coffeeCupModel
    spacing: 5
    clip: true

    delegate:
        Rectangle {
            id: base
            width: ListView.view.width; height: statsFlow.height
            clip: true

            border.color: Style.border

            Flow {
                id: statsFlow
//                anchors.fill: parent
                anchors.top: parent.top; //anchors.bottom: parent.bottom
                anchors.left: parent.left; anchors.right: parent.right
                height: lastStat.y + lastStat.height + 20
                anchors.margins: 10
                spacing: 30

                Text {
                    text: "<b>Date: </b>" + date
                    font.pointSize: 12
                }
                Text {
                    text: "<b>Start Time: </b>" + startTime
                    font.pointSize: 12
                }
                Text {
                    text: "<b>End Time: </b>" + endTime
                    font.pointSize: 12
                }
                Text {
                    text: "<b>Duration: </b>" + duration
                    font.pointSize: 12
                }
                Text {
                    text: "<b>Min Temp: </b>" + minTemp + " [\u2103]"
                    font.pointSize: 12
                }
                Text {
                    text: "<b>Max Temp: </b>" + maxTemp + " [\u2103]"
                    font.pointSize: 12
                }
                Text {
                    id: lastStat
                    text: "<b>Average Temp: </b>" + avgTemp.toFixed(2) + " [\u2103]"
                    font.pointSize: 12
                }
            }
        }
}
