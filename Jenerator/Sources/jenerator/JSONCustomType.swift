//
//  JSONCustomType.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  A JSON dictionary
 */
struct JSONCustomType : Equatable, CustomStringConvertible {
    
    /// The key-value pairs found in the JSON dictionary
    var fields : [JSONField] = []
    
    /// The name of the Type
    var name : String
    
    /// Formatted list of the name and fields
    var description: String {
        get {
            var descr = ""
            descr += name
            descr += "\n"
            for field in fields {
                descr += field.description + "\n"
            }
            return descr
        }
    }
}

/**
 Equality
 
 - parameter lhs: JSONCustomType
 - parameter rhs: JSONCustomType
 
 - returns: true if the names are equal
 */
func == (lhs:JSONCustomType,rhs:JSONCustomType) -> Bool {
    return lhs.name == rhs.name
}

/**
 Inequality
 
 - parameter lhs: JSONCustomType
 - parameter rhs: JSONCustomType
 
 - returns: true if the names are different
 */
func != (lhs:JSONCustomType,rhs:JSONCustomType) -> Bool {
    return !(lhs.name == rhs.name)
}