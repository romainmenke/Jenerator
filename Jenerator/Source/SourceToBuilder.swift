//
//  JSONToSwift.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

extension ModelBuilder {
    
    /**
     Constructer for a remote JSON source
     
     - parameter url:         Url that will return the JSON
     - parameter classPrefix: Class Prefix for the Types
     
     - returns: an initialised ModelBuilder if the url returned valid JSON data
     */
    public static func fromSource(_ url:NSURL, classPrefix:String) -> ModelBuilder? {
        
        guard let data = NSData(contentsOf:url) else {
            return nil
        }
        
        if let json = JSONCoder.decode(data) {
            return ModelBuilder(rootName: "jenerator", classPrefix: classPrefix).buildModel(fromData: json, withSource: url)
        }
        return nil
    }
    
    /**
     Constructer for a local JSON source
     
     - parameter path:        Path to a .json file as a string
     - parameter classPrefix: Class Prefix for the Types
     
     - returns: an initialised ModelBuilder if the file contained valid JSON data
     */
    public static func fromFile(_ path:String, classPrefix:String) -> ModelBuilder? {
        
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        
        if let json = JSONCoder.decode(data) {
            return ModelBuilder(rootName: "jenerator", classPrefix: classPrefix).buildModel(fromData: json, withSource: nil)
        }
        return nil
    }
}