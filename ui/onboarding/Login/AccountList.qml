import QtQuick 2.13
import QtQuick.Controls 2.13
import "./samples/"
import "../../imports"

ListView {
    property var accounts: AccountsData {}
    property var isSelected: function () {}
    property var onAccountSelect: function () {}

    id: addressesView
    anchors.fill: parent
    model: accounts
    focus: true
    spacing: Theme.smallPadding

    delegate: AddressView {
        username: model.username
        address: model.address
        identicon: model.identicon
        isSelected: function (index, address) {
            return addressesView.isSelected(index, address)
        }
        onAccountSelect: function (index) {
            addressesView.onAccountSelect(index)
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
