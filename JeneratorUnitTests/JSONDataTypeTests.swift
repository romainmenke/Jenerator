//
//  JSONDataTypeTests.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest

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
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONString))
        XCTAssert(otherStringArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONString))
        XCTAssert(intArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONInt))
        XCTAssert(doubleArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONDouble))
        XCTAssert(boolArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONBool))
        XCTAssert(nullArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONNull))
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
        XCTAssert(nestedArrayType == JSONDataType.JSONArray(type: JSONDataType.JSONArray(type: JSONDataType.JSONString)))
    }
    
    func testTypeString() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
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
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.defaultValue == "[]")
        XCTAssert(otherStringArrayType.defaultValue == "[]")
        XCTAssert(intArrayType.defaultValue == "[]")
        XCTAssert(doubleArrayType.defaultValue == "[]")
        XCTAssert(boolArrayType.defaultValue == "[]")
        XCTAssert(nullArrayType.defaultValue == "[]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
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
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.optionalType == false)
        XCTAssert(otherStringArrayType.optionalType == false)
        XCTAssert(intArrayType.optionalType == false)
        XCTAssert(doubleArrayType.optionalType == false)
        XCTAssert(boolArrayType.optionalType == false)
        XCTAssert(nullArrayType.optionalType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
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
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.isNestedType == false)
        XCTAssert(otherStringArrayType.isNestedType == false)
        XCTAssert(intArrayType.isNestedType == false)
        XCTAssert(doubleArrayType.isNestedType == false)
        XCTAssert(boolArrayType.isNestedType == false)
        XCTAssert(nullArrayType.isNestedType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
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
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.isNestedArrayType == false)
        XCTAssert(otherStringArrayType.isNestedArrayType == false)
        XCTAssert(intArrayType.isNestedArrayType == false)
        XCTAssert(doubleArrayType.isNestedArrayType == false)
        XCTAssert(boolArrayType.isNestedArrayType == false)
        XCTAssert(nullArrayType.isNestedArrayType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
        XCTAssert(nestedArrayType.isNestedType == false)
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.isNestedArrayType == true)
        
    }
    
    func testTypeStringWithNameSpace() {
        
        let classPrefix = "CP"
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
        XCTAssert(stringType.typeStringWithNameSpace(classPrefix) == "String")
        XCTAssert(otherStringType.typeStringWithNameSpace(classPrefix) == "String")
        XCTAssert(intType.typeStringWithNameSpace(classPrefix) == "Int")
        XCTAssert(doubleType.typeStringWithNameSpace(classPrefix) == "Double")
        XCTAssert(boolType.typeStringWithNameSpace(classPrefix) == "Bool")
        XCTAssert(nullType.typeStringWithNameSpace(classPrefix) == "Any")
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.typeStringWithNameSpace(classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.typeStringWithNameSpace(classPrefix) == "[String]")
        XCTAssert(otherStringArrayType.typeStringWithNameSpace(classPrefix) == "[String]")
        XCTAssert(intArrayType.typeStringWithNameSpace(classPrefix) == "[Int]")
        XCTAssert(doubleArrayType.typeStringWithNameSpace(classPrefix) == "[Double]")
        XCTAssert(boolArrayType.typeStringWithNameSpace(classPrefix) == "[Bool]")
        XCTAssert(nullArrayType.typeStringWithNameSpace(classPrefix) == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
        XCTAssert(nestedArrayType.typeStringWithNameSpace(classPrefix) == "[[String]]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.typeStringWithNameSpace(classPrefix) == "[CPCustom]")
        
    }
    
    func testArrayElementTypeStringWithNameSpace() {
        
        let classPrefix = "CP"
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(string)
        let otherStringType = JSONDataType.generate(otherString)
        let intType = JSONDataType.generate(int)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
        XCTAssert(stringType.arrayTypeStringWithNameSpace(classPrefix) == "String")
        XCTAssert(otherStringType.arrayTypeStringWithNameSpace(classPrefix) == "String")
        XCTAssert(intType.arrayTypeStringWithNameSpace(classPrefix) == "Int")
        XCTAssert(doubleType.arrayTypeStringWithNameSpace(classPrefix) == "Double")
        XCTAssert(boolType.arrayTypeStringWithNameSpace(classPrefix) == "Bool")
        XCTAssert(nullType.arrayTypeStringWithNameSpace(classPrefix) == "Any")
        
        let customType = JSONDataType.JSONType(type: "Custom")
        XCTAssert(customType.typeStringWithNameSpace(classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let otherStringArrayType = JSONDataType.generate(otherStringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType.arrayTypeStringWithNameSpace(classPrefix) == "String")
        XCTAssert(otherStringArrayType.arrayTypeStringWithNameSpace(classPrefix) == "String")
        XCTAssert(intArrayType.arrayTypeStringWithNameSpace(classPrefix) == "Int")
        XCTAssert(doubleArrayType.arrayTypeStringWithNameSpace(classPrefix) == "Double")
        XCTAssert(boolArrayType.arrayTypeStringWithNameSpace(classPrefix) == "Bool")
        XCTAssert(nullArrayType.arrayTypeStringWithNameSpace(classPrefix) == "Any")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
        XCTAssert(nestedArrayType.arrayTypeStringWithNameSpace(classPrefix) == "String")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom"))
        XCTAssert(customArrayType.arrayTypeStringWithNameSpace(classPrefix) == "CPCustom")
        
    }
    
    func testRenameType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(string).renameType(withNewName: "Bad")
        let otherStringType = JSONDataType.generate(otherString).renameType(withNewName: "Int")
        let intType = JSONDataType.generate(int).renameType(withNewName: "Bad")
        let doubleType = JSONDataType.generate(double).renameType(withNewName: "Bad")
        let boolType = JSONDataType.generate(bool).renameType(withNewName: "Bad")
        let nullType = JSONDataType.generate(null).renameType(withNewName: "Bad")
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray).renameType(withNewName: "")
        let otherStringArrayType = JSONDataType.generate(otherStringArray).renameType(withNewName: "Bad")
        let intArrayType = JSONDataType.generate(intArray).renameType(withNewName: "Bad")
        let doubleArrayType = JSONDataType.generate(doubleArray).renameType(withNewName: "Bad")
        let boolArrayType = JSONDataType.generate(boolArray).renameType(withNewName: "Bad")
        let nullArrayType = JSONDataType.generate(nullArray).renameType(withNewName: "Bad")
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray).renameType(withNewName: "Bad")
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
        
        let stringType = JSONDataType.generate(string).upgradeType(JSONDataType.JSONInt)
        let intType = JSONDataType.generate(int).upgradeType(JSONDataType.JSONBool)
        let otherIntType = JSONDataType.generate(int).upgradeType(JSONDataType.JSONDouble)
        let doubleType = JSONDataType.generate(double).upgradeType(JSONDataType.JSONInt)
        let boolType = JSONDataType.generate(bool).upgradeType(JSONDataType.JSONInt)
        let nullType = JSONDataType.generate(null).upgradeType(JSONDataType.JSONString)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(otherIntType.typeString == "Double")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "String")
        
        let customType = JSONDataType.JSONType(type: "Custom").upgradeType(JSONDataType.JSONType(type: "Upgrade"))
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JSONDataType.generate(stringArray).upgradeType(JSONDataType.JSONInt)
        let intArrayType = JSONDataType.generate(intArray).upgradeType(JSONDataType.JSONBool)
        let otherArrayIntType = JSONDataType.generate(intArray).upgradeType(JSONDataType.JSONDouble)
        let doubleArrayType = JSONDataType.generate(doubleArray).upgradeType(JSONDataType.JSONInt)
        let boolArrayType = JSONDataType.generate(boolArray).upgradeType(JSONDataType.JSONInt)
        let nullArrayType = JSONDataType.generate(nullArray).upgradeType(JSONDataType.JSONString)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(otherArrayIntType.typeString == "[Double]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[String]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray).upgradeType(JSONDataType.JSONType(type: "Int"))
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "Custom")).upgradeType(JSONDataType.JSONType(type: "Upgrade"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testEquality() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let otherInt : AnyObject = -1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JSONDataType.generate(string)
        let intType = JSONDataType.generate(int)
        let otherIntType = JSONDataType.generate(otherInt)
        let doubleType = JSONDataType.generate(double)
        let boolType = JSONDataType.generate(bool)
        let nullType = JSONDataType.generate(null)
        
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
        
        let stringArrayType = JSONDataType.generate(stringArray)
        let intArrayType = JSONDataType.generate(intArray)
        let otherArrayIntType = JSONDataType.generate(intArray)
        let doubleArrayType = JSONDataType.generate(doubleArray)
        let boolArrayType = JSONDataType.generate(boolArray)
        let nullArrayType = JSONDataType.generate(nullArray)
        
        XCTAssert(stringArrayType != stringType)
        XCTAssert(intArrayType != intType)
        XCTAssert(otherArrayIntType != otherIntType)
        XCTAssert(doubleArrayType != doubleType)
        XCTAssert(boolArrayType != boolType)
        XCTAssert(nullArrayType != nullType)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JSONDataType.generate(nestedArray)
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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
