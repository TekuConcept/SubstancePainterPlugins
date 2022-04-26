import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AlgWidgets 2.0

FileDialog {
    id: fileDialog
    title: "Select Color Palette JSON"
    // folder: shortcuts.home
    nameFilters: [ "JSON (*.json)" ]

    onAccepted: {
        Qt.quit()
    }

    onRejected: {
        console.log("Canceled")
        Qt.quit()
    }
}
