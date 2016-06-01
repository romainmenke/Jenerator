//
//  main.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 01/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

func main() {
    
    if NSProcessInfo.processInfo().arguments.count < 2 {
        print(info())
        exit(EXIT_FAILURE)
    }
    else {
        
        var generator = JSONToSwiftModelGenerator()
        
        guard let sourceUrl = NSURL(string: NSProcessInfo.processInfo().arguments[1]) else {
            print("bad source")
            exit(EXIT_FAILURE)
        }
        
        var savePath : String = ""
        var saveFileName : String = "JSONModel.swift"
        
        // Check if the file exists, exit if not
        if sourceUrl.fileURL {
            generator.fromFile(NSProcessInfo.processInfo().arguments[1])
            savePath = sourceUrl.absoluteString.stringByReplacingOccurrencesOfString(sourceUrl.lastPathComponent ?? "", withString: "")
            saveFileName = NSProcessInfo.processInfo().arguments[2].stringByReplacingOccurrencesOfString(".swift", withString: "") + ".swift"
        } else if NSProcessInfo.processInfo().arguments.count > 2 {
            generator.fromSource(sourceUrl)
            savePath = NSProcessInfo.processInfo().arguments[2]
            if NSProcessInfo.processInfo().arguments.count > 3 {
                saveFileName = NSProcessInfo.processInfo().arguments[3].stringByReplacingOccurrencesOfString(".swift", withString: "") + ".swift"
            }
        } else {
            print("can't find source")
            exit(EXIT_FAILURE)
        }
        
        guard let saveUrl = NSURL(string: savePath) else {
            print("can't find source")
            exit(EXIT_FAILURE)
        }
        
        if let modelString = generator.formatAsSwift() {
            let modelFilePath = savePath + "/" + saveFileName
            
            do {
                try modelString.writeToFile(modelFilePath, atomically:true, encoding:NSUTF8StringEncoding)
                print("all done")
                exit(EXIT_SUCCESS)
            } catch {
                print("can't write")
                exit(EXIT_FAILURE)
            }
        } else {
            print("can't model")
            exit(EXIT_FAILURE)
        }
    }
}


main()