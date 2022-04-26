// Default includes, to acces Qt/QML
// and Substance 3D Painter APIs
import QtQuick 2.7
import Painter 1.0

// Root object for the plugin
PainterPlugin {
    // Disable update and server settings
    // since we don't need them
    tickIntervalMS: -1 // Disabled Tick
    jsonServerPort: -1 // Disabled JSON server

    // Implement the OnCompleted function
    // This event is used to build the UI
    // once the plugin has been loaded by Substance 3D Painter
    Component.onCompleted: {
        let panel = alg.ui.addDockWidget("mydockable.qml");

        // alg.log.info(stringify(panel, 1, null, 4))
        // alg.log.info(stringify(panel.children, 1, null, 4))

        // Create a toolbar button
        // let InterfaceButton = alg.ui.addToolBarWidget("toolbar.qml")

        // Connect the function to the button
        // if ( InterfaceButton )
        //     InterfaceButton.clicked.connect( exportTextures )
    }

    function stringify(val, depth, replacer, space) {
        depth = isNaN(+depth) ? 1 : depth;
        function _build(key, val, depth, o, a) { // (JSON.stringify() has it's own rules, which we respect here by using it for property iteration)
            return !val || typeof val != 'object' ? val : (a=Array.isArray(val), JSON.stringify(val, function(k,v){ if (a || depth > 0) { if (replacer) v=replacer(k,v); if (!k) return (a=Array.isArray(v),val=v); !o && (o=a?[]:{}); o[k] = _build(k, v, a?depth:depth-1); } }), o||(a?[]:{}));
        }
        return JSON.stringify(_build('', val, depth), null, space);
    }

    // Custom function called by the Button,
    // this is the core of the plugin
    // function exportTextures() {
    //     // Catch errors in the script during execution
    //     try {
    //         // Verify if a project is open before
    //         // trying to export something
    //         if ( !alg.project.isOpen() ) return
    //
    //         // Retrieve the currently selected Texture Set (and sub-stack if any)
    //         let MaterialPath = alg.texturesets.getActiveTextureSet()
    //         let UseMaterialLayering = MaterialPath.length > 1
    //         let TextureSetName = MaterialPath[0]
    //         let StackName = ""
    //
    //         if ( UseMaterialLayering )
    //             StackName = MaterialPath[1]
    //
    //         // Retrieve the Texture Set information
    //         let Documents = alg.mapexport.documentStructure()
    //         let Resolution = alg.mapexport.textureSetResolution( TextureSetName )
    //         let Channels = null
    //
    //         for ( let Index in Documents.materials ) {
    //             let Material = Documents.materials[Index]
    //
    //             if ( TextureSetName == Material.name ) {
    //                 for ( let SubIndex in Material.stacks ) {
    //                     if ( StackName == Material.stacks[SubIndex].name ) {
    //                         Channels = Material.stacks[SubIndex].channels
    //                         break
    //                     }
    //                 }
    //             }
    //         }
    //
    //         // Create the export settings
    //         let Settings = {
    //             "padding":"Infinite",
    //             "dithering":"disbaled", // Hem, yes...
    //             "resolution": Resolution,
    //             "bitDepth": 16,
    //             "keepAlpha": false
    //         }
    //
    //         // Build the base of the export path
    //         // Files will be located next to the project
    //         let BasePath = alg.fileIO.urlToLocalFile( alg.project.url() )
    //         BasePath = BasePath.substring( 0, BasePath.lastIndexOf("/") )
    //
    //         // Export the each channel
    //         for ( let Index in Channels ) {
    //             // Create the stack path, which defines the channel to export
    //             let Path = Array.from( MaterialPath )
    //             Path.push( Channels[Index] )
    //
    //             // Build the filename for the texture to export
    //             let Filename = BasePath + "/" + TextureSetName
    //
    //             if ( UseMaterialLayering )
    //                 Filename += "_" + StackName
    //
    //             Filename += "_" + Channels[Index] + ".png"
    //
    //             // Perform the export
    //             alg.mapexport.save( Path, Filename, Settings )
    //             alg.log.info( "Exported: " + Filename )
    //         }
    //     }
    //     catch ( error ) {
    //         // Print errors in the log window
    //         alg.log.exception( error )
    //     }
    // }
}
