//
//  JSONDecoder.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


/**
 *  JSON Helper Type
 */
struct JSONCoder {
    
    /**
     Encode a collection into NSJONSerialised NSData
     
     - parameter object: a collection
     
     - returns: NSData if the collection is a valid JSON Object and serialization succeeds
     */
    static func encode(object:AnyObject) -> NSData? {
        guard NSJSONSerialization.isValidJSONObject(object) else {
            return nil
        }
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
            return jsonData
        } catch _ as NSError {
            return nil
        }
    }
    
    /**
     Decode NSData into a collection
     
     - parameter data: NSData containing a JSON
     
     - returns: a collection if serialization succeeds
     */
    static func decode(data:NSData) -> AnyObject? {
        do {
            let decoded = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return decoded
        } catch _ as NSError {
            return nil
        }
    }
    
}