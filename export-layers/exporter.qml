//
// Created by TekuConcept on April 25, 2022
//

import QtQuick 2.3
import AlgWidgets 2.0

AlgToolBarButton {
    id: control
    property bool loading: false
    tooltip: "Export Layers to PNG Files"
    iconName: control.hovered && !control.loading ? "icons/Layers_Hover.svg" : "icons/Layers_Idle.svg"

    Image {
        id: loadingIcon
        anchors.fill: parent
        anchors.margins: 8
        visible: control.loading
        source: "icons/Loading_Icon.png"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: control.width
        sourceSize.height: control.height
        mipmap: true
        width: control.width;
        height: control.height

        RotationAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            duration: 500
            loops: Animation.Infinite
        }
    }

    ExportDialog {
        id: exportDialog
        visible: false

        onAccepted: {
            close()
            batchExport(alg.fileIO.urlToLocalFile(exportDialog.folder))
        }
    }

    function batchExport(baseDirectory) {
        let documentStructure = alg.mapexport.documentStructure()
        let exportPath = baseDirectory + "/" + alg.project.name() + "_layers_export/"
        let exportConfig = {
            padding: "Infinite",
            dilation: 0,
            bitDepth: 8,
            keepAlpha: true
        }

        function exportLayer(layer, filepath, filePrefix) {
            let layername = (layer.name || `layer${layer.uid}`).replace(" ", "-")
            if (layer.layers == undefined) { // leaf
                if (!layer.enabled) return
                let filename = `${filepath}${filePrefix}${layername}_basecolor.png`
                alg.log.info(`Saving ${filename}`)
                // only focusing on "base color" channel for now
                alg.mapexport.save([layer.uid, "base color"], filename, exportConfig);
            }
            else { // folder
                if (!layer.enabled) return
                for (let layerId in layer.layers) {
                    this.exportLayer(
                        layer.layers[layerId],
                        `${filepath}${layername}/`,
                        filePrefix
                    )
                }
            }
        }

        for (let materialId in documentStructure.materials) {
            let material = documentStructure.materials[materialId]
            for (let stackId in material.stacks) {
                let stack = material.stacks[stackId]
                for (let layerId in stack.layers) {
                    exportLayer(
                        stack.layers[layerId],
                        exportPath,
                        (material.name + "_" + stack.name + "_").replace("__", "_")
                    )
                }
            }
        }

        alg.log.info("Export finished!")
    }

    onClicked: {
        exportDialog.open()
        // exportLayers('' || alg.mapexport.exportPath())

        /*
            // Form of the document structure:
            { materials: [{
            name: "Material 1",
            selected: true,
            stacks: [{ // Only one unnamed stack by default
                name: "",
                selected: true,
                channels: ["basecolor", "height", ...],
                layers: [{
                name: "Layer 1",
                uid: 24
                hasMask: true,
                selected: false,
                maskSelected: false,
                enabled: true
                }, {
                name: "Folder 1",
                uid: 48
                hasMask: false,
                selected: true,
                maskSelected: false,
                layers: [{
                    name: "Layer 2",
                    uid: 66
                    hasMask: false,
                    selected: false,
                    maskSelected: false,
                    enabled: true
                }, {...}]
                }, {...}]
            }, {...}]
            }, {...}]}
        */
    }
}
