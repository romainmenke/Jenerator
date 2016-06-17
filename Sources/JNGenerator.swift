//
//  JNGenerator.swift
//  Jenerator
//
//  Created by Romain Menke on 15/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

protocol JNGenerator {
    
    /**
     Generate File Header
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: File Header as String
     */
    static func fileHeader() -> String
    
    /**
     Generate Aliasses
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: Type Aliasses as String
     */
    static func aliasses(from model: JNModel) -> String
    
    /**
     Generate Comments
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Comments as String
     */
    static func comments(for type: JNCustom) -> String
    
    /**
     Generate Struct Header
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Struct Header as String
     */
    static func header(for type: JNCustom) -> String
    
    /**
     Generate Fields
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fields as String
     */
    static func fields(for type: JNCustom) -> String
    
    /**
     Generate Struct Initialiser
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Initialiser as String
     */
    static func initialiser(for type: JNCustom) -> String
    
    static func arrayContainerInitialiser(for type: JNCustomRootType) -> String
    
    
    /**
     Generate Array Initialiser
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter field:  The current Field
     
     - returns: Initialiser as String
     */
    static func arrayInitialiser(from type: JNCustom, with field: JNField, indent currentIndent:String) -> String
    
    /**
     Generate Fetch Comment
     
     - returns: Default Instructions
     */
    static func fetchComment() -> String
    
    /**
     Generate Fetch for Root Object
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fetch Method as String
     */
    static func fetchSwift2(for type: JNCustom) -> String
    
    static func fancyFetchSwift2(for type: JNCustom) -> String
    
    /**
     Generate Fetch for Root Object
     
     - parameter model: A ModelBuilder that has analysed a JSON
     - parameter type:  The current Type
     
     - returns: Fetch Method as String
     */
    static func fetchSwift3(for type: JNCustom) -> String
    
    static func fancyFetchSwift3(for type: JNCustom) -> String
    
    /**
     Generate Struct Footer
     
     - returns: Struct Footer as String
     */
    static func footer(for type:JNCustom) -> String
    
    /**
     Generate Swift Code based on Model
     
     - parameter model: A ModelBuilder that has analysed a JSON
     
     - returns: Generated Code if the model contained Types.
     */
    static func generate(from model:JNModel) -> String?
}
