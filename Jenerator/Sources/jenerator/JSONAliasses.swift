//
//  JSONAliasses.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  Container for Type Aliasses
 */
struct JSONTypeAlias : Equatable {
    
    /// The type that will be fully declared
    var original : JSONCustomType
    
    /// The type that will be created as an alias
    var alias : JSONCustomType
    
    
}

/**
 Equality
 
 - parameter lhs: JSONTypeAlias
 - parameter rhs: JSONTypeAlias
 
 - returns: true if both the alias and original are equal
 */
func ==(lhs:JSONTypeAlias,rhs:JSONTypeAlias) -> Bool {
    return lhs.alias == rhs.alias && lhs.original == rhs.original
}

/**
 Inequality
 
 - parameter lhs: JSONTypeAlias
 - parameter rhs: JSONTypeAlias
 
 - returns: true if either the alias or original is different
 */
func !=(lhs:JSONTypeAlias,rhs:JSONTypeAlias) -> Bool {
    return !(lhs == rhs)
}