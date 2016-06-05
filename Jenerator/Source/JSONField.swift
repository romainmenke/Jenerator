//
//  JSONField.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  A JSON field
 */
struct JSONField : Equatable, CustomStringConvertible {
    
    /// The name of the field
    var name : String
    
    /// The type of the field
    var type : JSONDataType
    
    /// Description formatted as a swift attribute
    var description: String {
        get {
            return "var \(name) : \(type)"
        }
    }
}

/**
 Equality
 
 - parameter lhs: JSONField
 - parameter rhs: JSONField
 
 - returns: true if both the type and name are equal
 */
func == (lhs:JSONField,rhs:JSONField) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
}

/**
 Inequality
 
 - parameter lhs: JSONField
 - parameter rhs: JSONField
 
 - returns: true if either the type or name is different
 */
func != (lhs:JSONField,rhs:JSONField) -> Bool {
    return !(lhs.name == rhs.name && lhs.type == rhs.type)
}