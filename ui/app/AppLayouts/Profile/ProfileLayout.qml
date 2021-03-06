import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../../../imports"
import "../../../shared"
import "./Sections"

SplitView {
    id: profileView
    x: 0
    y: 0
    Layout.fillHeight: true
    Layout.fillWidth: true

    handle: Rectangle {
        implicitWidth: 1
        implicitHeight: 4
        color: Theme.grey
    }

    LeftTab {
        id: leftTab
    }

    StackLayout {
        id: profileContainer
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: leftTab.right
        anchors.leftMargin: 0
        currentIndex: leftTab.currentTab

        EnsContainer {}

        ContactsContainer {}

        PrivacyContainer {}

        SyncContainer {}

        LanguageContainer {}

        NotificationsContainer {}

        AdvancedContainer {}

        HelpContainer {}

        AboutContainer {}

        SignoutContainer {}
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
