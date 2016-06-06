//
//  SwiftGenerator.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


/**
 *  Swift Lang Code Generator
 */
public struct SwiftGenerator {
    
    /**
     Generate File Header
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: File Header as String
     */
    private static func generateHeader(model model: ModelBuilder) -> String {
        
        var header = "\n"
        
        header += "// Generated with Jenerator : github.com/romainmenke/Jenerator\n"
        header += "\n"
        header += "import Foundation\n"
        
        return header
        
    }
    
    /**
     Generate Aliasses
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: Type Aliasses as String
     */
    private static func generateAliasses(model model: ModelBuilder) -> String {
        
        guard model.typeAliasses.count > 0 else {
            return ""
        }
        var aliasses = "\n"
        
        aliasses += "// TypeAliasses : \n"
        
        for alias in model.typeAliasses {
            aliasses += "typealias \(model.classPrefix)\(alias.alias.name.uppercaseFirst) = \(model.classPrefix)\(alias.original.name.uppercaseFirst)\n"
        }
        aliasses += ""
        
        return aliasses
    }
    
    /**
     Generate Comments
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Comments as String
     */
    private static func generateStructComments(model model: ModelBuilder,type: JSONCustomType) -> String {
        
        var structComment = ""
        
        structComment += "/**\n"
        structComment += " *  Your Description For \(model.classPrefix)\(type.name.uppercaseFirst) Goes Here\n"
        structComment += " */\n"
        
        return structComment
    }
    
    /**
     Generate Struct Header
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Struct Header as String
     */
    private static func generateStructHeader(model model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structHeader = "\n"
        
        structHeader += generateStructComments(model: model, type: type)
        structHeader += "struct \(model.classPrefix)\(type.name.uppercaseFirst) {\n"
        structHeader += ""
        
        return structHeader
    }
    
    /**
     Generate Fields
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fields as String
     */
    private static func generateFields(model model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structFields = "\n"
        
        for field in type.fields {
            structFields += "    var \(field.name) : \(field.type.typeStringWithNameSpace(model.classPrefix))"
            if field.type.optionalType {
                structFields += "?\n"
            } else {
                structFields += "\n"
            }
        }
        structFields += ""
        
        return structFields
    }
    
    /**
     Generate Struct Initialiser
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Initialiser as String
     */
    private static func generateStructInitialiser(model model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structInitialiser = "\n"
        
        structInitialiser += "    init(data:[String:AnyObject]) {\n"
        
        // for each field
        for field in type.fields {
            // if field is an array
            structInitialiser += "\n"
            if field.type.isNestedArrayType {
                structInitialiser += "        self.\(field.name) = []\n"
                structInitialiser += "        if let array = data[\"\(field.name)\"] as? [AnyObject] {\n"
                structInitialiser += generateArrayInitialiser(model: model, field: field, currentIndent: "            ")
                structInitialiser += "        }\n"
            } else if field.type.isNestedType {
                structInitialiser += "        if let object = data[\"\(field.name)\"] as? [String:AnyObject] {\n"
                structInitialiser += "            self.\(field.name) = \(field.type.typeStringWithNameSpace(model.classPrefix))(data: object)\n"
                structInitialiser += "        }\n"
            } else {
                structInitialiser += "        self.\(field.name) = (data[\"\(field.name)\"] as? \(field.type.typeStringWithNameSpace(model.classPrefix))) ?? \(field.type.defaultValue)\n"
            }
        }
        structInitialiser += "    }\n"
        structInitialiser += ""
        
        return structInitialiser
    }
    
    /**
     Generate Array Initialiser
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter field:  The current Field
     
     - returns: Initialiser as String
     */
    private static func generateArrayInitialiser(model model: ModelBuilder, field: JSONField, currentIndent:String) -> String {
        
        let newIndent = currentIndent + "        "
        
        var arrayInitialiser = ""
        
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
    
    /**
     Generate Fetch Comment
     
     - returns: Default Instructions
     */
    private static func generateFetchComment() -> String {
        
        var fetchComment = ""
        
        fetchComment += "    /**\n"
        fetchComment += "     Give this function some parameters to make the query a bit more dynamic\n"
        fetchComment += "    \n"
        fetchComment += "     - returns: Your Return Description Here.\n"
        fetchComment += "     */\n"
        
        return fetchComment
    }
    
    /**
     Generate Fetch for Root Object
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fetch Method as String
     */
    private static func generateFetch(model model: ModelBuilder, type: JSONCustomType) -> String {
        
        var fetchString = "\n"
        
        fetchString += generateFetchComment()
        
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
        fetchString += ""
        
        return fetchString
    }
    
    /**
     Generate Struct Footer
     
     - returns: Struct Footer as String
     */
    private static func generateStructFooter() -> String {
        
        var structFooter = ""
        
        structFooter += "}\n"
        structFooter += "\n\n"
        
        return structFooter
    }
    
    /**
     Generate Swift Code based on Model
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: Generated Code if the model contained Types.
     */
    public static func generate(model model:ModelBuilder) -> String? {
        
        guard model.types.count > 0 else {
            return nil
        }
        
        // Start Generating Code
        var modelString = ""
        
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