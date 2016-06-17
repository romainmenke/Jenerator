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
public struct SwiftGenerator : JNGenerator {
    
    /**
     Generate File Header
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: File Header as String
     */
    static func fileHeader() -> String {
        
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
    static func aliasses(from model: JNModel) -> String {
        
        guard model.typeAliasses.count > 0 else {
            return ""
        }
        var aliasses = "\n"
        
        aliasses += "// TypeAliasses : \n"
        
        for alias in model.typeAliasses {
            aliasses += "typealias \(alias.alias.classPrefix)\(alias.alias.name.uppercaseFirst) = \(alias.original.classPrefix)\(alias.original.name.uppercaseFirst)\n"
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
    static func comments(for type: JNCustom) -> String {
        
        var structComment = ""
        
        structComment += "/**\n"
        structComment += " *  Your Description For \(type.classPrefix)\(type.name.uppercaseFirst) Goes Here\n"
        structComment += " */\n"
        
        return structComment
    }
    
    /**
     Generate Struct Header
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Struct Header as String
     */
    static func header(for type: JNCustom) -> String {
        
        var structHeader = "\n"
        
        structHeader += comments(for: type)
        structHeader += "class \(type.classPrefix)\(type.name.uppercaseFirst) {\n"
        structHeader += ""
        
        return structHeader
    }
    
    /**
     Generate Fields
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fields as String
     */
    static func fields(for type: JNCustom) -> String {
        
        var structFields = "\n"
        
        for field in type.fields {
            structFields += "    var \(field.name.lowercaseFirst.swiftifiedFieldName) : \(field.type.typeString(withClassPrefix: type.classPrefix))"
            if field.type.isOptional {
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
    static func initialiser(for type: JNCustom) -> String {
        
        var structInitialiser = "\n"
        
        if let type = type as? JNCustomRootType where type.isDictionary == false {
            return arrayContainerInitialiser(for: type)
        } else {
            structInitialiser += "    init(data:[String:AnyObject]) {\n"
        }
        
        // for each field
        for field in type.fields {
            // if field is an array
            structInitialiser += "\n"
            if field.type.isArrayOfCustomType {
                structInitialiser += "        self.\(field.name.lowercaseFirst.swiftifiedFieldName) = []\n"
                structInitialiser += "        if let array = data[\"\(field.name)\"] as? [AnyObject] {\n"
                structInitialiser += arrayInitialiser(from: type, with: field, indent: "            ")
                structInitialiser += "        }\n"
            } else if field.type.isCustomType {
                structInitialiser += "        if let object = data[\"\(field.name)\"] as? [String:AnyObject] {\n"
                structInitialiser += "            self.\(field.name.lowercaseFirst.swiftifiedFieldName) = \(field.type.typeString(withClassPrefix: type.classPrefix))(data: object)\n"
                structInitialiser += "        }\n"
            } else {
                structInitialiser += "        self.\(field.name.lowercaseFirst.swiftifiedFieldName) = (data[\"\(field.name)\"] as? \(field.type.typeString(withClassPrefix: type.classPrefix))) ?? \(field.type.defaultValue)\n"
            }
        }
        structInitialiser += "    }\n"
        structInitialiser += ""
        
        return structInitialiser
    }
    
    static func arrayContainerInitialiser(for type: JNCustomRootType) -> String {
        
        var structInitialiser = "\n"
        
        structInitialiser += "    init(array:[AnyObject]) {\n"

        
        // for each field
        for field in type.fields {
            // if field is an array
            structInitialiser += "\n"

            structInitialiser += "        self.\(field.name.lowercaseFirst.swiftifiedFieldName) = []\n"
            structInitialiser += arrayInitialiser(from: type, with: field, indent: "        ")
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
    static func arrayInitialiser(from type: JNCustom, with field: JNField, indent currentIndent:String) -> String {
        
        let newIndent = currentIndent + "        "
        
        var arrayInitialiserString = ""
        
        arrayInitialiserString +=         "\(currentIndent)for element in array {\n"
        if field.type.isMultiDimensionalArray {
            let newField = JNField(name: field.name, type: field.type.reduceDimensionOfArray)
            arrayInitialiserString +=     "\(currentIndent)    if let array = element as? [AnyObject] {\n"
            arrayInitialiserString +=     arrayInitialiser(from: type, with: newField, indent: newIndent)
            arrayInitialiserString +=     "    }\n"
        } else {
            arrayInitialiserString +=     "\(currentIndent)    if let element = element as? [String:AnyObject] {\n"
            arrayInitialiserString +=     "\(currentIndent)        self.\(field.name.lowercaseFirst.swiftifiedFieldName).append(\(field.type.arrayTypeString(withClassPrefix:type.classPrefix))(data: element))\n"
            arrayInitialiserString +=     "\(currentIndent)    }\n"
        }
        arrayInitialiserString +=         "\(currentIndent)}\n"
        
        return arrayInitialiserString
    }
    
    /**
     Generate Fetch Comment
     
     - returns: Default Instructions
     */
    static func fetchComment() -> String {
        
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
    static func fetchSwift2(for type: JNCustom) -> String {
        
        guard let type = type as? JNCustomRootType else {
            return ""
        }
        
        var fetchString = "\n"
        
        fetchString += "#elseif swift(>=2.2)\n"
        
        fetchString += fancyFetchSwift2(for: type)
        
        fetchString += "        do {\n"
        fetchString += "            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)\n"
        
        if type.isDictionary {
            fetchString += "            if let dict = json as? [String:AnyObject] {\n"
            fetchString += "                return \(type.classPrefix + type.name.uppercaseFirst)(data: dict)\n"
        } else {
            fetchString += "            if let array = json as? [AnyObject] {\n"
            fetchString += "                return \(type.classPrefix + type.name.uppercaseFirst)(array: array)\n"
        }
        fetchString += "            }\n"
        fetchString += "        } catch {}\n"
        fetchString += "        return nil\n"
        fetchString += "    }\n"
        fetchString += ""
        
        fetchString += "#endif\n"
        
        return fetchString
    }
    
    static func fancyFetchSwift2(for type: JNCustom) -> String {
        
        var declaration : String = ""
        
        if let root = type as? JNCustomRootType, let query = root.query  {
            
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
                
                paramsEncoding += "let \(pair.key)Encoded = (\(pair.key) ?? \"\(pair.value.swiftifiedStringLiteral)\").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? \"\"\n"
                
                let encoded = pair.key.urlEncoding ?? pair.key
                queryString += encoded + "=" + "\\(\(pair.key)Encoded)"
                
            }
            
            declaration += "    static func fetch(\(parameters)) -> \(type.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            
            declaration += "        \(paramsEncoding)\n"
            
            declaration += "        guard let url = NSURL(string: \"\(queryString)\"), data = NSData(contentsOfURL: url) else {\n"
            declaration += "            return nil\n"
            declaration += "        }\n"
        } else if let root = type as? JNCustomRootType where root.query == nil {
            declaration += "    static func fromSource(urlString : String) -> \(type.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            declaration += "        guard let url = NSURL(string: urlString), data = NSData(contentsOfURL: url) else {\n"
            declaration += "            return nil\n"
            declaration += "        }\n"
        }
        
        return declaration
    }
    
    /**
     Generate Fetch for Root Object
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fetch Method as String
     */
    static func fetchSwift3(for type: JNCustom) -> String {
        
        guard let type = type as? JNCustomRootType else {
            return ""
        }
        
        var fetchString = "\n"
        
        fetchString += fetchComment()
        
        fetchString += "#if swift(>=3.0)\n"
        
        fetchString += fancyFetchSwift3(for: type)
        
        fetchString += "        do {\n"
        fetchString += "            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)\n"
        
        if type.isDictionary {
            fetchString += "            if let dict = json as? [String:AnyObject] {\n"
            fetchString += "                return \(type.classPrefix + type.name.uppercaseFirst)(data: dict)\n"
        } else {
            fetchString += "            if let array = json as? [AnyObject] {\n"
            fetchString += "                return \(type.classPrefix + type.name.uppercaseFirst)(array: array)\n"
        }
        fetchString += "            }\n"
        fetchString += "        } catch {}\n"
        fetchString += "        return nil\n"
        fetchString += "    }\n"
        fetchString += ""
        
        return fetchString
    }
    
    static func fancyFetchSwift3(for type: JNCustom) -> String {
        
        var declaration : String = ""
        
        if let root = type as? JNCustomRootType, let query = root.query  {
            
            var parameters : String = ""
            
            for (index,pair) in query.params.enumerated() {
                
                if index != 0 {
                    parameters += ", "
                }
                
                parameters += pair.key + ": String?"
                
            }
            
            var paramsEncoding : String = ""
            var components : String = ""
            
            for (index,pair) in query.params.enumerated() {
                
                paramsEncoding += "        let \(pair.key) = \(pair.key) ?? \"\(pair.value.swiftifiedStringLiteral)\"\n"
                paramsEncoding += "        let \(pair.key)Item = URLQueryItem(name: \"\(pair.key)\", value: \(pair.key))\n\n"
                
                if index != 0 { components += "," }
                components += "\(pair.key)Item"
                
            }
            
            paramsEncoding += "        guard var urlComponents = URLComponents(string: \"\(query.base)\") else {\n"
            paramsEncoding += "            return nil\n"
            paramsEncoding += "        }\n\n"
            paramsEncoding += "        urlComponents.queryItems = [\(components)]\n"
            
            declaration += "    static func fetch(\(parameters)) -> \(type.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            
            declaration += paramsEncoding
            
            declaration += "        guard let url = urlComponents.url, data = try? Data(contentsOf: url) else {\n"
            declaration += "            return nil\n"
            declaration += "        }\n"
        } else if let root = type as? JNCustomRootType where root.query == nil {
            declaration += "    static func fromSource(urlString : String) -> \(type.classPrefix)\(type.name.uppercaseFirst)? {\n\n"
            declaration += "        guard let url = urlComponents.url, data = try? Data(contentsOf: url) else {\n"
            declaration += "            return nil\n"
            declaration += "        }\n"
        }
        
        return declaration
    }
    
    /**
     Generate Struct Footer
     
     - returns: Struct Footer as String
     */
    static func footer(for type:JNCustom) -> String {
        
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
    public static func generate(from model:JNModel) -> String? {
        
        guard model.types.count > 0 else {
            return nil
        }
        
        // Start Generating Code
        var modelString = ""
        
        modelString += fileHeader()
        modelString += aliasses(from: model)
        
        for type in model.types {
            
            modelString += header(for: type)
            modelString += fields(for: type)
            modelString += initialiser(for: type)
            modelString += fetchSwift3(for: type)
            modelString += fetchSwift2(for: type)
            modelString += footer(for: type)
            
        }
        return modelString
    }
}
