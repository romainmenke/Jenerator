//
//  JSONDecoder.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
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
    static func encode(_ object:AnyObject) -> VData? {
        
        guard JSONSerialization.isValidJSONObject(object) else {
            return nil
        }
        
        #if swift(>=3.0)
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:object, options: JSONSerialization.WritingOptions.prettyPrinted)
                return jsonData
            } catch _ as NSError {
                return nil
            }
            
        #elseif swift(>=2.2)
            
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
                return jsonData
            } catch _ as NSError {
                return nil
            }
            
        #endif
    }
    
    /**
     Decode NSData into a collection
     
     - parameter data: NSData containing a JSON
     
     - returns: a collection if serialization succeeds
     */
    static func decode(_ data:VData) -> AnyObject? {
        
        #if swift(>=3.0)
            
            do {
                let decoded = try JSONSerialization.jsonObject(with: data, options: [])
                return decoded
            } catch _ as NSError {
                return nil
            }
            
        #elseif swift(>=2.2)
            
            do {
                let decoded = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                return decoded
            } catch _ as NSError {
                return nil
            }
            
        #endif
    }
    
}
