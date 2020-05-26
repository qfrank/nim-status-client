import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1
import "../../../imports"
import "./components"

Item {
    property alias chatGroupsListViewCount: chatGroupsListView.count
    property alias searchStr: searchText.text

    id: contactsColumn
    width: 300
    height: parent.height
    Layout.minimumWidth: 200

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 100
            Layout.fillHeight: false
            Layout.fillWidth: true

            Text {
                id: element
                x: 772
                text: qsTr("Chat")
                anchors.top: parent.top
                anchors.topMargin: 17
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 17
            }

            Rectangle {
                id: searchBox
                height: 36
                color: Theme.grey
                anchors.top: parent.top
                anchors.topMargin: 59
                radius: 8
                anchors.right: parent.right
                anchors.rightMargin: 65
                anchors.left: parent.left
                anchors.leftMargin: 16

                TextField {
                    id: searchText
                    placeholderText: qsTr("Search or join channel")
                    anchors.left: parent.left
                    anchors.leftMargin: 32
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 12
                    background: Rectangle {
                        color: "#00000000"
                    }
                }

                Image {
                    id: image4
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "../../img/search.svg"
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked : {
                        searchText.forceActiveFocus(Qt.MouseFocusReason)
                    }
                }
            }

            Rectangle {
                id: addChat
                width: 36
                height: 36
                color: Theme.blue
                radius: 50
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.top: parent.top
                anchors.topMargin: 59

                Text {
                    id: element3
                    color: "#ffffff"
                    text: qsTr("+")
                    anchors.verticalCenterOffset: -1
                    anchors.horizontalCenterOffset: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    lineHeight: 1
                    fontSizeMode: Text.FixedSize
                    font.bold: true
                    font.pixelSize: 28
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked : {
                        chatGroupsListView.currentIndex = chatsModel.joinChat(searchText.text);
                        searchText.text = "";
                    }
                }
            }
        }

        StackLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            currentIndex: chatGroupsListView.count > 0 ? 1 : 0
            Item {
                id: element1
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Row {
                        id: description
                        Layout.fillHeight: false
                        Layout.fillWidth: true
                        width: parent.width

                        Text {
                            width: parent.width
                            text: qsTr("Follow your interests in one of the many Public Chats.")
                            font.pointSize: 15
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            fontSizeMode: Text.FixedSize
                            renderType: Text.QtRendering
                            onLinkActivated: console.log(link)
                        }
                    }

                    RowLayout {
                        id: row
                        Layout.fillHeight: false
                        Layout.fillWidth: true
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.top: description.bottom
                        anchors.topMargin: 20

                        Flow {
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            spacing: 6

                            SuggestedChannel { channel: "introductions" }
                            SuggestedChannel { channel: "chitchat" }
                            SuggestedChannel { channel: "status" }
                            SuggestedChannel { channel: "crypto" }
                            SuggestedChannel { channel: "tech" }
                            SuggestedChannel { channel: "music" }
                            SuggestedChannel { channel: "movies" }
                            SuggestedChannel { channel: "test" }
                            SuggestedChannel { channel: "test2" }
                        }
                    }
                }
            }

            Item {
                Component {
                    id: chatViewDelegate

                    Rectangle {
                        id: wrapper
                        color: ListView.isCurrentItem ? Theme.lightBlue : Theme.transparent
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.padding
                        anchors.top: applicationWindow.top
                        anchors.topMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.padding
                        radius: 8
                        // Hide the box if it is filtered out
                        property bool isVisible: searchStr == "" || name.includes(searchStr)
                        visible: isVisible ? true : false
                        height: isVisible ? 64 : 0

                        MouseArea {
                            cursorShape: Qt.PointingHandCursor;
                            anchors.fill: parent
                            onClicked: {
                                chatsModel.setActiveChannelByIndex(index)
                                chatGroupsListView.currentIndex = index
                            }
                        }

                        Rectangle {
                            id: contactImage
                            width: 40
                            color: Theme.darkGrey
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.padding
                            anchors.top: parent.top
                            anchors.topMargin: 12
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 12
                            radius: 50
                        }

                        Text {
                            id: contactInfo
                            text: name
                            anchors.right: contactTime.left
                            anchors.rightMargin: Theme.smallPadding
                            elide: Text.ElideRight
                            font.weight: Font.Medium
                            font.pixelSize: 15
                            anchors.left: contactImage.right
                            anchors.leftMargin: Theme.padding
                            anchors.top: parent.top
                            anchors.topMargin: Theme.smallPadding
                            color: "black"
                        }
                        Text {
                            id: lastChatMessage
                            text: lastMessage || qsTr("No messages")
                            anchors.right: contactNumberChatsCircle.left
                            anchors.rightMargin: Theme.smallPadding
                            elide: Text.ElideRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: Theme.smallPadding
                            font.pixelSize: 15
                            anchors.left: contactImage.right
                            anchors.leftMargin: Theme.padding
                            color: Theme.darkGrey
                        }
                        Text {
                            id: contactTime
                            text: timestamp
                            anchors.right: parent.right
                            anchors.rightMargin: Theme.padding
                            anchors.top: parent.top
                            anchors.topMargin: Theme.smallPadding
                            font.pixelSize: 11
                            color: Theme.darkGrey
                        }
                        Rectangle {
                            id: contactNumberChatsCircle
                            width: 22
                            height: 22
                            radius: 50
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: Theme.smallPadding
                            anchors.right: parent.right
                            anchors.rightMargin: Theme.padding
                            color: Theme.blue
                            visible: unviewedMessagesCount > 0
                            Text {
                                id: contactNumberChats
                                text: unviewedMessagesCount
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                            }
                        }
                    }
                }

                ListView {
                    id: chatGroupsListView
                    anchors.topMargin: 24
                    anchors.fill: parent
                    model: chatsModel.chats
                    delegate: chatViewDelegate
                }
            }
        }
    }

}


/*##^##
Designer {
    D{i:0;height:770;width:300}
}
##^##*/
