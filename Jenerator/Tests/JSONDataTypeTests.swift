//
//  JSONDataTypeTests.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JSONDataTypeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGenerate() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType == JSONDataType.jsonString)
        XCTAssert(otherStringType == JSONDataType.jsonString)
        XCTAssert(intType == JSONDataType.jsonInt)
        XCTAssert(doubleType == JSONDataType.jsonDouble)
        XCTAssert(boolType == JSONDataType.jsonBool)
        XCTAssert(nullType == JSONDataType.jsonNull)
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        let emptyArray : AnyObject = []
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        let emptyArrayType = JSONDataType.generate(withObject:emptyArray)
        
        XCTAssert(stringArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonString))
        XCTAssert(otherStringArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonString))
        XCTAssert(intArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonInt))
        XCTAssert(doubleArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonDouble))
        XCTAssert(boolArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonBool))
        XCTAssert(nullArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonNull))
        XCTAssert(emptyArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonNull))
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType == JSONDataType.jsonArray(type: JSONDataType.jsonArray(type: JSONDataType.jsonString)))
    }
    
    func testTypeString() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(otherStringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "Any")
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testDefaultValue() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.defaultValue == "\"\"")
        XCTAssert(otherStringType.defaultValue == "\"\"")
        XCTAssert(intType.defaultValue == "0")
        XCTAssert(doubleType.defaultValue == "0.0")
        XCTAssert(boolType.defaultValue == "false")
        XCTAssert(nullType.defaultValue == "nil")
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.defaultValue == "nil")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.defaultValue == "[]")
        XCTAssert(otherStringArrayType.defaultValue == "[]")
        XCTAssert(intArrayType.defaultValue == "[]")
        XCTAssert(doubleArrayType.defaultValue == "[]")
        XCTAssert(boolArrayType.defaultValue == "[]")
        XCTAssert(nullArrayType.defaultValue == "[]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.defaultValue == "[]")
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.defaultValue == "[]")
        
    }
    
    func testOptionalType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.optionalType == false)
        XCTAssert(otherStringType.optionalType == false)
        XCTAssert(intType.optionalType == false)
        XCTAssert(doubleType.optionalType == false)
        XCTAssert(boolType.optionalType == false)
        XCTAssert(nullType.optionalType == true)
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.optionalType == true)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.optionalType == false)
        XCTAssert(otherStringArrayType.optionalType == false)
        XCTAssert(intArrayType.optionalType == false)
        XCTAssert(doubleArrayType.optionalType == false)
        XCTAssert(boolArrayType.optionalType == false)
        XCTAssert(nullArrayType.optionalType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.optionalType == false)
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.optionalType == false)
        
    }
    
    func testNestedType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.isNestedType == false)
        XCTAssert(otherStringType.isNestedType == false)
        XCTAssert(intType.isNestedType == false)
        XCTAssert(doubleType.isNestedType == false)
        XCTAssert(boolType.isNestedType == false)
        XCTAssert(nullType.isNestedType == false)
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.isNestedType == true)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.isNestedType == false)
        XCTAssert(otherStringArrayType.isNestedType == false)
        XCTAssert(intArrayType.isNestedType == false)
        XCTAssert(doubleArrayType.isNestedType == false)
        XCTAssert(boolArrayType.isNestedType == false)
        XCTAssert(nullArrayType.isNestedType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.isNestedType == false)
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.isNestedType == false)
        
    }
    
    func testNestedArrayType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.isNestedArrayType == false)
        XCTAssert(otherStringType.isNestedArrayType == false)
        XCTAssert(intType.isNestedArrayType == false)
        XCTAssert(doubleType.isNestedArrayType == false)
        XCTAssert(boolType.isNestedArrayType == false)
        XCTAssert(nullType.isNestedArrayType == false)
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.isNestedArrayType == false)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.isNestedArrayType == false)
        XCTAssert(otherStringArrayType.isNestedArrayType == false)
        XCTAssert(intArrayType.isNestedArrayType == false)
        XCTAssert(doubleArrayType.isNestedArrayType == false)
        XCTAssert(boolArrayType.isNestedArrayType == false)
        XCTAssert(nullArrayType.isNestedArrayType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.isNestedType == false)
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.isNestedArrayType == true)
        
    }
    
    func testTypeStringWithClassPrefix() {
        
        let classPrefix = "CP"
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.typeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(otherStringType.typeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(intType.typeString(withClassPrefix: classPrefix) == "Int")
        XCTAssert(doubleType.typeString(withClassPrefix: classPrefix) == "Double")
        XCTAssert(boolType.typeString(withClassPrefix: classPrefix) == "Bool")
        XCTAssert(nullType.typeString(withClassPrefix: classPrefix) == "Any")
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.typeString(withClassPrefix: classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.typeString(withClassPrefix: classPrefix) == "[String]")
        XCTAssert(otherStringArrayType.typeString(withClassPrefix: classPrefix) == "[String]")
        XCTAssert(intArrayType.typeString(withClassPrefix: classPrefix) == "[Int]")
        XCTAssert(doubleArrayType.typeString(withClassPrefix: classPrefix) == "[Double]")
        XCTAssert(boolArrayType.typeString(withClassPrefix: classPrefix) == "[Bool]")
        XCTAssert(nullArrayType.typeString(withClassPrefix: classPrefix) == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.typeString(withClassPrefix: classPrefix) == "[[String]]")
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.typeString(withClassPrefix: classPrefix) == "[CPCustom]")
        
    }
    
    func testArrayElementTypeStringWithClassPrefix() {
        
        let classPrefix = "CP"
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let otherStringType = JSONDataType.generate(withObject:otherString)
        let intType = JSONDataType.generate(withObject:int)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(otherStringType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(intType.arrayTypeString(withClassPrefix: classPrefix) == "Int")
        XCTAssert(doubleType.arrayTypeString(withClassPrefix: classPrefix) == "Double")
        XCTAssert(boolType.arrayTypeString(withClassPrefix: classPrefix) == "Bool")
        XCTAssert(nullType.arrayTypeString(withClassPrefix: classPrefix) == "Any")
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType.typeString(withClassPrefix: classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(otherStringArrayType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(intArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Int")
        XCTAssert(doubleArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Double")
        XCTAssert(boolArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Bool")
        XCTAssert(nullArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Any")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType.arrayTypeString(withClassPrefix: classPrefix) == "CPCustom")
        
    }
    
    func testRenameType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string).renameType(withNewName: "Bad")
        let otherStringType = JSONDataType.generate(withObject:otherString).renameType(withNewName: "Int")
        let intType = JSONDataType.generate(withObject:int).renameType(withNewName: "Bad")
        let doubleType = JSONDataType.generate(withObject:double).renameType(withNewName: "Bad")
        let boolType = JSONDataType.generate(withObject:bool).renameType(withNewName: "Bad")
        let nullType = JSONDataType.generate(withObject:null).renameType(withNewName: "Bad")
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(otherStringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "Any")
        
        let customType = JSONDataType.jsonType(type: "Custom").renameType(withNewName: "Rename")
        XCTAssert(customType.typeString == "Rename")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray).renameType(withNewName: "")
        let otherStringArrayType = JSONDataType.generate(withObject:otherStringArray).renameType(withNewName: "Bad")
        let intArrayType = JSONDataType.generate(withObject:intArray).renameType(withNewName: "Bad")
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray).renameType(withNewName: "Bad")
        let boolArrayType = JSONDataType.generate(withObject:boolArray).renameType(withNewName: "Bad")
        let nullArrayType = JSONDataType.generate(withObject:nullArray).renameType(withNewName: "Bad")
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray).renameType(withNewName: "Bad")
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom")).renameType(withNewName: "Rename")
        XCTAssert(customArrayType.typeString == "[Rename]")
        
    }
    
    func testUpgrade() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string).upgrade(toType: JSONDataType.jsonInt)
        let intType = JSONDataType.generate(withObject:int).upgrade(toType: JSONDataType.jsonBool)
        let otherIntType = JSONDataType.generate(withObject:int).upgrade(toType: JSONDataType.jsonDouble)
        let doubleType = JSONDataType.generate(withObject:double).upgrade(toType: JSONDataType.jsonInt)
        let boolType = JSONDataType.generate(withObject:bool).upgrade(toType: JSONDataType.jsonInt)
        let nullType = JSONDataType.generate(withObject:null).upgrade(toType: JSONDataType.jsonString)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(otherIntType.typeString == "Double")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "String")
        
        let customType = JSONDataType.jsonType(type: "Custom").upgrade(toType: JSONDataType.jsonType(type: "Upgrade"))
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray).upgrade(toType: JSONDataType.jsonInt)
        let intArrayType = JSONDataType.generate(withObject:intArray).upgrade(toType: JSONDataType.jsonBool)
        let otherArrayIntType = JSONDataType.generate(withObject:intArray).upgrade(toType: JSONDataType.jsonDouble)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray).upgrade(toType: JSONDataType.jsonInt)
        let boolArrayType = JSONDataType.generate(withObject:boolArray).upgrade(toType: JSONDataType.jsonInt)
        let nullArrayType = JSONDataType.generate(withObject:nullArray).upgrade(toType: JSONDataType.jsonString)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(otherArrayIntType.typeString == "[Double]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[String]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray).upgrade(toType: JSONDataType.jsonType(type: "Int"))
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom")).upgrade(toType: JSONDataType.jsonType(type: "Upgrade"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testEquality() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let otherInt : AnyObject = -1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(withObject:string)
        let intType = JSONDataType.generate(withObject:int)
        let otherIntType = JSONDataType.generate(withObject:otherInt)
        let doubleType = JSONDataType.generate(withObject:double)
        let boolType = JSONDataType.generate(withObject:bool)
        let nullType = JSONDataType.generate(withObject:null)
        
        XCTAssert(stringType != intType)
        XCTAssert(stringType != otherIntType)
        XCTAssert(intType == otherIntType)
        XCTAssert(stringType != doubleType)
        XCTAssert(stringType != boolType)
        XCTAssert(stringType != nullType)
        
        let customType = JSONDataType.jsonType(type: "Custom")
        XCTAssert(customType != nullType)
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(withObject:stringArray)
        let intArrayType = JSONDataType.generate(withObject:intArray)
        let otherArrayIntType = JSONDataType.generate(withObject:intArray)
        let doubleArrayType = JSONDataType.generate(withObject:doubleArray)
        let boolArrayType = JSONDataType.generate(withObject:boolArray)
        let nullArrayType = JSONDataType.generate(withObject:nullArray)
        
        XCTAssert(stringArrayType != stringType)
        XCTAssert(intArrayType != intType)
        XCTAssert(otherArrayIntType != otherIntType)
        XCTAssert(doubleArrayType != doubleType)
        XCTAssert(boolArrayType != boolType)
        XCTAssert(nullArrayType != nullType)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(withObject:nestedArray)
        XCTAssert(nestedArrayType != stringArrayType)
        
        let customArrayType = JSONDataType.jsonArray(type: JSONDataType.jsonType(type: "Custom"))
        XCTAssert(customArrayType != customType)
        
    }
    
    func testDimensions() {
        
        let arrayTypeA = JSONDataType.jsonArray(type: JSONDataType.jsonInt)
        XCTAssert(arrayTypeA.dimensions == 1)
        
        let arrayTypeB = JSONDataType.jsonArray(type: arrayTypeA)
        XCTAssert(arrayTypeB.dimensions == 2)
        
        let arrayTypeC = JSONDataType.jsonArray(type: arrayTypeB)
        XCTAssert(arrayTypeC.dimensions == 3)
        
    }
    
    func testUnNestDimension() {
        
        let intType = JSONDataType.jsonInt
        let arrayTypeA = JSONDataType.jsonArray(type: intType)
        
        XCTAssert(intType == arrayTypeA.unNestOneDimension)
        XCTAssert(arrayTypeA != arrayTypeA.unNestOneDimension)
        XCTAssert(intType == intType.unNestOneDimension)
        
    }
    
    func testIsMutliDimensional() {
        
        let arrayTypeA = JSONDataType.jsonArray(type: JSONDataType.jsonArray(type: JSONDataType.jsonInt))
        let arrayTypeB = JSONDataType.jsonArray(type: JSONDataType.jsonInt)
        let intType = JSONDataType.jsonInt
        
        XCTAssert(arrayTypeA.isMultiDimensional == true)
        XCTAssert(arrayTypeB.isMultiDimensional == false)
        XCTAssert(intType.isMultiDimensional == false)
    }

}
