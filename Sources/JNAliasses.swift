//
//  JNAliasses.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  A container for JSON objects found under different Keys but which have the same Fields.
 *  This will be used to generate typealiasses.
 */
struct JNTypeAlias : Equatable, CustomStringConvertible {
    
    /// The type that will be fully declared by the Generator.
    var original : JNCustom
    
    /// The type that will be created as a typealias.
    var alias : JNCustom
    
    /// A textual representation of self.
    var description: String {
        get {
            return "typealias \(alias.name) = \(original.name)"
        }
    }
    
    /**
     Create a JNTypeAlias with two JNCustom instances that have equal fields.
     
     - parameter original: A type that will be generated in full.
     - parameter alias:    A type that is made redundant by the original
     
     - returns: A JNTypeAlias instance
     */
    init(original: JNCustom, alias: JNCustom) {
        self.original = original
        self.alias = alias
    }
    
}

/**
 Equality
 
 - parameter lhs: JNTypeAlias
 - parameter rhs: JNTypeAlias
 
 - returns: true if both the alias and original are equal
 */
func ==(lhs:JNTypeAlias,rhs:JNTypeAlias) -> Bool {
    return lhs.alias.name == rhs.alias.name && lhs.original.name == rhs.original.name
}

/**
 Inequality
 
 - parameter lhs: JNTypeAlias
 - parameter rhs: JNTypeAlias
 
 - returns: true if either the alias or the original is different
 */
func !=(lhs:JNTypeAlias,rhs:JNTypeAlias) -> Bool {
    return !(lhs == rhs)
}
