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
    #if swift(>=3.0)
        public static func fromSource(_ url:URL, classPrefix:String) -> ModelBuilder? {
        
            guard let data = try? Data(contentsOf:url) else {
                return nil
            }
            
            if let json = JSONCoder.decode(data) {
                return ModelBuilder(rootName: "jenerator", classPrefix: classPrefix).buildModel(fromData: json, withSource: url)
            }
            return nil
        }
    #elseif swift(>=2.2)
        public static func fromSource(_ url:NSURL, classPrefix:String) -> ModelBuilder? {
            
            guard let data = NSData(contentsOf:url) else {
                return nil
            }
            
            if let json = JSONCoder.decode(data) {
                return ModelBuilder(rootName: "jenerator", classPrefix: classPrefix).buildModel(fromData: json, withSource: url)
            }
            return nil
        }
    #endif
    
    
    /**
     Constructer for a local JSON source
     
     - parameter path:        Path to a .json file as a string
     - parameter classPrefix: Class Prefix for the Types
     
     - returns: an initialised ModelBuilder if the file contained valid JSON data
     */
    #if swift(>=3.0)
        public static func fromFile(_ path:String, classPrefix:String) -> ModelBuilder? {
        
            guard let data = try? Data(contentsOf: VURL(fileURLWithPath: path)) else {
                return nil
            }
            
            if let json = JSONCoder.decode(data) {
                return ModelBuilder(rootName: "jenerator", classPrefix: classPrefix).buildModel(fromData: json, withSource: nil)
            }
            return nil
        }
    #elseif swift(>=2.2)
        public static func fromFile(_ path:String, classPrefix:String) -> ModelBuilder? {
            
            guard let data = NSData(contentsOf: VURL(fileURLWithPath: path)) else {
                return nil
            }
            
            if let json = JSONCoder.decode(data) {
                return ModelBuilder(rootName: "jenerator", classPrefix: classPrefix).buildModel(fromData: json, withSource: nil)
            }
            return nil
        }
    #endif
}
