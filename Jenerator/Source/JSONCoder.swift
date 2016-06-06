//
//  JSONDecoder.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

#if os(Linux)
    import Jay
#endif

/**
 *  JSON Helper Type
 */
struct JSONCoder {
    
    /**
     Encode a collection into NSJONSerialised NSData
     
     - parameter object: a collection
     
     - returns: NSData if the collection is a valid JSON Object and serialization succeeds
     */
    static func encode(_ object:Any) -> NSData? {
        
        guard let anyObject = object as? AnyObject where NSJSONSerialization.isValidJSONObject(anyObject) else {
            return nil
        }
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(anyObject, options: NSJSONWritingOptions.PrettyPrinted)
                return jsonData
            } catch _ as NSError {
                return nil
            }
            
        #elseif os(Linux)
            
            do {
                let dataOut = try Jay().dataFromJson(object)
                return NSData(bytes: dataOut, length: dataOut.count)
            } catch {
                return nil
            }
            
        #endif
        
    }
    
    /**
     Decode NSData into a collection
     
     - parameter data: NSData containing a JSON
     
     - returns: a collection if serialization succeeds
     */
    static func decode(_ data:NSData) -> AnyObject? {
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: [])
            } catch _ as NSError {
                return nil
            }
            
        #elseif os(Linux)
            
            // http://stackoverflow.com/a/24516400/4263818
            
            let count = data.length / sizeof(UInt8)
            
            // create array of appropriate length:
            var array = [UInt8](repeating: 0, count: count)
            
            // copy bytes into array
            data.getBytes(&array, length:count * sizeof(UInt8))
            
            do {
                return try Jay().jsonFromData(array) as? AnyObject
            } catch {
                return nil
            }
            
        #endif
    }
    
}