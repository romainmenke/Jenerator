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
public struct JNModel {
    
    /// Types Found in the JSON data
    var types : [JNCustom] = []
    
    /// Type Aliasses for Types with the same fields
    var typeAliasses : [JNTypeAlias] = []
    

    init() {}
    
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
    func buildMultiDimentionalArrayOfObject(withName name:String, array:[AnyObject]) -> (dataType:JNDataType,content:[String:AnyObject]?) {
        var type = JNDataType.array(type: JNDataType.null)
        var current = array
        while let first = current.first as? [AnyObject] {
            current = first
            type = type.upgrade(to: JNDataType.array(type: JNDataType.null))
        }
        
        if let content = current.first as? [String:AnyObject] {
            type = type.upgrade(to: JNDataType.type(type: name))
            return (type,content)
        }
        
        return (type,nil)
    }
    
    #if swift(>=3.0)
    /**
     Start of Analysis
     
     - parameter data: Data returned from an API call or read from a .json file
     
     - returns: A ModelBuilder containing the constructed Model
     */
    public func build(fromData data:AnyObject, withRootName root: String, source: URL?, andClassPrefix classPrefix: String) -> JNModel {
        if let data = data as? [String:AnyObject] {
            return self.startWithDictionary(fromData: data, withRootName: root, source: source, andClassPrefix: classPrefix)
        } else if let data = data as? [AnyObject] {
            return self.startWithArray(fromData: data, withRootName: root, source: source, andClassPrefix: classPrefix)
        }
        return self
    }
    #elseif swift(>=2.2)
    /**
     Start of Analysis
     
     - parameter data: Data returned from an API call or read from a .json file
     
     - returns: A ModelBuilder containing the constructed Model
     */
    public func build(fromData data:AnyObject, withRootName root: String, source: NSURL?, andClassPrefix classPrefix: String) -> JNModel {
        if let data = data as? [String:AnyObject] {
            return self.startWithDictionary(fromData: data, withRootName: root, source: source, andClassPrefix: classPrefix)
        } else if let data = data as? [AnyObject] {
            return self.startWithArray(fromData: data, withRootName: root, source: source, andClassPrefix: classPrefix)
        }
        return self
    }
    #endif

    
    /**
     Top level Object is an Array
     
     - parameter data: Data from JSON
     
     - returns: A ModelBuilder containing the constructed Model
     */
    private func startWithArray(fromData data:[AnyObject], withRootName root: String, source: VURL?, andClassPrefix classPrefix: String) -> JNModel {
        var copy = self
        let (dataType,content) = copy.buildMultiDimentionalArrayOfObject(withName: "jeneratorElement", array: data)
        // create a field for the new type
        let field = JNField(name: "elements", type: dataType)
        var type = JNCustomRootType(fields: [field], name: root, classPrefix: classPrefix)
        if let source = source { type.query = JNQuery(source: source) }
        type.isDictionary = false
        
        copy.types = add(newType: type, toExistingTypes: copy.types)
        
        // if there was content in the array, go deeper
        if let content = content {
            
            // recursion !!
            let nestedTypes = buildTypes(withExistingTypes: copy.types, name: "jeneratorElement", andClassPrefix: classPrefix, fields: content)
            
            // iterate over the nested types
            for type in nestedTypes {
                
                // add only the new types
                copy.types = add(newType: type, toExistingTypes: copy.types)
            }
        }
        
        return copy
    }
    
    /**
     Top level Object is a Dictionary
     
     - parameter data: Data from JSON
     
     - returns: A ModelBuilder containing the constructed Model
     */
    private func startWithDictionary(fromData data:[String:AnyObject], withRootName root: String, source: VURL?, andClassPrefix classPrefix: String) -> JNModel {
        var copy = self
        copy.types = copy.buildTypes(withExistingTypes: copy.types, name: root, andClassPrefix: classPrefix, fields: data, isRoot: true, source: source)
        return copy
    }
    
