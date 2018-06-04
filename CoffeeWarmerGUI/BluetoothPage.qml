import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtBluetooth 5.9
import "."

Rectangle {
    id: bluetoothPage
    clip: true

    property bool btRunning: false
    property int listCurrentIndex: -1

    Text {
        id: btPageHeader
        anchors.top: parent.top; anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: btSocket.connected ? "Connected" : "Not Con."//btSocket.stringData//"Bluetooth Page"
        font.pointSize: 48
    }

    BluetoothDiscoveryModel {
        id: btModel
        running: btRunning
        discoveryMode: BluetoothDiscoveryModel.FullServiceDiscovery
        remoteAddress: "00:0E:EA:CF:2F:7B"

        onServiceDiscovered: {
            btSocket.service = service
        }
    }

    BluetoothSocket {
        id: btSocket
        connected: true

        onStringDataChanged: {
            console.log("recieved data...")
            btPageHeader.text = btSocket.stringData
        }
    }

    RowLayout {
        id: btControlsRegion
        anchors.top: btPageHeader.bottom; anchors.topMargin: 20
        anchors.left: parent.left; anchors.right: parent.right
        height: 40
        spacing: 20

        Rectangle {
            id: btStartSearchBtn
            Layout.leftMargin: 20
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 2
            border.color: Style.border

            enabled: !btRunning
            opacity: !btRunning ? 1 : 0.5

            Text {
                anchors.centerIn: parent
                text: "Search"
                font.pointSize: 18; minimumPointSize: 12
                //fontSizeMode: Text.fit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    btRunning = true
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
            id: btStartStopBtn
            Layout.rightMargin: 20
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 2
            border.color: Style.border

            enabled: btRunning
            opacity: btRunning ? 1 : 0.5

            Text {
                anchors.centerIn: parent
                text: "Stop"
                font.pointSize: 18; minimumPointSize: 12
                //fontSizeMode: Text.fit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    btRunning = false
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

    ListView {
        id: btDeviceList
        model: btModel

        anchors.top: btControlsRegion.bottom; anchors.bottom: btSelectionControlsRegion.top
        anchors.left: parent.left; anchors.right: parent.right
        anchors.margins: 20
        clip: true

        focus: true

        delegate: Rectangle {
            id: btDelegate
            width: parent.width
            height: column.height + 10

            property bool expended: false;
            clip: true

            Rectangle {
                id: listStartDot
                anchors.top: parent.top; anchors.topMargin: 7
                anchors.left: parent.left;
                height: 4; width: 4; radius: 2
                color: (listCurrentIndex == index) ? "red" : "black"
            }

            Column {
                id: column
                anchors.left: listStartDot.right; anchors.rightMargin: 10
                anchors.leftMargin: 5
                Text {
                    id: bttext
                    text: deviceName ? deviceName : name
                    color: ListView.isCurrentItem ? "red" : "black"
                    font.family: "FreeSerif"
                    font.pointSize: 16
                }

                Text {
                    id: details
                    function get_details(s) {
                        if (btModel.discoveryMode == BluetoothDiscoveryModel.DeviceDiscovery) {
                            //We are doing a device discovery
                            var str = "Address: " + remoteAddress;
                            return str;
                        } else {
                            var str = "Address: " + s.deviceAddress;
                            if (s.serviceName) { str += "<br>Service: " + s.serviceName; }
                            if (s.serviceDescription) { str += "<br>Description: " + s.serviceDescription; }
                            if (s.serviceProtocol) { str += "<br>Protocol: " + s.serviceProtocol; }
                            return str;
                        }
                    }
                    visible: opacity !== 0
                    opacity: btDelegate.expended ? 1 : 0.0
                    text: get_details(service)
                    font.family: "FreeSerif"
                    font.pointSize: 14
                    Behavior on opacity {
                        NumberAnimation { duration: 200}
                    }
                }
            }
            Behavior on height { NumberAnimation { duration: 200} }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    btDelegate.expended = !btDelegate.expended
                    listCurrentIndex = index
                }
            }

        }
    }

    RowLayout {
        id: btSelectionControlsRegion
        anchors.bottom: parent.bottom; anchors.bottomMargin: 20
        anchors.left: parent.left; anchors.right: parent.right
        height: 40
        spacing: 20

        Rectangle {
            id: btConnectBtn
            Layout.leftMargin: 20
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 2
            border.color: Style.border

            Text {
                anchors.centerIn: parent
                text: "Send1"
                font.pointSize: 18; minimumPointSize: 12
                //fontSizeMode: Text.fit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    btSocket.stringData = "1"
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
            id: btDisconnectBtn
            Layout.rightMargin: 20
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 2
            border.color: Style.border

            Text {
                anchors.centerIn: parent
                text: "Send0"
                font.pointSize: 18; minimumPointSize: 12
                //fontSizeMode: Text.fit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    btSocket.stringData = "0"
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
            id: btTestBtn
            Layout.rightMargin: 20
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 2
            border.color: Style.border

            Text {
                anchors.centerIn: parent
                text: "test"
                color: "red"
                font.pointSize: 18; minimumPointSize: 12
                //fontSizeMode: Text.fit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("error: " + btSocket.error.toString())
                    console.log("state: " + btSocket.socketState)
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
