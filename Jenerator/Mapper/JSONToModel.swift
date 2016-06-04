//
//  JSONToModel
//  Jenerator
//
//  Created by Romain Menke on 01/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


struct JSONToSwiftModelGenerator {
    
    var objects : [String:[JSONField]] = [:]
    var source : String?
    var parentType : JSONDataType?
    var nameSpace : String = ""
    var firstIsCollection : Bool = false
    
    mutating func findTypes(parent:String?,key:String?,data:AnyObject) {
        
        if let dict = data as? [String:AnyObject] {
            if objects.isEmpty && dict.count > 1 {
                firstIsCollection = true
                objects["Request"] = []
                parentType = .JSONType(type: "Request")
                for keyValuePair in dict {
                    objects["Request"]?.append(JSONField(name: keyValuePair.0, type: .JSONType(type: keyValuePair.0)))
                    findTypes("Request", key: keyValuePair.0, data: dict)
                }
            } else {
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
            }
        } else {
            findFields(parent, key: key, data: data)
        }
    }
    
    mutating func findFields(parent:String?,key:String?,data:AnyObject) {
        
        // Array Of Objects
        if let dictArray = data as? [[String:AnyObject]] {
            for element in dictArray {
                if let parent = parent, key = key {
                    objects[parent]?.appendUnique(JSONField(name: key, type: .JSONArray(type: .JSONType(type: "\(key)"))))
                }
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
    
    mutating func formatAsSwift() -> String? {
        
        // Generate Data for typealiasses
        var typesToDelete : [(delete:String,keep:String)] = []
        
        for object in objects {
            for possibleDuplicate in objects {
        
                // TypeName must not be equal to other object
                guard object.0 != possibleDuplicate.0 else {
                    continue
                }
                // Fields must be equal to other object
                guard object.1 == possibleDuplicate.1 else {
                    continue
                }
                
                // TypeName must not be present in Keep and Delete must not be present in Delete
                if !(typesToDelete.contains { $0.1 == possibleDuplicate.0 }) && !(typesToDelete.contains { $0.0 == possibleDuplicate.0 }) {
                    typesToDelete.append((delete: possibleDuplicate.0,keep: object.0))
                } else if !(typesToDelete.contains { $0.1 == object.0 }) && !(typesToDelete.contains { $0.0 == object.0 }) {
                    typesToDelete.append((delete: object.0,keep: possibleDuplicate.0))
                }
            }
        }
        
        for delete in typesToDelete {
            objects.removeValueForKey(delete.delete)
        }
        
        for var object in objects {
            for var field in object.1 {
                let duplicateFields = object.1.filter { $0.name == field.name && $0 != field }
                for dupe in duplicateFields {
                    field.type = field.type.upgradeType(dupe.type)
                    if let index = object.1.indexOf(field) {
                        object.1[index] = field
                    }
                    if let dupeIndex = object.1.indexOf(dupe) {
                        object.1.removeAtIndex(dupeIndex)
                    }
                    objects[object.0] = object.1
                }
            }
        }
        
        // Start Generating Code
        var modelString : String = "import Foundation\n\n"
        
        for alias in typesToDelete {
            modelString += "typealias \(nameSpace)\(alias.0.uppercaseFirst) = \(nameSpace)\(alias.1.uppercaseFirst)\n"
        }
        
        modelString += "\n"
        
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
                if firstIsCollection {
                    structString += "            if let dict = json as? [String:AnyObject] {\n"
                } else {
                    structString += "            if let outerDict = json as? [String:AnyObject], let dict = outerDict[\"\(object.0)\"] as? [String:AnyObject] {\n"
                }
                if let parentType = parentType {
                    structString += "                return \(parentType.typeStringWithNameSpace(nameSpace))(data: dict)\n"
                } else {
                    structString += "                return dict\n"
                }
                structString += "            }\n"
                structString += "        } catch {}\n"
                structString += "        return nil\n"
                structString += "    }\n"
            } else if source == nil && object.0.uppercaseFirst == (parentType?.typeString ?? "") {
                structString += "\n    static func fromSource(urlString : String) -> \(parentType?.typeStringWithNameSpace(nameSpace) ?? "AnyObject")? {\n"
                structString += "        guard let url = NSURL(string: urlString), data = NSData(contentsOfURL: url) else {\n"
                structString += "            return nil\n"
                structString += "        }\n"
                structString += "        do {\n"
                structString += "            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)\n"
                if firstIsCollection {
                    structString += "            if let dict = json as? [String:AnyObject] {\n"
                } else {
                    structString += "            if let outerDict = json as? [String:AnyObject], let dict = outerDict[\"\(object.0)\"] as? [String:AnyObject] {\n"
                }
                if let parentType = parentType {
                    structString += "                return \(parentType.typeStringWithNameSpace(nameSpace))(data: dict)\n"
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