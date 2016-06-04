//
//  JSONToSwift.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

extension ModelBuilder {
    
    public static func fromSource(url:NSURL, classPrefix:String) -> ModelBuilder? {
        
        guard let data = NSData(contentsOfURL: url) else {
            return nil
        }
        
        if let json = JSONCoder.decode(data) {
            return ModelBuilder(rootName: "Container", classPrefix: classPrefix, source: url.absoluteString).buildModel(json)
        }
        return nil
    }
    
    public static func fromFile(path:String, classPrefix:String) -> ModelBuilder? {
        
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        
        if let json = JSONCoder.decode(data) {
            return ModelBuilder(rootName: "Container", classPrefix: classPrefix).buildModel(json)
        }
        return nil
    }
}