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
    var name : String
    var type : JSONDataType
    
    var description: String {
        get {
            return "var \(name) : \(type)"
        }
    }
}

func == (lhs:JSONField,rhs:JSONField) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
}

func != (lhs:JSONField,rhs:JSONField) -> Bool {
    return !(lhs.name == rhs.name && lhs.type == rhs.type)
}