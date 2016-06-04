//
//  JSONAliasses.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

struct JSONTypeAlias : Equatable {
    
    var original : JSONCustomType
    var alias : JSONCustomType
    
    
}

func ==(lhs:JSONTypeAlias,rhs:JSONTypeAlias) -> Bool {
    return lhs.alias == rhs.alias && lhs.original == rhs.original
}

func !=(lhs:JSONTypeAlias,rhs:JSONTypeAlias) -> Bool {
    return !(lhs == rhs)
}