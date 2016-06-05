//
//  JSONAliasses.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  Container for Type Aliasses
 */
struct JSONTypeAlias : Equatable {
    
    /// The Type that will be fully declared
    var original : JSONCustomType
    
    /// The Type that will be created as an alias
    var alias : JSONCustomType
    
    
}

func ==(lhs:JSONTypeAlias,rhs:JSONTypeAlias) -> Bool {
    return lhs.alias == rhs.alias && lhs.original == rhs.original
}

func !=(lhs:JSONTypeAlias,rhs:JSONTypeAlias) -> Bool {
    return !(lhs == rhs)
}