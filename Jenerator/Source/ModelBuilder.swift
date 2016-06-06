//
//  ModelBuilder.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

/**
 *  JSON Analyser
 */
public struct ModelBuilder {
    
    /// Types Found in the JSON data
    var types : [JSONCustomType] = []
    
    /// Type Aliasses for Types with the same fields
    var typeAliasses : [JSONTypeAlias] = []
    
    /// Root Object for the query and top level objects
    var root : String
    
    /// top level object is a dictionary, set to false if it is an array
    var dictionaryAtRoot : Bool = true
    
    /// Source Url as String
    var source : String?
    
    /// Class Prefix for all Types
    var classPrefix : String

    /**
     Initialiser
     
     - parameter root:        Name for Root Object
     - parameter classPrefix: Class Prefix for All Types
     - parameter source:      Source Url as String
     
     - returns: a ModelBuilder
     */
    public init(rootName root:String, classPrefix: String, source:String? = nil) {
        self.root = root
        self.classPrefix = classPrefix
        self.source = source
    }
    
    /**
     Array of AnyObject contains Dictionary
     
     - parameter array: an Array
     
     - returns: true if Array.Element is of Type Dictionary
     */
    func arrayContainsObjects(_ array : [AnyObject]) -> Bool {
        var current = array
        while let first = current.first as? [AnyObject] {
            current = first
        }
        
        if let _ = current.first as? [String:AnyObject] {
            return true
        } else {
            return false
        }
    }
    
    /**
     Helper for multi-dimensional Arrays
     
     - parameter name:  name of the Type
     - parameter array: Array
     
     - returns: a JSONDataType and data of the first element that is not an Array
     */
    func buildMultiDimentionalArrayOfObject(_ name:String, array:[AnyObject]) -> (dataType:JSONDataType,content:[String:AnyObject]?) {
        var type = JSONDataType.JSONArray(type: JSONDataType.JSONNull)
        var current = array
        while let first = current.first as? [AnyObject] {
            current = first
            type = type.upgradeType(toType: JSONDataType.JSONArray(type: JSONDataType.JSONNull))
        }
        
        if let content = current.first as? [String:AnyObject] {
            type = type.upgradeType(toType: JSONDataType.JSONType(type: name))
            return (type,content)
        }
        
        return (type,nil)
    }
    
    /**
     Start of Analysis
     
     - parameter data: Data returned from an API call or read from a .json file
     
     - returns: A ModelBuilder containing the constructed Model
     */
    public func buildModel(_ data:AnyObject) -> ModelBuilder {
        if let data = data as? [String:AnyObject] {
            return self.startWithDictionary(data)
        } else if let data = data as? [AnyObject] {
            return self.startWithArray(data)
        }
        return self
    }
    
    /**
     Top level Object is an Array
     
     - parameter data: Data from JSON
     
     - returns: A ModelBuilder containing the constructed Model
     */
    private func startWithArray(_ data:[AnyObject]) -> ModelBuilder {
        var copy = self
        copy.dictionaryAtRoot = false
        let (dataType,content) = copy.buildMultiDimentionalArrayOfObject("element", array: data)
        // create a field for the new type
        let field = JSONField(name: copy.root, type: dataType)
        let type = JSONCustomType(fields: [field], name: copy.root)
        copy.types.appendUnique(type)
        
        // if there was content in the array, go deeper
        if let content = content {
            
            // recursion !!
            let nestedTypes = buildTypes(copy.types, name: "element", fields: content)
            
            // iterate over the nested types
            for type in nestedTypes {
                
                // add only the new types
                copy.types.appendUnique(type)
            }
        }
        
        return copy
    }
    
    /**
     Top level Object is a Dictionary
     
     - parameter data: Data from JSON
     
     - returns: A ModelBuilder containing the constructed Model
     */
    private func startWithDictionary(_ data:[String:AnyObject]) -> ModelBuilder {
        var copy = self
        copy.types = copy.buildTypes(copy.types, name: copy.root, fields: data)
        return copy
    }
    
    /**
     Construct Types
     
     - parameter existingTypes: Current found Types
     - parameter name:          Field name
     - parameter fields:        Data for the field
     
     - returns: An Array of Types
     */
    private func buildTypes(_ existingTypes:[JSONCustomType], name:String, fields:[String:AnyObject]) -> [JSONCustomType] {
        
        var currentTypes = existingTypes
        
        var newCustomType = JSONCustomType(fields: [], name: name)
        
        for keyValuePair in fields {
            
            // Is an array containing an object
            if let array = keyValuePair.1 as? [AnyObject] where arrayContainsObjects(array) {
                
                // retreive datatype and nested content
                let (dataType,content) = buildMultiDimentionalArrayOfObject(keyValuePair.0, array: array)
                
                // create a field for the new type
                let field = JSONField(name: keyValuePair.0, type: dataType)
                
                // add the field to the current type
                newCustomType.fields.appendUnique(field)
                
                // if there was content in the array, go deeper
                if let content = content {
                    
                    // recursion !!
                    let nestedTypes = buildTypes(currentTypes, name: keyValuePair.0, fields: content)
                    
                    // iterate over the nested types
                    for type in nestedTypes {
                        
                        // add only the new types
                        currentTypes.appendUnique(type)
                    }
                }
                continue
            } // Is an array containing an object
            
            
            
            // Is an object
            if let dict = keyValuePair.1 as? [String:AnyObject] {
                
                // user generate to determine the type
                let dataType = JSONDataType.JSONType(type: keyValuePair.0)
                
                // create a field for the new type
                let field = JSONField(name: keyValuePair.0, type: dataType)
                
                // add the field to the current type
                newCustomType.fields.appendUnique(field)
                
                // recursion !!
                let nestedTypes = buildTypes(currentTypes, name: keyValuePair.0, fields: dict)
                
                // iterate over the nested types
                for type in nestedTypes {
                    
                    // add only the new types
                    currentTypes.appendUnique(type)
                }
                
                continue
            } // Is an object
            
            
            
            // Is a value

            // user generate to determine the type
            let dataType = JSONDataType.generate(object: keyValuePair.1)
            
            // create a field for the new type
            let field = JSONField(name: keyValuePair.0, type: dataType)
            
            // add the field to the current type
            newCustomType.fields.appendUnique(field)
            
        }
        
        // add the new type to the current types
        currentTypes.appendUnique(newCustomType)
        
        // return the current types up the chain (cause recursion)
        return currentTypes
        
    }
    
    /**
     Strip duplicate Types from the model
     
     - returns: A ModelBuilder without duplicate Types but with Type Aliasses
     */
    public func findAliasses() -> ModelBuilder {
        var copy = self
        
        for type in copy.types {
            
            if (copy.typeAliasses.contains { $0.alias == type }) {
                continue
            }
            
            let duplicates = types.filter {
                let differentName = $0.name != type.name
                let sameFields = $0.fields == type.fields
                return differentName && sameFields
            }
            
            for dupe in duplicates {
                let alias = JSONTypeAlias(original: type, alias: dupe)
                copy.typeAliasses.appendUnique(alias)
            }
        }
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            
            for alias in copy.typeAliasses {
                if let index = copy.types.indexOf(alias.alias) {
                    copy.types.removeAtIndex(index)
                }
            }
            
        #elseif os(Linux)
            
            for alias in copy.typeAliasses {
                if let index = copy.types.index(of: alias.alias) {
                    copy.types.removeAtIndex(index)
                }
            }
            
        #endif
        
        return copy
    }
}