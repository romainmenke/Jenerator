//
//  CLI.swift
//  Jenerator
//
//  Created by Romain Menke on 05/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

// Attributes

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
private var sourceUrl : NSURL = NSURL()
/// Save Path String
private var savePath : String = ""
/// Class Prefix String
private var classPrefix : String = ""
/// Current Path
let currentPath = NSFileManager.defaultManager().currentDirectoryPath

/// Model Builder
var builder : ModelBuilder?


/**
 Use Command Line to gather the arguments passed to Jenerator
 */
func parseArguments() {
    
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
func earlyEscapes() {
    
    guard let sourceArg = sourceFlag.value, fileNameArg = fileNameFlag.value else {
        cli.printUsage()
        exit(EX_USAGE)
    }
    
    guard let sourceUrlArg = NSURL(string: sourceArg) else {
        print("Malformed Source Url/Path")
        exit(EXIT_FAILURE)
    }
    
    // assign the verified values
    source = sourceArg
    sourceUrl = sourceUrlArg
    fileName = fileNameArg.stringByReplacingOccurrencesOfString(".swift", withString: "") + ".swift"
    classPrefix = classPrefixFlag.value ?? "JN"
}

/**
 Parse the JSON and build the model
 */
func parseJSON() {
    
    if sourceUrl.host == nil {
        savePath = saveDirFlag.value ?? sourceUrl.removeLast()?.absoluteString ?? currentPath
        builder = ModelBuilder.fromFile(source, classPrefix: classPrefix)?.findAliasses()
    } else {
        savePath = saveDirFlag.value ?? currentPath
        builder = ModelBuilder.fromSource(sourceUrl, classPrefix: classPrefix)?.findAliasses()
    }
    
}

/**
 Save the generated code to a file
 */
func writeToFile() {
    
    if let builder = builder, let code = SwiftGenerator.generate(fromModel: builder) {
        
        let modelFilePath = savePath + "/" + fileName
        
        do {
            try code.writeToFile(modelFilePath, atomically:true, encoding:NSUTF8StringEncoding)
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