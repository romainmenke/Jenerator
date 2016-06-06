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
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            
            return first.uppercaseString + String(characters.dropFirst())
            
        #elseif os(Linux)
            
            return first.uppercased() + String(characters.dropFirst())
            
        #endif
        
    }
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


extension NSURL {
    /**
     Drop the last component from an NSURL
     
     - returns: the url without it's last component
     */
    func removeLast() -> NSURL? {
        var arrayOfComponents = self.absoluteString.split("/")
        arrayOfComponents.removeLast()
        let url = arrayOfComponents.reduce("", combine: { $0 + "/" + $1 })
        return NSURL(string: url)
    }
}


extension String {
    func split(_ on: Character) -> [String] {
        
        var segments = [String]()
        var current = ""
        
        for char in self.characters {
            if (char == on) {
                segments.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }
        
        if current.characters.count > 0 {
            segments.append(current)
        }
        
        return segments
    }
}