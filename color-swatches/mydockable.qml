//
// Created by TekuConcept on April 8, 2022
// Qt v5.12.2
// SP v2020.2.2 (6.2.2)
//

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.3
import AlgWidgets 2.0

Item {
    width: 100
    height: 100
    objectName: "Color Input"
    property alias rectangle: rect

    OpenDialog {
        id: openDialog
        visible: false

        onAccepted: {
            close()

            let path = alg.fileIO.urlToLocalFile(openDialog.fileUrl)
            let jsonFile = alg.fileIO.open(path, 'r');
            let raw = jsonFile.readAll()
            try {
                // layouts:
                // - array of values
                // - dictionary of values
                // values:
                // - #XXXXXX
                // - rgb(RRR,GGG,BBB)

                let obj = JSON.parse(raw)
                if (Array.isArray(obj)) {
                    obj.forEach(element => {
                        if (typeof element !== 'string') {
                            alg.log.warn(`unrecognized color value ${element}`)
                            return
                        }
                        if (element[0] === '#') pushHexColor(element)
                        else if (element[0] === 'r' || element[0] === 'R') pushRgbColor(element)
                        else alg.log.warn(`color ${element} not supported`)
                    })
                }
                else {
                    let entries = Object.entries(obj)
                    entries.forEach(entry => {
                        let element = entry[1] // value
                        if (typeof element !== 'string') {
                            alg.log.warn(`unrecognized color value ${element} for ${entry}`)
                            return
                        }
                        if (element[0] === '#') pushHexColor(element)
                        else if (element[0] === 'r' || element[0] === 'R') pushRgbColor(element)
                        else alg.log.warn(`color ${element} not supported`)
                    })
                }
            }
            catch (e) {
                alg.log.warn(`failed to parse file ${openDialog.fileUrl}: ${e.what()}`);
            }
            jsonFile.close()
        }
    }

    /**
     * Parse rgb string, convert, and push color
     */
    function pushRgbColor(rgb) {
        let reRgb = /[Rr][Gg][Bb]\([0-9]{1,3},[0-9]{1,3},[0-9]{1,3}\)/g
        if (!reRgb.test(rgb)) {
            alg.log.warn(`color ${rgb} not supported`)
            return
        }

        rgb = rgb.slice(4, rgb.length - 1) // trim 'RGB(' and ')'
        let sChannels = rgb.split(',')

        const r = Math.min(parseInt(sChannels[0]) / 255, 1)
        const g = Math.min(parseInt(sChannels[1]) / 255, 1)
        const b = Math.min(parseInt(sChannels[2]) / 255, 1)

        let nextColor = Qt.rgba(r,g,b,1)
        pushColor(nextColor)
    }

    /**
     * Parse hex string, convert, and push color
     */
    function pushHexColor(hex) {
        if (hex.startsWith('#')) hex = hex.slice(1)
        let reHex = /[0-9A-Fa-f]{6}/g;
        if (!reHex.test(hex)) {
            alg.log.warn(`color ${hex} not supported`)
            return
        }

        const r = parseInt(hex.slice(0, 2), 16) / 255
        const g = parseInt(hex.slice(2, 4), 16) / 255
        const b = parseInt(hex.slice(4, 6), 16) / 255
        let nextColor = Qt.rgba(r,g,b,1)

        pushColor(nextColor)
    }

    /**
     * Shift all colors and add the next color
     */
    function pushColor(qtColor) {
        if (qtColor === colorPreview.color) return
        
        colorPreview.color = qtColor
        
        color1F.color = color1E.color
        color1E.color = color1D.color
        color1D.color = color1C.color
        color1C.color = color1B.color
        color1B.color = color1A.color
        color1A.color = color19.color
        color19.color = color18.color
        color18.color = color17.color
        color17.color = color16.color
        color16.color = color15.color
        color15.color = color14.color
        color14.color = color13.color
        color13.color = color12.color
        color12.color = color11.color
        color11.color = color10.color
        color10.color = color0F.color

        color0F.color = color0E.color
        color0E.color = color0D.color
        color0D.color = color0C.color
        color0C.color = color0B.color
        color0B.color = color0A.color
        color0A.color = color09.color
        color09.color = color08.color
        color08.color = color07.color
        color07.color = color06.color
        color06.color = color05.color
        color05.color = color04.color
        color04.color = color03.color
        color03.color = color02.color
        color02.color = color01.color
        color01.color = color00.color
        color00.color = colorPreview.color
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#333333"

        GridLayout {
            columns: 1

            GridLayout {
                columns: 4

                Rectangle {
                    id: colorPreview
                    color: "#333"
                    border.width: 1
                    border.color: "#000"
                    width: 50
                    height: 50
                }
                AlgLabel {
                    text: "Hex"
                }
                AlgTextInput {
                    id: hexColor
                    Layout.preferredWidth: 100
                    text: "#000000"
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMask: "HHHHHH"
                    onEditingFinished: {
                        pushHexColor(hexColor.text)
                    }
                }
                AlgButton {
                    id: paletteLoadButton
                    text: "Load"
                    onClicked: {
                        // alg.log.info("button pressed")
                        openDialog.open()
                        // var p1 = paletteLoadButton.parent
                        // var p2 = p1
                        // let n = 0;
                        // while (p1) {
                        //     // alg.log.info(`has parent ${n}`)
                        //     p2 = p1
                        //     // alg.log.info(`obj name: ${p2.toString()}`)
                        //     p1 = p1.parent
                        //     n++
                        // }
                        // if (p2) {
                        //     alg.log.info(`children: ${p2.children.length}`)
                        // }

                        // /*
                        //     - QQuickRootItem
                        //         - QQuickItem_QML_1112 ('Color Input')
                        //             - QQuickRectangle
                        //                 - QQuickGridLayout
                        //                     - QQuickGridLayout
                        //                         palletLoadButton
                        // */
                    }
                    width: 150
                }
            }

            GridLayout {
                columns: 8

                Rectangle {
                    id: color00
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color01
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color02
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color03
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color04
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color05
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color06
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color07
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color08
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color09
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color0A
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color0B
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color0C
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color0D
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color0E
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color0F
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color10
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color11
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color12
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color13
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color14
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color15
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color16
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color17
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color18
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color19
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color1A
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color1B
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color1C
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color1D
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color1E
                    color: "#000"
                    width: 16
                    height: 16
                }
                Rectangle {
                    id: color1F
                    color: "#000"
                    width: 16
                    height: 16
                }
            }
        }

        // var jsonData = JSON.stringify(structure , null, '\t');
        // var jsonFile = alg.fileIO.open('C:/Path/To/My/Plugin/structure.json', 'r+');
        // jsonFile.write(jsonData);
        // jsonFile.close()

        // function rgb2lin(r,g,b) {
        //     let S = [r/255,g/255,b/255];
        //     for (let i = 0; i < S.length; i++) {
        //         if (S[i] > 0.04045)
        //             S[i] = ((S[i]+.055)/1.055)**2.4;
        //         else S[i] = S[i]/12.92;
        //     }
        //     return S;
        // }

        // MouseArea {
        //     id: mouseArea
        //     anchors.fill: parent
        //     onClicked: {
        //         var ok = alg.mapexport.showExportDialog();
        //         if (ok) {
        //             alg.log.info("Export successful!")
        //         } else {
        //             alg.log.warn("Export cancelled!")
        //         }
        //     }
        // }
    }
}