    /**
     Construct Types
     
     - parameter existingTypes: Current found Types
     - parameter name:          Field name
     - parameter fields:        Data for the field
     
     - returns: An Array of Types
     */
    private func buildTypes(withExistingTypes existingTypes:[JNCustom], name:String, andClassPrefix classPrefix: String, fields:[String:AnyObject], isRoot: Bool = false, source: VURL? = nil) -> [JNCustom] {
        
        var currentTypes = existingTypes
        
        var newCustomType : JNCustom = JNCustomType(fields: [], name: name, classPrefix: classPrefix)
        
        if isRoot {
            var rootType = JNCustomRootType(fields: [], name: name, classPrefix: classPrefix)
            rootType.isDictionary = true
            if let source = source { rootType.query = JNQuery(source: source) }
            newCustomType = rootType
        }
        
        for keyValuePair in fields {
            
            // Is an array containing an object
            if let array = keyValuePair.1 as? [AnyObject] where arrayContainsObjects(array) {
                
                // retrieve datatype and nested content
                let (dataType,content) = buildMultiDimentionalArrayOfObject(withName: keyValuePair.0, array: array)
                
                // create a field for the new type
                let field = JNField(name: keyValuePair.0, type: dataType)
                
                // add the field to the current type
                newCustomType.fields.appendUnique(field)
                
                // if there was content in the array, go deeper
                if let content = content {
                    
                    // recursion !!
                    let nestedTypes = buildTypes(withExistingTypes: currentTypes, name: keyValuePair.0, andClassPrefix: classPrefix, fields: content)
                    
                    // iterate over the nested types
                    for type in nestedTypes {
                        
                        // add only the new types
                        currentTypes = add(newType: type, toExistingTypes: currentTypes)
                    }
                }
                continue
            } // Is an array containing an object
            
            
            
            // Is an object
            if let dict = keyValuePair.1 as? [String:AnyObject] {
                
                // user generate to determine the type
                let dataType = JNDataType.type(type: keyValuePair.0)
                
                // create a field for the new type
                let field = JNField(name: keyValuePair.0, type: dataType)
                
                // add the field to the current type
                newCustomType.fields.appendUnique(field)
                
                // recursion !!
                let nestedTypes = buildTypes(withExistingTypes: currentTypes, name: keyValuePair.0, andClassPrefix: classPrefix, fields: dict)
                
                // iterate over the nested types
                for type in nestedTypes {
                    
                    // add only the new types
                    currentTypes = add(newType: type, toExistingTypes: currentTypes)
                }
                
                continue
            } // Is an object
            
            
            
            // Is a value

            // user generate to determine the type
            let dataType = JNDataType.generate(from: keyValuePair.1)
            
            // create a field for the new type
            let field = JNField(name: keyValuePair.0, type: dataType)
            
            // add the field to the current type
            newCustomType.fields.appendUnique(field)
            
        }
        
        // add the new type to the current types
        currentTypes = add(newType: newCustomType, toExistingTypes: currentTypes)
        
        // return the current types up the chain (cause recursion)
        return currentTypes
        
    }
    
    private func add(newType new:JNCustom,toExistingTypes existingTypes:[JNCustom]) -> [JNCustom] {
        
        var copy = existingTypes
        
        let index = copy.index { (type) -> Bool in
            type.name == new.name
        }
        
        if let index = index {
            var current = copy[index]
            for field in new.fields {
                current.fields.appendUnique(field)
            }
            copy[index] = current
        } else {
            copy.append(new)
        }
        
        return copy
    }
    
    /**
     Strip duplicate Types from the model
     
     - returns: A ModelBuilder without duplicate Types but with Type Aliasses
     */
    public func findAliasses() -> JNModel {
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
                let alias = JNTypeAlias(original: type, alias: dupe)
                copy.typeAliasses.appendUnique(alias)
            }
        }
        
        for alias in copy.typeAliasses {
            let index = copy.types.index { (type) -> Bool in
                type == alias.alias
            }
            if let index = index {
                copy.types.remove(at: index)
            }
        }
        
        return copy
    }
    
    
    public func isCompatible(withModel model: JNModel) -> Bool {
        
        for currentType in types {
            var foundCompatibleType = false
            for newType in model.types {
                if currentType.isCompatible(with: newType) {
                    foundCompatibleType = true
                }
            }
            if !foundCompatibleType {
                return false
            }
        }
        
        return true
    }
}
