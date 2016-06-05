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
    case JSONType(type:String)
    
    /**
     *  Array Type
     *
     *  @param type:JSONDataType Type of the array element
     */
    case JSONArray(type:JSONDataType)
    
    /// String Type
    case JSONString
    
    /// Int Type
    case JSONInt
    
    /// FloatingPoint Type
    case JSONDouble
    
    /// Boolean Type
    case JSONBool
    
    /// Nil Type
    case JSONNull
    
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
    static func generate(object:AnyObject) -> JSONDataType {
        
        if let object = object as? [AnyObject] {
            if let first = object.first {
                return JSONDataType.JSONArray(type: JSONDataType.generate(first))
            }
            
            return JSONDataType.JSONArray(type: .JSONNull)
        }
        
        if let number = object as? NSNumber {
            if number.isBool() {
                return JSONDataType.JSONBool
            } else if let int = object as? Int where int == number {
                return JSONDataType.JSONInt
            } else {
                return JSONDataType.JSONDouble
            }
        } else if object is String {
            return JSONDataType.JSONString
        }
            
        return JSONDataType.JSONNull
    }
    
    /// Swift equivalent of JSON type
    var typeString : String {
        get {
            switch self {
            case .JSONString :
                return "String"
            case .JSONBool :
                return "Bool"
            case .JSONInt :
                return "Int"
            case .JSONDouble :
                return "Double"
            case .JSONNull :
                return "Any"
            case .JSONType(let type) :
                return type.uppercaseFirst
            case .JSONArray(let type) :
                return "[\(type.typeString.uppercaseFirst)]"
            }
        }
    }
    
    /// Default value for field initialisation
    var defaultValue : String {
        get {
            switch self {
            case .JSONString :
                return "\"\""
            case .JSONBool :
                return "false"
            case .JSONInt :
                return "0"
            case .JSONDouble :
                return "0.0"
            case .JSONNull :
                return "nil"
            case .JSONType(_) :
                return "nil"
            case .JSONArray(_) :
                return "[]"
            }
        }
    }
    
    /// True if JSONDataType is optional
    var optionalType : Bool {
        switch self {
        case .JSONType(_) :
            return true
        case .JSONNull :
            return true
        default:
            return false
        }
    }
    
    /// True if Array contains a Custom Type
    var isNestedArrayType : Bool {
        switch self {
        case .JSONArray(let type) where type.isNestedType :
            return true
        default:
            return false
        }
    }
    
    /// True if Type is a Custom Type
    var isNestedType : Bool {
        switch self {
        case .JSONType(_) :
            return true
        default:
            return false
        }
    }
    
    /// Returns Element Type for an Array Type
    var unNestOneDimension : JSONDataType {
        switch self {
        case .JSONArray(let type) :
            return type
        default:
            return self
        }
    }
    
    /// Returns True if Type is an Array Type with an Array Type as Element
    var isMultiDimensional : Bool {
        switch self {
        case .JSONArray(let type) :
            switch type {
            case .JSONArray(_):
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
        return gatherDimensions(0)
    }
    
    /**
     Recursive helper function for `dimensions`
     
     - parameter current: start with 0
     
     - returns: returns the number of dimensions
     */
    private func gatherDimensions(current:Int) -> Int {
        switch self {
        case .JSONArray(let type) :
            return type.gatherDimensions(current + 1)
        default:
            return current
        }
    }
    
    /**
     Construct the typeString for an Array Type with Class Prefix
     
     - parameter nameSpace: Class Prefix
     
     - returns: typeString
     */
    func arrayTypeStringWithNameSpace(nameSpace:String) -> String {
        switch self {
        case .JSONArray(let type) :
            return type.arrayTypeStringWithNameSpace(nameSpace)
        default:
            return self.typeStringWithNameSpace(nameSpace)
        }
    }
    
    /**
     Construct the typeString with Class Prefix
     
     - parameter nameSpace: Class Prefix
     
     - returns: typeString
     */
    func typeStringWithNameSpace(nameSpace:String) -> String {
        switch self {
        case .JSONArray(let type) :
            return "[\(type.typeStringWithNameSpace(nameSpace).uppercaseFirst)]"
        case .JSONType(_) :
            return nameSpace + typeString
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
        case .JSONType(_) :
            return JSONDataType.JSONType(type: name)
        case .JSONArray(let type) :
            return JSONDataType.JSONArray(type: type.renameType(withNewName: name))
        default :
            return self
        }
    }
    
    /**
     Increase specificity of Type
     
     - parameter toType: Target Type
     
     - returns: Turns an Int into a Double and a Null into a non-nil Type
     */
    func upgradeType(toType: JSONDataType) -> JSONDataType {
        switch self {
        case .JSONInt :
            if toType == .JSONDouble {
                return .JSONDouble
            } else {
                return self
            }
        case .JSONNull :
            return toType
        case .JSONArray(let type) :
            return .JSONArray(type: type.upgradeType(toType))
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

