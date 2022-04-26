import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1
import AlgWidgets 2.0

FolderDialog {
    id: fileDialog
    title: "Select Export Folder"

    onAccepted: {
        Qt.quit()
    }

    onRejected: {
        Qt.quit()
    }
}
