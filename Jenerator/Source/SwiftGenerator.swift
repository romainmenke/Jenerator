//
//  SwiftGenerator.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

public struct SwiftGenerator {
    
    private static func generateHeader(model model: ModelBuilder) -> String {
        
        var header : String = ""
        header += "// Generated with Jenerator : github.com/romainmenke/Jenerator\n\n"
        header += "import Foundation\n\n"
        return header
        
    }
    
    private static func generateAliasses(model model: ModelBuilder) -> String {
        
        guard model.typeAliasses.count > 0 else {
            return ""
        }
        
        var aliasses : String = "\n"
        for alias in model.typeAliasses {
            aliasses += "typealias \(model.classPrefix)\(alias.alias.name.uppercaseFirst) = \(model.classPrefix)\(alias.original.name.uppercaseFirst)\n"
        }
        aliasses += "\n"
        return aliasses
    }
    
    private static func generateStructHeader(model model: ModelBuilder, type: JSONCustomType) -> String {
        var structHeader : String = "\n"
        structHeader += "struct \(model.classPrefix)\(type.name.uppercaseFirst) {\n"
        structHeader += "\n"
        return structHeader
    }
    
    private static func generateFields(model model: ModelBuilder, type: JSONCustomType) -> String {
        var structFields : String = ""
        for field in type.fields {
            structFields += "    var \(field.name) : \(field.type.typeStringWithNameSpace(model.classPrefix))"
            if field.type.optionalType {
                structFields += "?\n"
            } else {
                structFields += "\n"
            }
        }
        structFields += "\n"
        
        return structFields
    }
    
    private static func generateStructInitialiser(model model: ModelBuilder, type: JSONCustomType) -> String {
        var structInitialiser : String = "\n"
        structInitialiser += "    init(data:[String:AnyObject]) {\n"
        
        // for each field
        for field in type.fields {
            // if field is an array
            if field.type.isNestedArrayType {
                structInitialiser += "\n        self.\(field.name) = []\n"
                structInitialiser += "        if let array = data[\"\(field.name)\"] as? [AnyObject] {\n"
                structInitialiser += generateArrayInitialiser(model: model, field: field, currentIndent: "            ")
                structInitialiser += "        }\n"
            } else if field.type.isNestedType {
                structInitialiser += "\n        if let object = data[\"\(field.name)\"] as? [String:AnyObject] {\n"
                structInitialiser += "            self.\(field.name) = \(field.type.typeStringWithNameSpace(model.classPrefix))(data: object)\n"
                structInitialiser += "        }\n"
            } else {
                structInitialiser += "        self.\(field.name) = (data[\"\(field.name)\"] as? \(field.type.typeStringWithNameSpace(model.classPrefix))) ?? \(field.type.defaultValue)\n"
            }
        }
        structInitialiser += "    }\n"
        return structInitialiser
    }
    
    
    
    private static func generateArrayInitialiser(model model: ModelBuilder, field: JSONField, currentIndent:String) -> String {
        
        let newIndent = currentIndent + "        "
        
        var arrayInitialiser : String = ""
        arrayInitialiser +=         "\(currentIndent)for element in array {\n"
        if field.type.isMultiDimensional {
            let newField = JSONField(name: field.name, type: field.type.unNestOneDimension)
            arrayInitialiser +=     "\(currentIndent)    if let array = element as? [AnyObject] {\n"
            arrayInitialiser +=     generateArrayInitialiser(model: model, field: newField, currentIndent: newIndent)
            arrayInitialiser +=     "    }\n"
        } else {
            arrayInitialiser +=     "\(currentIndent)    if let element = element as? [String:AnyObject] {\n"
            arrayInitialiser +=     "\(currentIndent)        self.\(field.name).append(\(field.type.arrayTypeStringWithNameSpace(model.classPrefix))(data: element))\n"
            arrayInitialiser +=     "\(currentIndent)    }\n"
        }
        arrayInitialiser +=         "\(currentIndent)}\n"
        
        return arrayInitialiser
    }
    
    private static func generateFetch(model model: ModelBuilder, type: JSONCustomType) -> String {
        
        var fetchString = ""
        
        guard type.name.uppercaseFirst == model.root.uppercaseFirst && model.dictionaryAtRoot else {
            return ""
        }
        
        if let source = model.source {
            fetchString += "    static func fromSource() -> \(model.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            fetchString += "        guard let url = NSURL(string: \"\(source)\"), data = NSData(contentsOfURL: url) else {\n"
        } else if model.source == nil {
            fetchString += "    static func fromSource(urlString : String) -> \(model.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            fetchString += "        guard let url = NSURL(string: urlString), data = NSData(contentsOfURL: url) else {\n"
        }
        
        fetchString += "            return nil\n"
        fetchString += "        }\n"
        
        
        fetchString += "        do {\n"
        fetchString += "            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)\n"
        fetchString += "            if let dict = json as? [String:AnyObject] {\n"
        fetchString += "                return \(model.classPrefix + model.root)(data: dict)\n"
        fetchString += "            }\n"
        fetchString += "        } catch {}\n"
        fetchString += "        return nil\n"
        fetchString += "    }\n"
        
        return fetchString
    }
    
    
    private static func generateStructFooter() -> String {
        var structFooter : String = "\n"
        structFooter += "}\n"
        structFooter += "\n"
        return structFooter
    }
    
    public static func generate(model model:ModelBuilder) -> String? {
        
        guard model.types.count > 0 else {
            return nil
        }
        
        // Start Generating Code
        var modelString : String = ""
        
        modelString += generateHeader(model: model)
        modelString += generateAliasses(model: model)
        
        for type in model.types {
            
            modelString += generateStructHeader(model: model, type: type)
            modelString += generateFields(model: model, type: type)
            modelString += generateStructInitialiser(model: model, type: type)
            modelString += generateFetch(model: model, type: type)
            modelString += generateStructFooter()
            
        }
        return modelString
    }
}