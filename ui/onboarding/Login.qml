import QtQuick 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3

SwipeView {
  id: swipeView
  anchors.fill: parent
  currentIndex: 0

  signal loginResult(response: var)

  ListModel {
    id: accountsModel
  }

  // handle the serialised result coming from node and deserialise into JSON
  // TODO: maybe we should figure out a clever to avoid this?
  Component.onCompleted: {
    const strAccounts = onboardingLogic.getAccounts();
    console.log(">>>>>>>>> Component.onCompleted, strAccounts: ", strAccounts);
    if (!strAccounts) {
      return;
    }
    const accounts = JSON.parse(strAccounts);
    accountsModel.clear();
    accounts.forEach(acc => {
      accountsModel.append({
        name: acc.name,
        "key-uid": acc["key-uid"],
        photoPath: acc["photo-path"]
      });
    });
  }

  Item {
    id: loginSelectAccount
    property int selectedIndex: 0

    Text {
      text: "Login"
      font.pointSize: 36
      anchors.top: parent.top
      anchors.topMargin: 20
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Item {
      anchors.top: parent.top
      anchors.topMargin: 50

      Repeater {
        model: accountsModel
        Rectangle {
          height: 32
          width: 32
          anchors.leftMargin: 20
          anchors.rightMargin: 20
          Row {
            RadioButton {
              checked: index == 0 ? true : false
              onClicked: {
                loginSelectAccount.selectedIndex = index;
                swipeView.incrementCurrentIndex()
              }
            }
            Column {
              Image {
                source: photoPath
              }
            }
            Column {
              Text {
                text: name
              }
            }
          }
        }
      }
    }
  }

  Item {
    id: loginPassword
    property Item txtPassword: txtPassword

    Text {
      text: "Enter password"
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
        id: txtPassword
        anchors.fill: parent
        focus: true
        echoMode: TextInput.Password
        selectByMouse: true
      }
    }

    MessageDialog {
      id: loginError
      title: "Login error"
      text: "An error occurred while logging in: "
      icon: StandardIcon.Warning
      standardButtons: StandardButton.Ok
    }

    Button {
      text: "Login"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 20
      onClicked: {
        console.log("password: " + txtPassword.text);

        const acctDataModel = accountsModel.get(loginSelectAccount.selectedIndex);
        const acctData = {
          name: acctDataModel.name,
          "key-uid": acctDataModel["key-uid"],
          "photo-path": acctDataModel.photoPath
        }
        console.log(">>>>>>>>> login with: ", JSON.stringify(acctData), txtPassword.text);
        const loginResponse = onboardingLogic.login(JSON.stringify(acctData), txtPassword.text);
        console.log(">>>>>>>>> login response: ", loginResponse);
        const response = JSON.parse(loginResponse);
          if (response.error) {
            loginError.text += response.error;
            return loginError.open();
          }
          swipeView.loginResult(response);
      }
    }
  }
}