//
//  Magic.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


extension Array where Element : Equatable {
    /**
     Append a new elment to an array if the array doesn't yet contain it
     
     - parameter element: a new element
     */
    mutating func appendUnique(_ element:Element) {
        if self.contains(element) {
            return
        } else {
            self.append(element)
        }
    }
}

extension String {
    /// First character of a string
    var first: String {
        return String(characters.prefix(1))
    }
    /// Last character of a string
    var last: String {
        return String(characters.suffix(1))
    }
    /// Make the first character uppercase
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    /// Make the first character uppercase
    var lowercaseFirst: String {
        return first.lowercased() + String(characters.dropFirst())
    }
    
//    func stringByAddingPercentEncodingForRFC3986() -> String? {
//        let unreserved = "-._~/?"
//        let allowed = NSMutableCharacterSet.alphanumerics
//        allowed.addCharacters(in: unreserved)
//        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
//    }
}

extension NSNumber {
    
    /**
     Determine if an NSNumber is derived from a Bool or a Number
     
     - returns: true if the object is a Bool
     */
    func isBool() -> Bool {
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(self) // the type ID of num
        return numID == boolID
    }
    
}
