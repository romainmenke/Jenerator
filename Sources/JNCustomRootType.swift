//
//  JNCustomRootType.swift
//  Jenerator
//
//  Created by Romain Menke on 15/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  A JSON object
 */
struct JNCustomRootType : JNCustom, Equatable, CustomStringConvertible {
    
    /// The key-value pairs found in the JSON object
    var fields : [JNField] = []
    
    /// The name of the Type
    var name : String
    
    /// The JNQuery object associated with the JNCustomRootType
    var query : JNQuery? = nil
    
    /// Flag used by the Generator to correctly type cast the root object of a JSON
    var isDictionary : Bool = false
    
    /// The Class Prefix for the Type
    var classPrefix : String
    
    /**
     Create a JNCustomRootType with a series of fields, a unique name, and a Class Prefix.
     
     - parameter fields:      the fields found in the JSON object
     - parameter name:        the key of the JSON object
     - parameter classPrefix: the Class Prefix for the Type
     
     - returns: A JNCustomRootType Instance
     */
    init(fields:[JNField], name:String, classPrefix:String) {
        self.fields = fields
        self.name = name
        self.classPrefix = classPrefix
    }
}
