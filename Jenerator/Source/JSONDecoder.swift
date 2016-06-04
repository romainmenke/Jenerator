//
//  JSONDecoder.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


struct JSONCoder {
    
    static func encode(object:AnyObject) -> NSData? {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
            return jsonData
        } catch _ as NSError {
            return nil
        }
    }
    
    static func decode(data:NSData) -> [String:AnyObject]? {
        do {
            let decoded = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            return decoded
        } catch _ as NSError {
            return nil
        }
    }
    
}