import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import "../../../../imports"

Item {
    id: helpContainer
    width: 200
    height: 200
    Layout.fillHeight: true
    Layout.fillWidth: true

    function linkify(inputText) {
        var replacedText;

        //URLs starting with http://, https://, or ftp://
        var replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
        replacedText = inputText.replace(replacePattern1, "<a href='$1'>$1</a>");

        //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
        var replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
        replacedText = replacedText.replace(replacePattern2, "$1<a href='http://$2'>$2</a>");

        console.log(replacedText)
        return replacedText;
    }


    Text {
        id: element8
        text: qsTr("Help menus: FAQ, Glossary, etc.")
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 24
        font.weight: Font.Bold
        font.pixelSize: 20
    }

    Text {
        anchors.centerIn: parent
        text: linkify("hello https://status.im/docs/FAQs.html dude")
        onLinkActivated: Qt.openUrlExternally(link)

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        }
    }
}