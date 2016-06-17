//
//  JNDecoder.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


/**
 *  A JSON Serialization Helper.
 *  Bridges multiple Swift versions and different Architectures.
 */
struct JNCoder {
    
    /**
     Encode a Collection into NSData
     
     - parameter object: a Collection to encode
     
     - returns: NSData if the collection is a valid JSON Object and serialization succeeds
     
     ```swift
        if let data = JNCoder.encoded(object) {
            // send data to remote
        }
     */
    static func encoded(_ object:AnyObject) -> VData? {
        
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
     Decode NSData into a Collection
     
     - parameter data: NSData containing a JSON
     
     - returns: a Collection if serialization succeeds
     
     ```swift
     if let object = JNCoder.decoded(data) {
        // use object received from source
     }
     */
    static func decoded(_ data:VData) -> AnyObject? {
        
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
