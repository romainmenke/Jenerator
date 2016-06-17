//
//  JNDataType.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 Container for JSON Data Types
 
 - type:   Custom Type
 - array:  Array Type
 - string: String
 - int:    Int
 - double: Double
 - bool:   Bool
 - null:   Nil
 */
indirect enum JNDataType : Equatable, CustomStringConvertible {
    
    /**
     *  Custom Type
     *
     *  @param type:String Name for the Custom Type
     */
    case type(type:String)
    
    /**
     *  Array Type
     *
     *  @param type:JNDataType Type of the Array Element
     */
    case array(type:JNDataType)
    
    /// String Type
    case string
    
    /// Int Type
    case int
    
    /// FloatingPoint Type
    case double
    
    /// Boolean Type
    case bool
    
    /// Nil Type
    case null
    
    /// A textual representation of self.
    var description: String {
        get {
            return typeString
        }
    }
    
    /**
     Generate a Type based on an AnyObject
     
     - parameter object: A decoded JSON object
     
     - returns: A JNDataType of the corresponding JSON Type
     
     ```swift
     // create a JNDataType.string
     let stringType = JNDataType.generate(from: ["foo"])
     
     // create a JNDataType.array
     let arrayType = JNDataType.generate(from:["foo","fooz"])
     */
    static func generate(from object:AnyObject) -> JNDataType {
        
        if let object = object as? [AnyObject] {
            if let first = object.first {
                return JNDataType.array(type: JNDataType.generate(from: first))
            }
            
            return JNDataType.array(type: .null)
        }
        
        if let number = object as? NSNumber {
            if number.isBool() {
                return JNDataType.bool
            } else if let int = object as? Int where int == number {
                return JNDataType.int
            } else {
                return JNDataType.double
            }
        } else if object is String {
            return JNDataType.string
        }
            
        return JNDataType.null
    }
    
    /// Swift equivalent of JSON type
    var typeString : String {
        get {
            switch self {
            case .string :
                return "String"
            case .bool :
                return "Bool"
            case .int :
                return "Int"
            case .double :
                return "Double"
            case .null :
                return "Any"
            case .type(let type) :
                return type.uppercaseFirst
            case .array(let type) :
                return "[\(type.typeString.uppercaseFirst)]"
            }
        }
    }
    
    /// Default value for field initialisation
    var defaultValue : String {
        get {
            switch self {
            case .string :
                return "\"\""
            case .bool :
                return "false"
            case .int :
                return "0"
            case .double :
                return "0.0"
            case .null :
                return "nil"
            case .type(_) :
                return "nil"
            case .array(_) :
                return "[]"
            }
        }
    }
    
    /// True if JNDataType is Optional
    var isOptional : Bool {
        switch self {
        case .type(_) :
            return true
        case .null :
            return true
        default:
            return false
        }
    }
    
    /// True if Self is an Array that contains a Custom Type
    var isArrayOfCustomType : Bool {
        switch self {
        case .array(let type) :
            switch type {
            case .array(_) :
                return type.isArrayOfCustomType
            case .type(_) :
                return true
            default : return false
            }
        default:
            return false
        }
    }
    
    /// True if Self is a Custom Type
    var isCustomType : Bool {
        switch self {
        case .type(_) :
            return true
        default:
            return false
        }
    }
    
    /// Returns Element Type for an Array Type or Self if Self isn't an Array Type
    var reduceDimensionOfArray : JNDataType {
        switch self {
        case .array(let type) :
            return type
        default:
            return self
        }
    }
    
    /// Returns True if Type is an Array Type with an Array Type as Element
    var isMultiDimensionalArray : Bool {
        switch self {
        case .array(let type) :
            switch type {
            case .array(_):
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
        return gatherDimensions()
    }
    
    /**
     Recursive helper function for dimensions
     
     - parameter current: start with 0
     
     - returns: returns the number of dimensions
     */
    private func gatherDimensions(currentDimension current:Int = 0) -> Int {
        switch self {
        case .array(let type) :
            return type.gatherDimensions(currentDimension: current + 1)
        default:
            return current
        }
    }
    
    /**
     Construct the typeString for an Array Type with Class Prefix
     
     - parameter nameSpace: Class Prefix
     
     - returns: typeString with Class Prefix
     */
    func arrayTypeString(withClassPrefix classPrefix:String) -> String {
        switch self {
        case .array(let type) :
            return type.arrayTypeString(withClassPrefix: classPrefix)
        default:
            return self.typeString(withClassPrefix: classPrefix)
        }
    }
    
    /**
     Construct the typeString with Class Prefix
     
     - parameter nameSpace: Class Prefix
     
     - returns: typeString with Class Prefix
     */
    func typeString(withClassPrefix classPrefix:String) -> String {
        switch self {
        case .array(let type) :
            return "[\(type.typeString(withClassPrefix: classPrefix).uppercaseFirst)]"
        case .type(_) :
            return classPrefix.uppercased() + typeString
        default:
            return typeString
        }
    }
    
    /**
     Change name of Custom Type
     
     - parameter to: the new name
     
     - returns: Custom Type with the new name
     */
    func rename(to name:String) -> JNDataType {
        switch self {
        case .type(_) :
            return JNDataType.type(type: name)
        case .array(let type) :
            return JNDataType.array(type: type.rename(to: name))
        default :
            return self
        }
    }
    
    /**
     Increase specificity of Type
     
     - parameter to: Target Type
     
     - returns: Turns an Int into a Double and a Null into a non-nil Type
     */
    func upgrade(to newType: JNDataType) -> JNDataType {
        switch self {
        case .int :
            if newType == .double {
                return .double
            } else {
                return self
            }
        case .null :
            return newType
        case .array(let type) :
            return .array(type: type.upgrade(to: newType))
        default:
            return self
        }
    }
}

/**
 Equality
 
 - parameter lhs: JNDataType
 - parameter rhs: JNDataType
 
 - returns: true if typeStrings are equal
 */
func == (lhs:JNDataType,rhs:JNDataType) -> Bool {
    return lhs.typeString == rhs.typeString
}

/**
 Inequality
 
 - parameter lhs: JNDataType
 - parameter rhs: JNDataType
 
 - returns: true if typeStrings are different
 */
func != (lhs:JNDataType,rhs:JNDataType) -> Bool {
    return !(lhs == rhs)
}


