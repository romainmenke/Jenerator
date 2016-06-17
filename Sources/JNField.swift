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
struct JNField : Equatable, CustomStringConvertible {
    
    /// The name of the field
    var name : String
    
    /// The type of the field
    var type : JNDataType
    
    /// A textual representation of self.
    var description: String {
        get {
            return "var \(name) : \(type)"
        }
    }
}

extension JNField : Hashable {
    
    var hashValue: Int {
        return (name + type.typeString).hashValue
    }
    
}

/**
 Equality
 
 - parameter lhs: JNField
 - parameter rhs: JNField
 
 - returns: true if both the type and name are equal
 */
func == (lhs:JNField,rhs:JNField) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
}

/**
 Inequality
 
 - parameter lhs: JNField
 - parameter rhs: JNField
 
 - returns: true if either the type or name is different
 */
func != (lhs:JNField,rhs:JNField) -> Bool {
    return !(lhs.name == rhs.name && lhs.type == rhs.type)
}
