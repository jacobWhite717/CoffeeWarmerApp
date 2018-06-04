import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtBluetooth 5.9
import "."

// see about making a dialog for confirmation on deleting all records

ApplicationWindow {
    id: app
    visible: true
//    visibility: "Maximized"
    width: 1080//Screen.desktopAvailableWidth
    height: 2220//Screen.desktopAvailableHeight
    title: qsTr("Coffee Warmer App")

    property bool celciusScale: true
    property int targetTemp: 50
    property int currentTemp: 0

    SwipeView {
        id: mainView

        currentIndex: 1
        anchors.fill: parent

//        Rectangle {
//            id: bluetoothPage
//            clip: true
//            Text {
//                anchors.top: parent.top; anchors.topMargin: 20
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: "Bluetooth Page"
//                font.pointSize: 48
//            }

//            BluetoothDiscoveryModel {
//                id: btModel
//                running: true
//                discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
//            }
//        }
        BluetoothPage {}

        CurrentCupPage {}

        Rectangle {
            id: lifetimeStatsPage
            clip: true

            Text {
                id: lifetimeStatsHeader
                anchors.top: parent.top; anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 40
                text: "Lifetime Coffee Cup Stats"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 48; minimumPointSize: 12
                fontSizeMode: Text.Fit
            }

            CupStatsList {
                id: statsList
                anchors.margins: 20
                anchors.top: lifetimeStatsHeader.bottom
                anchors.bottom: parent.bottom; anchors.bottomMargin: 80
                anchors.left: parent.left
                anchors.right: parent.right
            }

            Rectangle {
                id: deleteRecords
                anchors.top: statsList.bottom; anchors.topMargin: 20
                anchors.left: parent.left; anchors.leftMargin: 20
                anchors.right: parent.right; anchors.rightMargin: 20
                height: 40; radius: 5
                border.color: Style.border

                Text {
                    anchors.centerIn: parent
                    text: "Reset Data"
                    font.pointSize: 18
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        coffeeCupModel.resetRecords()
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

    PageIndicator {
        id: indicator

        count: mainView. count
        currentIndex: mainView.currentIndex

        anchors.bottom: mainView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
