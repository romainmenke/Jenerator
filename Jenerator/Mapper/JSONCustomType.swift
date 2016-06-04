//
//  JSONCustomType.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


struct JSONCustomType : Equatable, CustomStringConvertible {
    
    var fields : [JSONField] = []
    var name : String
    
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

func == (lhs:JSONCustomType,rhs:JSONCustomType) -> Bool {
    return lhs.name == rhs.name
}

func != (lhs:JSONCustomType,rhs:JSONCustomType) -> Bool {
    return !(lhs.name == rhs.name)
}