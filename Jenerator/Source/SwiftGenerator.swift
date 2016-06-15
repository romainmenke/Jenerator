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
    private static func generateHeader(fromModel model: ModelBuilder) -> String {
        
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
    private static func generateAliasses(fromModel model: ModelBuilder) -> String {
        
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
    private static func generateStructComments(fromModel model: ModelBuilder,type: JSONCustomType) -> String {
        
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
    private static func generateStructHeader(fromModel model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structHeader = "\n"
        
        structHeader += generateStructComments(fromModel: model, type: type)
        structHeader += "class \(model.classPrefix)\(type.name.uppercaseFirst) {\n"
        structHeader += ""
        
        return structHeader
    }
    
    /**
     Generate Fields
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fields as String
     */
    private static func generateFields(fromModel model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structFields = "\n"
        
        for field in type.fields {
            structFields += "    var \(field.name.lowercased().swiftify()) : \(field.type.typeString(withClassPrefix: model.classPrefix))"
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
    private static func generateStructInitialiser(fromModel model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structInitialiser = "\n"
        
        if type.name.uppercaseFirst == model.root.uppercaseFirst && model.dictionaryAtRoot == false {
            return generateArrayContainerInitialiser(fromModel: model, type: type)
        } else {
            structInitialiser += "    init(data:[String:AnyObject]) {\n"
        }
        
        // for each field
        for field in type.fields {
            // if field is an array
            structInitialiser += "\n"
            if field.type.isNestedArrayType {
                structInitialiser += "        self.\(field.name.lowercased().swiftify()) = []\n"
                structInitialiser += "        if let array = data[\"\(field.name)\"] as? [AnyObject] {\n"
                structInitialiser += generateArrayInitialiser(fromModel: model, field: field, currentIndent: "            ")
                structInitialiser += "        }\n"
            } else if field.type.isNestedType {
                structInitialiser += "        if let object = data[\"\(field.name)\"] as? [String:AnyObject] {\n"
                structInitialiser += "            self.\(field.name.lowercased().swiftify()) = \(field.type.typeString(withClassPrefix: model.classPrefix))(data: object)\n"
                structInitialiser += "        }\n"
            } else {
                structInitialiser += "        self.\(field.name.lowercased().swiftify()) = (data[\"\(field.name)\"] as? \(field.type.typeString(withClassPrefix: model.classPrefix))) ?? \(field.type.defaultValue)\n"
            }
        }
        structInitialiser += "    }\n"
        structInitialiser += ""
        
        return structInitialiser
    }
    
    private static func generateArrayContainerInitialiser(fromModel model: ModelBuilder, type: JSONCustomType) -> String {
        
        var structInitialiser = "\n"
        
        structInitialiser += "    init(array:[AnyObject]) {\n"

        
        // for each field
        for field in type.fields {
            // if field is an array
            structInitialiser += "\n"

            structInitialiser += "        self.\(field.name.lowercased().swiftify()) = []\n"
            structInitialiser += generateArrayInitialiser(fromModel: model, field: field, currentIndent: "        ")
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
    private static func generateArrayInitialiser(fromModel model: ModelBuilder, field: JSONField, currentIndent:String) -> String {
        
        let newIndent = currentIndent + "        "
        
        var arrayInitialiser = ""
        
        arrayInitialiser +=         "\(currentIndent)for element in array {\n"
        if field.type.isMultiDimensional {
            let newField = JSONField(name: field.name, type: field.type.unNestOneDimension)
            arrayInitialiser +=     "\(currentIndent)    if let array = element as? [AnyObject] {\n"
            arrayInitialiser +=     generateArrayInitialiser(fromModel: model, field: newField, currentIndent: newIndent)
            arrayInitialiser +=     "    }\n"
        } else {
            arrayInitialiser +=     "\(currentIndent)    if let element = element as? [String:AnyObject] {\n"
            arrayInitialiser +=     "\(currentIndent)        self.\(field.name.lowercased().swiftify()).append(\(field.type.arrayTypeString(withClassPrefix:model.classPrefix))(data: element))\n"
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
    private static func generateFetch(fromModel model: ModelBuilder, type: JSONCustomType) -> String {
        
        guard type.name.uppercaseFirst == model.root.uppercaseFirst else {
            return ""
        }
        
        var fetchString = "\n"
        
        fetchString += generateFetchComment()
        
        fetchString += generateFancyFetch(fromModel: model, type: type)
        
        fetchString += "            return nil\n"
        fetchString += "        }\n"
        
        
        fetchString += "        do {\n"
        fetchString += "            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)\n"
        
        if type.name.uppercaseFirst == model.root.uppercaseFirst && model.dictionaryAtRoot {
            fetchString += "            if let dict = json as? [String:AnyObject] {\n"
            fetchString += "                return \(model.classPrefix + model.root.uppercaseFirst)(data: dict)\n"
        } else {
            fetchString += "            if let array = json as? [AnyObject] {\n"
            fetchString += "                return \(model.classPrefix + model.root.uppercaseFirst)(array: array)\n"
        }
        fetchString += "            }\n"
        fetchString += "        } catch {}\n"
        fetchString += "        return nil\n"
        fetchString += "    }\n"
        fetchString += ""
        
        return fetchString
    }
    
    private static func generateFancyFetch(fromModel model: ModelBuilder, type: JSONCustomType) -> String {
        
        var declaration : String = ""
        
        if let query = type.query  {
            
            var parameters : String = ""
            
            for (index,pair) in query.params.enumerated() {
                
                if index != 0 {
                    parameters += ", "
                }
                
                parameters += pair.key + ": String?"
                
            }
            
            var queryString : String = query.base + ""
            var paramsEncoding : String = ""
            
            for (index,pair) in query.params.enumerated() {
                
                if index == 0 {
                    queryString += "?"
                }
                
                if index != 0 {
                    queryString += "&"
                }
                
                paramsEncoding += "let \(pair.key)Encoded = (\(pair.key) ?? \"\(pair.value)\").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? \"\"\n"
                
                let encoded = pair.key.urlEncoding ?? pair.key
                queryString += encoded + "=" + "\\(\(pair.key)Encoded)"
                
            }
            
            declaration += "    static func fromSource(\(parameters)) -> \(model.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            
            declaration += "        \(paramsEncoding)\n"
            
            declaration += "        guard let url = NSURL(string: \"\(queryString)\"), data = NSData(contentsOfURL: url) else {\n"
        } else if type.query?.source == nil {
            declaration += "    static func fromSource(urlString : String) -> \(model.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            declaration += "        guard let url = NSURL(string: urlString), data = NSData(contentsOfURL: url) else {\n"
        }
        
        return declaration
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
    public static func generate(fromModel model:ModelBuilder) -> String? {
        
        guard model.types.count > 0 else {
            return nil
        }
        
        // Start Generating Code
        var modelString = ""
        
        modelString += generateHeader(fromModel: model)
        modelString += generateAliasses(fromModel: model)
        
        for type in model.types {
            
            modelString += generateStructHeader(fromModel: model, type: type)
            modelString += generateFields(fromModel: model, type: type)
            modelString += generateStructInitialiser(fromModel: model, type: type)
            modelString += generateFetch(fromModel: model, type: type)
            modelString += generateStructFooter()
            
        }
        return modelString
    }
}
