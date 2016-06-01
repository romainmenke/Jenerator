//
//  JSONToModel.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 01/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    mutating func appendUnique(element:Element) {
        if self.contains(element) {
            return
        } else {
            self.append(element)
        }
    }
}

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}

indirect enum JSONDataType : Equatable {
    case JSONArray(type:JSONDataType)
    case JSONDictionary
    case JSONString
    case JSONInt
    case JSONDouble
    case JSONBool
    case JSONNull
    case JSONType(type:String)
    
    var typeString : String {
        get {
            switch self {
            case .JSONString :
                return "String".uppercaseFirst
            case .JSONBool :
                return "Bool".uppercaseFirst
            case .JSONInt :
                return "Int".uppercaseFirst
            case .JSONDouble :
                return "Double".uppercaseFirst
            case .JSONNull :
                return "Any".uppercaseFirst
            case .JSONType(let type) :
                return type.uppercaseFirst
            case .JSONArray(let type) :
                return "[\(type.typeString.uppercaseFirst)]"
            default:
                return ""
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
            default:
                return "nil"
            }
        }
    }
    
    var optionalType : Bool {
        switch self {
        case .JSONType(_) :
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
            return type.typeStringWithNameSpace(nameSpace)
        default:
            return self.typeStringWithNameSpace(nameSpace)
        }
    }
    
    func typeStringWithNameSpace(nameSpace:String) -> String {
        switch self {
        case .JSONArray(let type) :
            return "[\(nameSpace + type.typeString.uppercaseFirst)]"
        case .JSONType(_) :
            return nameSpace + typeString
        default:
            return typeString
        }
    }
}

func == (lhs:JSONDataType,rhs:JSONDataType) -> Bool {
    return lhs.typeString == rhs.typeString
}

struct JSONField : Equatable {
    var name : String
    var type : JSONDataType
}

func == (lhs:JSONField,rhs:JSONField) -> Bool {
    return lhs.name == rhs.name
}

struct JSONToSwiftModelGenerator {
    
    var objects : [String:[JSONField]] = [:]
    var source : String?
    var parentType : JSONDataType?
    var nameSpace : String = ""
    
    mutating func findTypes(parent:String?,key:String?,data:AnyObject) {
        
        if let dict = data as? [String:AnyObject] {
            for keyValuePair in dict {
                if keyValuePair.1 is [String:AnyObject] || keyValuePair.1 is [[String:AnyObject]] {
                    objects[keyValuePair.0] = []
                }
                if parent == nil && key == nil {
                    parentType = .JSONType(type: keyValuePair.0)
                }
                if let parent = parent, key = key {
                    objects[parent]?.appendUnique(JSONField(name: key, type: .JSONType(type: key)))
                }
                findTypes(key, key: keyValuePair.0, data: keyValuePair.1)
            }
        } else {
            findFields(parent, key: key, data: data)
        }
    }
    
    mutating func findFields(parent:String?,key:String?,data:AnyObject) {
        
        // Array Of Objects
        if let dictArray = data as? [[String:AnyObject]] {
            for element in dictArray {
                if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONArray(type: .JSONType(type: "\(key)")))) }
                findTypes(parent, key: key, data: element)
            }
        }
            
            
            // Object
        else if data is [String:AnyObject] {
            if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONType(type: key))) }
            findTypes(parent, key: key, data: data)
        }
            
            // Array
        else if let data = data as? [AnyObject] {
            guard let firstElement = data.first else {
                return
            }
            if firstElement is Double {
                if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONArray(type: .JSONDouble))) }
            } else if firstElement is String {
                if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONArray(type: .JSONString))) }
            } else if firstElement is Bool {
                if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONArray(type: .JSONBool))) }
            } else if firstElement is NSNull {
                if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONArray(type: .JSONNull))) }
            }
        }
            
            
            // Data
            
        else if let int = data as? Int where int == data as? NSNumber {
            if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONInt)) }
        }
            
        else if data is Double {
            if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONDouble)) }
        }
            
        else if data is String {
            if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONString)) }
        }
            
        else if data is Bool {
            if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONBool)) }
        }
            
        else if data is NSNull {
            if let parent = parent, key = key { objects[parent]?.appendUnique(JSONField(name: key, type: .JSONNull)) }
        }
    }
    
    mutating func go(data:AnyObject) {
        findTypes(nil, key: nil, data: data)
    }
    
    func formatAsSwift() -> String? {
        
        var modelString : String = "import Foundation\n"
        
        for object in objects {
            var structString : String = ""
            
            structString += "\n"
            
            // Declaration
            structString += "struct \(nameSpace)\(object.0.uppercaseFirst) {\n\n"
            
            // Fields
            for field in object.1 {
                structString += "    var \(field.name) : \(field.type.typeStringWithNameSpace(nameSpace))"
                if field.type.optionalType {
                    structString += "?\n"
                } else {
                    structString += "\n"
                }
            }
            structString += "\n"
            
            // Initialiser
            structString += "    init(data:[String:AnyObject]) {\n"
            for field in object.1 {
                if field.type.isNestedArrayType {
                    structString += "\n        self.\(field.name) = []\n"
                    structString += "        if let arrayOfNested = data[\"\(field.name)\"] as? [[String:AnyObject]] {\n"
                    structString += "            for element in arrayOfNested {\n"
                    structString += "                self.\(field.name).append(\(field.type.arrayTypeStringWithNameSpace(nameSpace))(data: element))\n"
                    structString += "            }\n"
                    structString += "        }\n"
                } else if field.type.isNestedType {
                    structString += "\n        if let nested = data[\"\(field.name)\"] as? [String:AnyObject] {\n"
                    structString += "            self.\(field.name) = \(field.type.typeStringWithNameSpace(nameSpace))(data: nested)\n"
                    structString += "        }\n"
                } else {
                    structString += "        self.\(field.name) = (data[\"\(field.name)\"] as? \(field.type.typeStringWithNameSpace(nameSpace))) ?? \(field.type.defaultValue)\n"
                }
            }
            structString += "    }\n"
            
            // Fetch
            if let source = source where object.0.uppercaseFirst == (parentType?.typeString ?? "") {
                structString += "\n    static func fromSource() -> \(parentType?.typeStringWithNameSpace(nameSpace) ?? "AnyObject")? {\n"
                structString += "        guard let url = NSURL(string: \"\(source)\"), data = NSData(contentsOfURL: url) else {\n"
                structString += "            return nil\n"
                structString += "        }\n"
                structString += "        do {\n"
                structString += "            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)\n"
                structString += "            if let dict = json as? [String:AnyObject], let objectData = dict[\"\(object.0)\"] as? [String:AnyObject] {\n"
                if let parentType = parentType {
                    structString += "                return \(parentType.typeStringWithNameSpace(nameSpace))(data: objectData)\n"
                } else {
                    structString += "                return dict\n"
                }
                structString += "            }\n"
                structString += "        } catch {}\n"
                structString += "        return nil\n"
                structString += "    }\n"
            }
            
            structString += "}\n"
            
            modelString += structString
        }
        
        return modelString.isEmpty ? nil : modelString
    }
    
    mutating func fromSource(url:NSURL, nameSpace:String) {
        
        self.source = url.absoluteString
        self.nameSpace = nameSpace
        
        guard let data = NSData(contentsOfURL: url) else {
            return
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                go(dict)
            }
        } catch {}
    }
    
    mutating func fromFile(path:String, nameSpace:String) {
        
        self.nameSpace = nameSpace
        
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                go(dict)
            }
        } catch {}
    }
}
