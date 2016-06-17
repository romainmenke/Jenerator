//
//  CLI.swift
//  Jenerator
//
//  Created by Romain Menke on 05/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/// Command Line Object for Jenerator
class JNCommandLine {

    /// Command Line
    let cli = CommandLine()

    /// Source Url
    let sourceFlag = StringOption(shortFlag: "s", longFlag: "source", required: true, helpMessage: "Path to .json file or Url to remote JSON, use double quotes")
    /// Save Directory
    let saveDirFlag = StringOption(shortFlag: "d", longFlag: "dir", required: false, helpMessage: "Path to save directory")
    /// Filename for generated code
    let fileNameFlag = StringOption(shortFlag: "f", longFlag: "file", required: true, helpMessage: "Name for generated .swift file")
    /// Class Prefix for generated Types
    let classPrefixFlag = StringOption(shortFlag: "c", longFlag: "classprefix", required: false, helpMessage: "Class Prefix for generated Types")

    /// Source Url String
    private var source : String = ""
    /// File Name String
    private var fileName : String = ""
    /// Source NSURL
    private var sourceUrl : VURL?
    /// Save Path String
    private var savePath : String = ""
    /// Class Prefix String
    private var classPrefix : String = ""
    /// Current Path
    let currentPath = FileManager.default().currentDirectoryPath

    /// Model Builder
    var model : JNModel?

    /**
     The main runloop for Jenerator
     */
    static func main() {
        
        let commandLine = JNCommandLine()
        
        // Parse the arguments
        commandLine.parseArguments()
        // Exit if something is wrong
        commandLine.earlyEscapes()
        // Do the works
        commandLine.parseJSON()
        // Save the result
        commandLine.writeToFile()
    }
    
    /**
     Use Command Line to gather the arguments passed to Jenerator
     */
    private func parseArguments() {
        
        cli.addOptions(sourceFlag, saveDirFlag, fileNameFlag, classPrefixFlag)
        
        do {
            try cli.parse()
        } catch {
            cli.printUsage(error)
            exit(EX_USAGE)
        }
    }

    /**
     Exit if values are bad or missing
     */
    private func earlyEscapes() {
        
        guard let sourceArg = sourceFlag.value, fileNameArg = fileNameFlag.value else {
            cli.printUsage()
            exit(EX_USAGE)
        }
        
        guard let sourceUrlArg = URL(string: sourceArg) else {
            print("Malformed Source Url/Path")
            exit(EXIT_FAILURE)
        }
        
        // assign the verified values
        source = sourceArg
        sourceUrl = sourceUrlArg
        fileName = fileNameArg.replacingOccurrences(of: ".swift", with: "") + ".swift"
        classPrefix = classPrefixFlag.value ?? "JN"
    }

    /**
     Parse the JSON and build the model
     */
    private func parseJSON() {
        
        guard let sourceUrl = sourceUrl else {
            return
        }
        
        if sourceUrl.host == nil {
            savePath = saveDirFlag.value ?? sourceUrl.removeLast()?.absoluteString ?? currentPath
            model = JNModel.from(file:source, withPrefix: classPrefix)?.findAliasses()
        } else {
            savePath = saveDirFlag.value ?? currentPath
            model = JNModel.from(url:sourceUrl, withPrefix: classPrefix)?.findAliasses()
        }
        
    }

    /**
     Save the generated code to a file
     */
    private func writeToFile() {
        
        if let model = model, let code = SwiftGenerator.generate(from: model) {
            
            let modelFilePath = savePath + "/" + fileName
            
            do {
                try code.write(toFile: modelFilePath, atomically:true, encoding:String.Encoding.utf8)
                exit(EXIT_SUCCESS)
            } catch {
                print("Can't write to", modelFilePath)
                exit(EXIT_FAILURE)
            }
        } else {
            print("Can't create model")
            exit(EXIT_FAILURE)
        }
    }

}
