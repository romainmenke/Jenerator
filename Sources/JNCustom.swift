//
//  JNCustom.swift
//  Jenerator
//
//  Created by Romain Menke on 15/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

// MARK: - Definition

/**
 *  A JSON object
 */
protocol JNCustom : CustomStringConvertible {
    
    /// The key-value pairs found in the JSON object
    var fields : [JNField] { get set }
    
    /// The name of the Type
    var name : String { get set }
    
    /// The Class Prefix for the Type
    var classPrefix : String { get set }
    
    /**
     Create a JNCustom with a series of fields, a unique name, and a Class Prefix.
     
     - parameter fields:      the fields found in the JSON object
     - parameter name:        the key of the JSON object
     - parameter classPrefix: the Class Prefix for the Type
     
     - returns: A JNCustom Instance
     */
    init(fields:[JNField], name:String, classPrefix:String)

}

// MARK: - CustomStringConvertible
extension JNCustom {
    /// A textual representation of self.
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


// MARK: - Compatible
extension JNCustom {
    
    /**
     Check if another instance of JNCustom is compatible with Self
     
     - parameter type: the instance to evaluate
     
     - returns: true if all fields of self are found in the other instance of JNCustom
     
     */
    func isCompatible(with type: JNCustom) -> Bool {
        
        guard name == type.name else {
            return false
        }
        
        // every current field must be represented in the new type
        for element in fields {
            if !(type.fields.contains(element)) {
                return false
            }
        }
        return true
        
    }
}

// MARK: - Equatable

/**
 Equality
 
 - parameter lhs: JSONCustomType
 - parameter rhs: JSONCustomType
 
 - returns: true if the names are equal
 */
func == (lhs:JNCustom,rhs:JNCustom) -> Bool {
    return lhs.name == rhs.name
}

/**
 Inequality
 
 - parameter lhs: JSONCustomType
 - parameter rhs: JSONCustomType
 
 - returns: true if the names are different
 */
func != (lhs:JNCustom,rhs:JNCustom) -> Bool {
    return !(lhs.name == rhs.name)
}

/**
 Equality
 
 - parameter lhs: JSONCustomType
 - parameter rhs: JSONCustomType
 
 - returns: true if the names are equal
 */
func == <T:JNCustom,U:JNCustom>(lhs:T,rhs:U) -> Bool {
    return lhs.name == rhs.name
}

/**
 Inequality
 
 - parameter lhs: JSONCustomType
 - parameter rhs: JSONCustomType
 
 - returns: true if the names are different
 */
func != <T:JNCustom,U:JNCustom>(lhs:T,rhs:U) -> Bool {
    return !(lhs.name == rhs.name)
}
