//
//  JSONDataType.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


indirect enum JSONDataType : Equatable, CustomStringConvertible {
    case JSONType(type:String)
    case JSONArray(type:JSONDataType)
    case JSONString
    case JSONInt
    case JSONDouble
    case JSONBool
    case JSONNull
    
    var description: String {
        get {
            return typeString
        }
    }
    
    static func generate(object:AnyObject) -> JSONDataType {
        
        if let object = object as? [AnyObject] {
            if let first = object.first {
                return JSONDataType.JSONArray(type: JSONDataType.generate(first))
            } else {
                return JSONDataType.JSONArray(type: .JSONNull)
            }
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
    
    var isNestedArrayType : Bool {
        switch self {
        case .JSONArray(let type) where type.isNestedType :
            return true
        default:
            return false
        }
    }
    
    var unNestOneDimension : JSONDataType {
        switch self {
        case .JSONArray(let type) :
            return type
        default:
            return self
        }
    }
    
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
    
    var dimensions : Int {
        return gatherDimensions(0)
    }
    
    private func gatherDimensions(current:Int) -> Int {
        switch self {
        case .JSONArray(let type) :
            return type.gatherDimensions(current + 1)
        default:
            return current
        }
    }
    
    var isNestedType : Bool {
        switch self {
        case .JSONType(_) :
            return true
        default:
            return false
        }
    }
    
    func arrayTypeStringWithNameSpace(nameSpace:String) -> String {
        switch self {
        case .JSONArray(let type) :
            return type.arrayTypeStringWithNameSpace(nameSpace)
        default:
            return self.typeStringWithNameSpace(nameSpace)
        }
    }
    
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

func == (lhs:JSONDataType,rhs:JSONDataType) -> Bool {
    return lhs.typeString == rhs.typeString
}

func != (lhs:JSONDataType,rhs:JSONDataType) -> Bool {
    return !(lhs == rhs)
}


