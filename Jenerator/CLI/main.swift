//
//  main.swift
//  Jenerator
//
//  Created by Romain Menke on 01/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

func main() {
    
    if NSProcessInfo.processInfo().arguments.count < 2 {
        print(info())
        exit(EXIT_FAILURE)
    }
    else {
        
        guard let sourceUrl = NSURL(string: NSProcessInfo.processInfo().arguments[1]) else {
            print("bad source")
            exit(EXIT_FAILURE)
        }
        
        var savePath : String = ""
        var saveFileName : String = "JSONModel.swift"
        var classPrefix : String = ""
        
        var builder : ModelBuilder?
        
        if sourceUrl.host == nil {
            savePath = sourceUrl.absoluteString.stringByReplacingOccurrencesOfString(sourceUrl.lastPathComponent ?? "", withString: "")
            saveFileName = NSProcessInfo.processInfo().arguments[2].stringByReplacingOccurrencesOfString(".swift", withString: "") + ".swift"
            if NSProcessInfo.processInfo().arguments.count > 3 {
                classPrefix = NSProcessInfo.processInfo().arguments[3]
            }
            builder = JSONToSwift.fromFile(NSProcessInfo.processInfo().arguments[1], classPrefix: classPrefix)
            
        } else if NSProcessInfo.processInfo().arguments.count > 2 {
            savePath = NSProcessInfo.processInfo().arguments[2]
            if NSProcessInfo.processInfo().arguments.count > 3 {
                saveFileName = NSProcessInfo.processInfo().arguments[3].stringByReplacingOccurrencesOfString(".swift", withString: "") + ".swift"
            }
            if NSProcessInfo.processInfo().arguments.count > 4 {
                classPrefix = NSProcessInfo.processInfo().arguments[4]
            }
            builder = JSONToSwift.fromSource(sourceUrl, classPrefix: classPrefix)
        
        } else {
            print("can't find source")
            exit(EXIT_FAILURE)
        }
        
        if let builder = builder, let code = SwiftGenerator.generate(model: builder) {
            
            let modelFilePath = savePath + "/" + saveFileName
            
            do {
                try code.writeToFile(modelFilePath, atomically:true, encoding:NSUTF8StringEncoding)
                print("all done")
                exit(EXIT_SUCCESS)
            } catch {
                print("can't write to path:", modelFilePath, savePath, sourceUrl)
                exit(EXIT_FAILURE)
            }
        } else {
            print("can't model")
            exit(EXIT_FAILURE)
        }
    }
}


main()