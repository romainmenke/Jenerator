//
//  SourceEditorCommand.swift
//  JeneratorXcode
//
//  Created by Romain Menke on 14/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    let types: TextCheckingResult.CheckingType = .link
    var detector : NSDataDetector? = nil
    
    override init() {
        super.init()
        
        detector = try? NSDataDetector(types: types.rawValue)
        
    }
    
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        guard let detect = detector else {
            completionHandler(nil)
            return
        }
        
        var file = invocation.buffer.completeBuffer
        
        var codeString = ""
        
        let matches = detect.matches(in: file, options: [], range: NSMakeRange(0, file.characters.count))
        
        for match in matches {
            if let url = match.url, host = url.host {
                let autoClassPrefix = host.components(separatedBy: ".").reduce("", combine: { $0 + $1.first.uppercased() })
                let builder = ModelBuilder.fromSource(url, classPrefix: autoClassPrefix)?.findAliasses()
                if let builder = builder, code = SwiftGenerator.generate(fromModel: builder) {
                    codeString += code
                }
            }
        }
        
        invocation.buffer.lines.insert(codeString, at: (invocation.buffer.lines.count - 1))
        
        completionHandler(nil)
    }
}
