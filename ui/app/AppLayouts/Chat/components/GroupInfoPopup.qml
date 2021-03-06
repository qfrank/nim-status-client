import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../../../../imports"
import "../../../../shared"
import "./"

ModalPopup {
    id: popup

    header: Item {
      height: children[0].height
      width: parent.width

      Rectangle {
          id: letterIdenticon
          width: 36
          height: 36
          radius: 50
          anchors.top: parent.top
          anchors.topMargin: Theme.padding
          color: chatsModel.activeChannel.color
  
          StyledText {
            text: chatsModel.activeChannel.name.charAt(0).toUpperCase();
            opacity: 0.7
            font.weight: Font.Bold
            font.pixelSize: 21
            color: Theme.white
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
          }
      }
    
      StyledTextEdit {
          id: groupName
          text: chatsModel.activeChannel.name
          anchors.top: parent.top
          anchors.topMargin: 18
          anchors.left: letterIdenticon.right
          anchors.leftMargin: Theme.smallPadding
          font.bold: true
          font.pixelSize: 14
          readOnly: true
          wrapMode: Text.WordWrap
      }

      StyledText {
          text: {
            let cnt = chatsModel.activeChannel.members.rowCount();
            if(cnt > 1) return qsTr("%1 members").arg(cnt);
            return qsTr("1 member");
          }
          width: 160
          anchors.left: letterIdenticon.right
          anchors.leftMargin: Theme.smallPadding
          anchors.top: groupName.bottom
          anchors.topMargin: 2
          font.pixelSize: 14
          color: Theme.darkGrey
      }

      Rectangle {
            id: editGroupNameBtn
            visible: chatsModel.activeChannel.isAdmin(profileModel.profile.pubKey)
            height: 24
            width: 24
            anchors.top: parent.top
            anchors.topMargin: Theme.padding
            anchors.leftMargin: 4
            anchors.left: groupName.right
            radius: 8

            Image {
                id: editGroupImg
                source: "../../../img/edit-group.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: closeModalMouseArea
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                hoverEnabled: true
                onExited: {
                    editGroupNameBtn.color = Theme.white
                }
                onEntered: {
                    editGroupNameBtn.color = Theme.grey
                }
                onClicked: renameGroupPopup.open()
            }
        }

        RenameGroupPopup {
            id: renameGroupPopup
        }
    }


    Item {
        id: container
        anchors.fill: parent

        StyledText {
            id: memberLabel
            text: qsTr("Members")
            anchors.left: parent.left
            anchors.leftMargin: Theme.padding
            font.pixelSize: 15
            color: Theme.darkGrey
        }

        ListModel {
            id: exampleModel

            ListElement {
                isAdmin: false
                joined: true
                identicon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
                userName: "The UserName"
                pubKey: "0x12345678"
            }

            ListElement {
                isAdmin: false
                joined: true
                identicon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
                userName: "The UserName"
                pubKey: "0x12345678"
            }

            ListElement {
                isAdmin: false
                joined: true
                identicon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
                userName: "The UserName"
                pubKey: "0x12345678"
            }
        }

        ListView {
            id: memberList
            anchors.fill: parent
            anchors.top: memberLabel.bottom
            anchors.bottom: popup.bottom
            anchors.topMargin: 30
            anchors.bottomMargin: Theme.padding
            spacing: 4
            Layout.fillWidth: true
            Layout.fillHeight: true
            //model: exampleModel
            model: chatsModel.activeChannel.members
            delegate: Row {
                Column {
                    Image {
                        source: model.identicon
                    }
                }
                Column {
                    StyledText {
                        text: model.userName
                        width: 300
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        font.pixelSize: 13
                    }
                }
                Column {
                    StyledText {
                        visible: model.isAdmin
                        text: qsTr("Admin")
                        width: 100
                        font.pixelSize: 13
                    }
                    StyledText {
                        id: moreActionsBtn
                        visible: !model.isAdmin && chatsModel.activeChannel.isAdmin(profileModel.profile.pubKey)
                        text: "..."
                        width: 100
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                contextMenu.popup(moreActionsBtn.x - moreActionsBtn.width, moreActionsBtn.height + 10)
                            }
                            cursorShape: Qt.PointingHandCursor
                            PopupMenu {
                                id: contextMenu
                                Action {
                                    icon.source: "../../../img/make-admin.svg"
                                    text: qsTr("Make Admin")
                                    onTriggered: chatsModel.leaveActiveChat()
                                }
                                Action {
                                    icon.source: "../../../img/remove-from-group.svg"
                                    icon.color: Theme.red
                                    text: qsTr("Remove From Group")
                                    onTriggered: chatsModel.leaveActiveChat()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
