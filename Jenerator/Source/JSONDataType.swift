//
//  JSONDataType.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 Container for JSON data types
 
 - JSONType:   Custom Type
 - JSONArray:  Array Type
 - JSONString: String
 - JSONInt:    Int
 - JSONDouble: Double
 - JSONBool:   Bool
 - JSONNull:   Nil
 */
indirect enum JSONDataType : Equatable, CustomStringConvertible {
    
    /**
     *  Custom Type
     *
     *  @param type:String Name for the custom type
     */
    case jsonType(type:String)
    
    /**
     *  Array Type
     *
     *  @param type:JSONDataType Type of the array element
     */
    case jsonArray(type:JSONDataType)
    
    /// String Type
    case jsonString
    
    /// Int Type
    case jsonInt
    
    /// FloatingPoint Type
    case jsonDouble
    
    /// Boolean Type
    case jsonBool
    
    /// Nil Type
    case jsonNull
    
    /// returns the typeString
    var description: String {
        get {
            return typeString
        }
    }
    
    /**
     Generate a type based on an AnyObject
     
     - parameter object: A decoded JSON object
     
     - returns: A JSONDataType of the corresponding JSON Type
     */
    static func generate(withObject object:AnyObject) -> JSONDataType {
        
        if let object = object as? [AnyObject] {
            if let first = object.first {
                return JSONDataType.jsonArray(type: JSONDataType.generate(withObject: first))
            }
            
            return JSONDataType.jsonArray(type: .jsonNull)
        }
        
        if let number = object as? NSNumber {
            if number.isBool() {
                return JSONDataType.jsonBool
            } else if let int = object as? Int where int == number {
                return JSONDataType.jsonInt
            } else {
                return JSONDataType.jsonDouble
            }
        } else if object is String {
            return JSONDataType.jsonString
        }
            
        return JSONDataType.jsonNull
    }
    
    /// Swift equivalent of JSON type
    var typeString : String {
        get {
            switch self {
            case .jsonString :
                return "String"
            case .jsonBool :
                return "Bool"
            case .jsonInt :
                return "Int"
            case .jsonDouble :
                return "Double"
            case .jsonNull :
                return "Any"
            case .jsonType(let type) :
                return type.uppercaseFirst
            case .jsonArray(let type) :
                return "[\(type.typeString.uppercaseFirst)]"
            }
        }
    }
    
    /// Default value for field initialisation
    var defaultValue : String {
        get {
            switch self {
            case .jsonString :
                return "\"\""
            case .jsonBool :
                return "false"
            case .jsonInt :
                return "0"
            case .jsonDouble :
                return "0.0"
            case .jsonNull :
                return "nil"
            case .jsonType(_) :
                return "nil"
            case .jsonArray(_) :
                return "[]"
            }
        }
    }
    
    /// True if JSONDataType is optional
    var optionalType : Bool {
        switch self {
        case .jsonType(_) :
            return true
        case .jsonNull :
            return true
        default:
            return false
        }
    }
    
    /// True if Array contains a Custom Type
    var isNestedArrayType : Bool {
        switch self {
        case .jsonArray(let type) where type.isNestedType :
            return true
        default:
            return false
        }
    }
    
    /// True if Type is a Custom Type
    var isNestedType : Bool {
        switch self {
        case .jsonType(_) :
            return true
        default:
            return false
        }
    }
    
    /// Returns Element Type for an Array Type
    var unNestOneDimension : JSONDataType {
        switch self {
        case .jsonArray(let type) :
            return type
        default:
            return self
        }
    }
    
    /// Returns True if Type is an Array Type with an Array Type as Element
    var isMultiDimensional : Bool {
        switch self {
        case .jsonArray(let type) :
            switch type {
            case .jsonArray(_):
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
    
    /// Returns the number of dimensions in a multi-dimensional Array Type
    var dimensions : Int {
        return gatherDimensions(currentDimension: 0)
    }
    
    /**
     Recursive helper function for `dimensions`
     
     - parameter current: start with 0
     
     - returns: returns the number of dimensions
     */
    private func gatherDimensions(currentDimension current:Int) -> Int {
        switch self {
        case .jsonArray(let type) :
            return type.gatherDimensions(currentDimension: current + 1)
        default:
            return current
        }
    }
    
    /**
     Construct the typeString for an Array Type with Class Prefix
     
     - parameter nameSpace: Class Prefix
     
     - returns: typeString
     */
    func arrayTypeString(withClassPrefix classPrefix:String) -> String {
        switch self {
        case .jsonArray(let type) :
            return type.arrayTypeString(withClassPrefix: classPrefix)
        default:
            return self.typeString(withClassPrefix: classPrefix)
        }
    }
    
    /**
     Construct the typeString with Class Prefix
     
     - parameter nameSpace: Class Prefix
     
     - returns: typeString
     */
    func typeString(withClassPrefix classPrefix:String) -> String {
        switch self {
        case .jsonArray(let type) :
            return "[\(type.typeString(withClassPrefix: classPrefix).uppercaseFirst)]"
        case .jsonType(_) :
            return classPrefix + typeString
        default:
            return typeString
        }
    }
    
    /**
     Change name of Custom Type
     
     - parameter name: the new name
     
     - returns: Custom Type with the new name
     */
    func renameType(withNewName name:String) -> JSONDataType {
        switch self {
        case .jsonType(_) :
            return JSONDataType.jsonType(type: name)
        case .jsonArray(let type) :
            return JSONDataType.jsonArray(type: type.renameType(withNewName: name))
        default :
            return self
        }
    }
    
    /**
     Increase specificity of Type
     
     - parameter toType: Target Type
     
     - returns: Turns an Int into a Double and a Null into a non-nil Type
     */
    func upgrade(toType newType: JSONDataType) -> JSONDataType {
        switch self {
        case .jsonInt :
            if newType == .jsonDouble {
                return .jsonDouble
            } else {
                return self
            }
        case .jsonNull :
            return newType
        case .jsonArray(let type) :
            return .jsonArray(type: type.upgrade(toType: newType))
        default:
            return self
        }
    }
}

/**
 Equality
 
 - parameter lhs: JSONDataType
 - parameter rhs: JSONDataType
 
 - returns: true if typeStrings are equal
 */
func == (lhs:JSONDataType,rhs:JSONDataType) -> Bool {
    return lhs.typeString == rhs.typeString
}

/**
 Inequality
 
 - parameter lhs: JSONDataType
 - parameter rhs: JSONDataType
 
 - returns: true if typeStrings are different
 */
func != (lhs:JSONDataType,rhs:JSONDataType) -> Bool {
    return !(lhs == rhs)
}


