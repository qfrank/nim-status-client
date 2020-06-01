import QtQuick 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11
import QtQuick.Dialogs 1.3
import "../shared"
import "../imports"

SwipeView {
    id: swipeView
    anchors.fill: parent
    currentIndex: 0

    onCurrentItemChanged: {
        currentItem.txtPassword.focus = true;
    }


    Item {
        id: wizardStep1
        property Item txtPassword: txtMnemonic
        width: 620
        height: 427

        Text {
            id: title
            text: "Enter mnemonic"
            font.pointSize: 36
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            color: "#EEEEEE"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.centerIn: parent
            height: 32
            width: parent.width - 40
            TextInput {
                id: txtMnemonic
                anchors.fill: parent
                focus: true
                selectByMouse: true
            }
        }
        StyledButton {
            anchors.right: parent.right
            anchors.rightMargin: Theme.padding
            label: "Next"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.padding
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                console.log("importing mnemonic...", onboardingModel.importMnemonic, txtMnemonic.text)
                const importedAccount = onboardingModel.importMnemonic(txtMnemonic.text);
                console.log(">>>>>>> importMnemonic result: ", importedAccount)

                swipeView.incrementCurrentIndex();
            }
        }
    }

    Item {
        id: wizardStep2
        property Item txtPassword: txtPassword

        Text {
            id: step2Title
            text: "Enter password"
            font.pointSize: 36
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: step2Title.bottom
            anchors.topMargin: 30
            Column {
                Image {
                  source: onboardingModel.importedAccount.identicon
                }
            }
            Column {
                Text {
                  text: onboardingModel.importedAccount.username
                }
                Text {
                  text: onboardingModel.importedAccount.address
                  width: 160
                  elide: Text.ElideMiddle
                }

            }
        }

        Rectangle {
            color: "#EEEEEE"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.centerIn: parent
            height: 32
            width: parent.width - 40
            TextInput {
                id: txtPassword
                anchors.fill: parent
                focus: true
                echoMode: TextInput.Password
                selectByMouse: true
            }
        }

        Button {
            text: "Next"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            onClicked: {
                swipeView.incrementCurrentIndex();
            }
        }
    }

    Item {
        id: wizardStep4
        property Item txtPassword: txtConfirmPassword

        Text {
            text: "Confirm password"
            font.pointSize: 36
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            color: "#EEEEEE"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.centerIn: parent
            height: 32
            width: parent.width - 40

            TextInput {
                id: txtConfirmPassword
                anchors.fill: parent
                focus: true
                echoMode: TextInput.Password
                selectByMouse: true
            }
        }

        MessageDialog {
            id: passwordsDontMatchError
            title: "Error"
            text: "Passwords don't match"
            icon: StandardIcon.Warning
            standardButtons: StandardButton.Ok
            onAccepted: {
                txtConfirmPassword.clear();
                swipeView.currentIndex = 1;
                txtPassword.focus = true;
            }
        }

        MessageDialog {
            id: importError
            title: "Error importing account and logging in"
            text: "An error occurred while storing your account and logging in: "
            icon: StandardIcon.Critical
            standardButtons: StandardButton.Ok
        }

        Button {
            text: "Finish"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            onClicked: {
                if (txtConfirmPassword.text != txtPassword.text) {
                    return passwordsDontMatchError.open();
                }
                const result = onboardingModel.storeDerivedAndLogin(txtConfirmPassword.text);
                console.log(">>> storeDerivedAndLogin result: ", result)
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

