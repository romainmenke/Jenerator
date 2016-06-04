//
//  JSONToSwift.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

public struct JSONToSwift {
    
    public static func fromSource(url:NSURL, classPrefix:String) -> ModelBuilder? {
        
        guard let data = NSData(contentsOfURL: url) else {
            return nil
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                return ModelBuilder(rootName: "Container", classPrefix: classPrefix, source: url.absoluteString).buildModel(dict)
            }
        } catch {}
        
        return nil
    }
    
    public static func fromFile(path:String, classPrefix:String) -> ModelBuilder? {
        
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                return ModelBuilder(rootName: "Container", classPrefix: classPrefix).buildModel(dict)
            }
        } catch {}
        
        return nil
    }
}