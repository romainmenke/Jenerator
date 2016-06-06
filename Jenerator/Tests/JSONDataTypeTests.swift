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
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType == JSONDataType.JSONString)
        XCTAssert(otherStringType == JSONDataType.JSONString)
        XCTAssert(intType == JSONDataType.JSONInt)
        XCTAssert(doubleType == JSONDataType.JSONDouble)
        XCTAssert(boolType == JSONDataType.JSONBool)
        XCTAssert(nullType == JSONDataType.JSONNull)
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        let emptyArray : AnyObject = []
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        let emptyArrayType = JSONDataType.generate(object: emptyArray)
        
        XCTAssert(stringArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONString))
        XCTAssert(otherStringArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONString))
        XCTAssert(intArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONInt))
        XCTAssert(doubleArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONDouble))
        XCTAssert(boolArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONBool))
        XCTAssert(nullArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONNull))
        XCTAssert(emptyArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONNull))
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONArray(type: JSONDataType.JSONString)))
    }
    
    func testTypeString() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(otherStringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "Any")
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testDefaultValue() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.defaultValue == "\"\"")
        XCTAssert(otherStringType.defaultValue == "\"\"")
        XCTAssert(intType.defaultValue == "0")
        XCTAssert(doubleType.defaultValue == "0.0")
        XCTAssert(boolType.defaultValue == "false")
        XCTAssert(nullType.defaultValue == "nil")
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.defaultValue == "nil")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.defaultValue == "[]")
        XCTAssert(otherStringArrayType.defaultValue == "[]")
        XCTAssert(intArrayType.defaultValue == "[]")
        XCTAssert(doubleArrayType.defaultValue == "[]")
        XCTAssert(boolArrayType.defaultValue == "[]")
        XCTAssert(nullArrayType.defaultValue == "[]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.defaultValue == "[]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.defaultValue == "[]")
        
    }
    
    func testOptionalType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.optionalType == false)
        XCTAssert(otherStringType.optionalType == false)
        XCTAssert(intType.optionalType == false)
        XCTAssert(doubleType.optionalType == false)
        XCTAssert(boolType.optionalType == false)
        XCTAssert(nullType.optionalType == true)
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.optionalType == true)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.optionalType == false)
        XCTAssert(otherStringArrayType.optionalType == false)
        XCTAssert(intArrayType.optionalType == false)
        XCTAssert(doubleArrayType.optionalType == false)
        XCTAssert(boolArrayType.optionalType == false)
        XCTAssert(nullArrayType.optionalType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.optionalType == false)
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.optionalType == false)
        
    }
    
    func testNestedType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.isNestedType == false)
        XCTAssert(otherStringType.isNestedType == false)
        XCTAssert(intType.isNestedType == false)
        XCTAssert(doubleType.isNestedType == false)
        XCTAssert(boolType.isNestedType == false)
        XCTAssert(nullType.isNestedType == false)
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.isNestedType == true)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.isNestedType == false)
        XCTAssert(otherStringArrayType.isNestedType == false)
        XCTAssert(intArrayType.isNestedType == false)
        XCTAssert(doubleArrayType.isNestedType == false)
        XCTAssert(boolArrayType.isNestedType == false)
        XCTAssert(nullArrayType.isNestedType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.isNestedType == false)
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.isNestedType == false)
        
    }
    
    func testNestedArrayType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.isNestedArrayType == false)
        XCTAssert(otherStringType.isNestedArrayType == false)
        XCTAssert(intType.isNestedArrayType == false)
        XCTAssert(doubleType.isNestedArrayType == false)
        XCTAssert(boolType.isNestedArrayType == false)
        XCTAssert(nullType.isNestedArrayType == false)
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.isNestedArrayType == false)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.isNestedArrayType == false)
        XCTAssert(otherStringArrayType.isNestedArrayType == false)
        XCTAssert(intArrayType.isNestedArrayType == false)
        XCTAssert(doubleArrayType.isNestedArrayType == false)
        XCTAssert(boolArrayType.isNestedArrayType == false)
        XCTAssert(nullArrayType.isNestedArrayType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.isNestedType == false)
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
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
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.typeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        XCTAssert(otherStringType.typeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        XCTAssert(intType.typeStringWithClassPrefix(classPrefix: classPrefix) == "Int")
        XCTAssert(doubleType.typeStringWithClassPrefix(classPrefix: classPrefix) == "Double")
        XCTAssert(boolType.typeStringWithClassPrefix(classPrefix: classPrefix) == "Bool")
        XCTAssert(nullType.typeStringWithClassPrefix(classPrefix: classPrefix) == "Any")
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.typeStringWithClassPrefix(classPrefix: classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[String]")
        XCTAssert(otherStringArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[String]")
        XCTAssert(intArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[Int]")
        XCTAssert(doubleArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[Double]")
        XCTAssert(boolArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[Bool]")
        XCTAssert(nullArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[[String]]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.typeStringWithClassPrefix(classPrefix: classPrefix) == "[CPCustom]")
        
    }
    
    func testArrayElementTypeStringWithClassPrefix() {
        
        let classPrefix = "CP"
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let otherStringType = JSONDataType.generate(object: otherString)
        let intType = JSONDataType.generate(object: int)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        XCTAssert(otherStringType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        XCTAssert(intType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Int")
        XCTAssert(doubleType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Double")
        XCTAssert(boolType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Bool")
        XCTAssert(nullType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Any")
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.typeStringWithClassPrefix(classPrefix: classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        XCTAssert(otherStringArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        XCTAssert(intArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Int")
        XCTAssert(doubleArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Double")
        XCTAssert(boolArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Bool")
        XCTAssert(nullArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "Any")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "String")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.arrayTypeStringWithClassPrefix(classPrefix: classPrefix) == "CPCustom")
        
    }
    
    func testRenameType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string).renameType(withNewName: "Bad")
        let otherStringType = JSONDataType.generate(object: otherString).renameType(withNewName: "Int")
        let intType = JSONDataType.generate(object: int).renameType(withNewName: "Bad")
        let doubleType = JSONDataType.generate(object: double).renameType(withNewName: "Bad")
        let boolType = JSONDataType.generate(object: bool).renameType(withNewName: "Bad")
        let nullType = JSONDataType.generate(object: null).renameType(withNewName: "Bad")
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(otherStringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "Any")
        
        let customType = JSONDataType.JSONType(type: "Custom").renameType(withNewName: "Rename")
        XCTAssert(customType.typeString == "Rename")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray).renameType(withNewName: "")
        let otherStringArrayType = JSONDataType.generate(object: otherStringArray).renameType(withNewName: "Bad")
        let intArrayType = JSONDataType.generate(object: intArray).renameType(withNewName: "Bad")
        let doubleArrayType = JSONDataType.generate(object: doubleArray).renameType(withNewName: "Bad")
        let boolArrayType = JSONDataType.generate(object: boolArray).renameType(withNewName: "Bad")
        let nullArrayType = JSONDataType.generate(object: nullArray).renameType(withNewName: "Bad")
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray).renameType(withNewName: "Bad")
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom")).renameType(withNewName: "Rename")
        XCTAssert(customArrayType.typeString == "[Rename]")
        
    }
    
    func testUpgradeType() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string).upgradeType(toType: JSONDataType.JSONInt)
        let intType = JSONDataType.generate(object: int).upgradeType(toType: JSONDataType.JSONBool)
        let otherIntType = JSONDataType.generate(object: int).upgradeType(toType: JSONDataType.JSONDouble)
        let doubleType = JSONDataType.generate(object: double).upgradeType(toType: JSONDataType.JSONInt)
        let boolType = JSONDataType.generate(object: bool).upgradeType(toType: JSONDataType.JSONInt)
        let nullType = JSONDataType.generate(object: null).upgradeType(toType: JSONDataType.JSONString)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(otherIntType.typeString == "Double")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "String")
        
        let customType = JSONDataType.JSONType(type: "Custom").upgradeType(toType: JSONDataType.JSONType(type: "Upgrade"))
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray).upgradeType(toType: JSONDataType.JSONInt)
        let intArrayType = JSONDataType.generate(object: intArray).upgradeType(toType: JSONDataType.JSONBool)
        let otherArrayIntType = JSONDataType.generate(object: intArray).upgradeType(toType: JSONDataType.JSONDouble)
        let doubleArrayType = JSONDataType.generate(object: doubleArray).upgradeType(toType: JSONDataType.JSONInt)
        let boolArrayType = JSONDataType.generate(object: boolArray).upgradeType(toType: JSONDataType.JSONInt)
        let nullArrayType = JSONDataType.generate(object: nullArray).upgradeType(toType: JSONDataType.JSONString)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(otherArrayIntType.typeString == "[Double]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[String]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray).upgradeType(toType: JSONDataType.JSONType(type: "Int"))
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom")).upgradeType(toType: JSONDataType.JSONType(type: "Upgrade"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testEquality() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let otherInt : AnyObject = -1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(object: string)
        let intType = JSONDataType.generate(object: int)
        let otherIntType = JSONDataType.generate(object: otherInt)
        let doubleType = JSONDataType.generate(object: double)
        let boolType = JSONDataType.generate(object: bool)
        let nullType = JSONDataType.generate(object: null)
        
        XCTAssert(stringType != intType)
        XCTAssert(stringType != otherIntType)
        XCTAssert(intType == otherIntType)
        XCTAssert(stringType != doubleType)
        XCTAssert(stringType != boolType)
        XCTAssert(stringType != nullType)
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType != nullType)
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(object: stringArray)
        let intArrayType = JSONDataType.generate(object: intArray)
        let otherArrayIntType = JSONDataType.generate(object: intArray)
        let doubleArrayType = JSONDataType.generate(object: doubleArray)
        let boolArrayType = JSONDataType.generate(object: boolArray)
        let nullArrayType = JSONDataType.generate(object: nullArray)
        
        XCTAssert(stringArrayType != stringType)
        XCTAssert(intArrayType != intType)
        XCTAssert(otherArrayIntType != otherIntType)
        XCTAssert(doubleArrayType != doubleType)
        XCTAssert(boolArrayType != boolType)
        XCTAssert(nullArrayType != nullType)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(object: nestedArray)
        XCTAssert(nestedArrayType != stringArrayType)
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType != customType)
        
    }
    
    func testDimensions() {
        
        let arrayTypeA = JSONDataType.JSONArray(type: JSONDataType.JSONInt)
        XCTAssert(arrayTypeA.dimensions == 1)
        
        let arrayTypeB = JSONDataType.JSONArray(type: arrayTypeA)
        XCTAssert(arrayTypeB.dimensions == 2)
        
        let arrayTypeC = JSONDataType.JSONArray(type: arrayTypeB)
        XCTAssert(arrayTypeC.dimensions == 3)
        
    }
    
    func testUnNestDimension() {
        
        let intType = JSONDataType.JSONInt
        let arrayTypeA = JSONDataType.JSONArray(type: intType)
        
        XCTAssert(intType == arrayTypeA.unNestOneDimension)
        XCTAssert(arrayTypeA != arrayTypeA.unNestOneDimension)
        XCTAssert(intType == intType.unNestOneDimension)
        
    }
    
    func testIsMutliDimensional() {
        
        let arrayTypeA = JSONDataType.JSONArray(type: JSONDataType.JSONArray(type: JSONDataType.JSONInt))
        let arrayTypeB = JSONDataType.JSONArray(type: JSONDataType.JSONInt)
        let intType = JSONDataType.JSONInt
        
        XCTAssert(arrayTypeA.isMultiDimensional == true)
        XCTAssert(arrayTypeB.isMultiDimensional == false)
        XCTAssert(intType.isMultiDimensional == false)
    }

}
