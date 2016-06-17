//
//  JNDataTypeTests.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JNDataTypeTests: XCTestCase {

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
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType == JNDataType.string)
        XCTAssert(otherStringType == JNDataType.string)
        XCTAssert(intType == JNDataType.int)
        XCTAssert(doubleType == JNDataType.double)
        XCTAssert(boolType == JNDataType.bool)
        XCTAssert(nullType == JNDataType.null)
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        let emptyArray : AnyObject = []
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        let emptyArrayType = JNDataType.generate(from:emptyArray)
        
        XCTAssert(stringArrayType == JNDataType.array(type: JNDataType.string))
        XCTAssert(otherStringArrayType == JNDataType.array(type: JNDataType.string))
        XCTAssert(intArrayType == JNDataType.array(type: JNDataType.int))
        XCTAssert(doubleArrayType == JNDataType.array(type: JNDataType.double))
        XCTAssert(boolArrayType == JNDataType.array(type: JNDataType.bool))
        XCTAssert(nullArrayType == JNDataType.array(type: JNDataType.null))
        XCTAssert(emptyArrayType == JNDataType.array(type: JNDataType.null))
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType == JNDataType.array(type: JNDataType.array(type: JNDataType.string)))
    }
    
    func testTypeString() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(otherStringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "Any")
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testDefaultValue() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.defaultValue == "\"\"")
        XCTAssert(otherStringType.defaultValue == "\"\"")
        XCTAssert(intType.defaultValue == "0")
        XCTAssert(doubleType.defaultValue == "0.0")
        XCTAssert(boolType.defaultValue == "false")
        XCTAssert(nullType.defaultValue == "nil")
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.defaultValue == "nil")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.defaultValue == "[]")
        XCTAssert(otherStringArrayType.defaultValue == "[]")
        XCTAssert(intArrayType.defaultValue == "[]")
        XCTAssert(doubleArrayType.defaultValue == "[]")
        XCTAssert(boolArrayType.defaultValue == "[]")
        XCTAssert(nullArrayType.defaultValue == "[]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.defaultValue == "[]")
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType.defaultValue == "[]")
        
    }
    
    func testisOptional() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.isOptional == false)
        XCTAssert(otherStringType.isOptional == false)
        XCTAssert(intType.isOptional == false)
        XCTAssert(doubleType.isOptional == false)
        XCTAssert(boolType.isOptional == false)
        XCTAssert(nullType.isOptional == true)
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.isOptional == true)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.isOptional == false)
        XCTAssert(otherStringArrayType.isOptional == false)
        XCTAssert(intArrayType.isOptional == false)
        XCTAssert(doubleArrayType.isOptional == false)
        XCTAssert(boolArrayType.isOptional == false)
        XCTAssert(nullArrayType.isOptional == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.isOptional == false)
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType.isOptional == false)
        
    }
    
    func testNestedType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.isCustomType == false)
        XCTAssert(otherStringType.isCustomType == false)
        XCTAssert(intType.isCustomType == false)
        XCTAssert(doubleType.isCustomType == false)
        XCTAssert(boolType.isCustomType == false)
        XCTAssert(nullType.isCustomType == false)
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.isCustomType == true)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.isCustomType == false)
        XCTAssert(otherStringArrayType.isCustomType == false)
        XCTAssert(intArrayType.isCustomType == false)
        XCTAssert(doubleArrayType.isCustomType == false)
        XCTAssert(boolArrayType.isCustomType == false)
        XCTAssert(nullArrayType.isCustomType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.isCustomType == false)
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType.isCustomType == false)
        
    }
    
    func testNestedArrayType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.isArrayOfCustomType == false)
        XCTAssert(otherStringType.isArrayOfCustomType == false)
        XCTAssert(intType.isArrayOfCustomType == false)
        XCTAssert(doubleType.isArrayOfCustomType == false)
        XCTAssert(boolType.isArrayOfCustomType == false)
        XCTAssert(nullType.isArrayOfCustomType == false)
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.isArrayOfCustomType == false)
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.isArrayOfCustomType == false)
        XCTAssert(otherStringArrayType.isArrayOfCustomType == false)
        XCTAssert(intArrayType.isArrayOfCustomType == false)
        XCTAssert(doubleArrayType.isArrayOfCustomType == false)
        XCTAssert(boolArrayType.isArrayOfCustomType == false)
        XCTAssert(nullArrayType.isArrayOfCustomType == false)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.isCustomType == false)
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType.isArrayOfCustomType == true)
        
    }
    
    func testTypeStringWithClassPrefix() {
        
        let classPrefix = "CP"
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.typeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(otherStringType.typeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(intType.typeString(withClassPrefix: classPrefix) == "Int")
        XCTAssert(doubleType.typeString(withClassPrefix: classPrefix) == "Double")
        XCTAssert(boolType.typeString(withClassPrefix: classPrefix) == "Bool")
        XCTAssert(nullType.typeString(withClassPrefix: classPrefix) == "Any")
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.typeString(withClassPrefix: classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.typeString(withClassPrefix: classPrefix) == "[String]")
        XCTAssert(otherStringArrayType.typeString(withClassPrefix: classPrefix) == "[String]")
        XCTAssert(intArrayType.typeString(withClassPrefix: classPrefix) == "[Int]")
        XCTAssert(doubleArrayType.typeString(withClassPrefix: classPrefix) == "[Double]")
        XCTAssert(boolArrayType.typeString(withClassPrefix: classPrefix) == "[Bool]")
        XCTAssert(nullArrayType.typeString(withClassPrefix: classPrefix) == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.typeString(withClassPrefix: classPrefix) == "[[String]]")
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
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
        
        let stringType = JNDataType.generate(from:string)
        let otherStringType = JNDataType.generate(from:otherString)
        let intType = JNDataType.generate(from:int)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(otherStringType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(intType.arrayTypeString(withClassPrefix: classPrefix) == "Int")
        XCTAssert(doubleType.arrayTypeString(withClassPrefix: classPrefix) == "Double")
        XCTAssert(boolType.arrayTypeString(withClassPrefix: classPrefix) == "Bool")
        XCTAssert(nullType.arrayTypeString(withClassPrefix: classPrefix) == "Any")
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType.typeString(withClassPrefix: classPrefix) == "CPCustom")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let otherStringArrayType = JNDataType.generate(from:otherStringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(otherStringArrayType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        XCTAssert(intArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Int")
        XCTAssert(doubleArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Double")
        XCTAssert(boolArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Bool")
        XCTAssert(nullArrayType.arrayTypeString(withClassPrefix: classPrefix) == "Any")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType.arrayTypeString(withClassPrefix: classPrefix) == "String")
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType.arrayTypeString(withClassPrefix: classPrefix) == "CPCustom")
        
    }
    
    func testRenameType() {
        
        let string : AnyObject = "true"
        let otherString : AnyObject = "1"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string).rename(to: "Bad")
        let otherStringType = JNDataType.generate(from:otherString).rename(to: "Int")
        let intType = JNDataType.generate(from:int).rename(to: "Bad")
        let doubleType = JNDataType.generate(from:double).rename(to: "Bad")
        let boolType = JNDataType.generate(from:bool).rename(to: "Bad")
        let nullType = JNDataType.generate(from:null).rename(to: "Bad")
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(otherStringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "Any")
        
        let customType = JNDataType.type(type: "Custom").rename(to: "Rename")
        XCTAssert(customType.typeString == "Rename")
        
        
        let stringArray : AnyObject = ["true"]
        let otherStringArray : AnyObject = ["1"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray).rename(to: "")
        let otherStringArrayType = JNDataType.generate(from:otherStringArray).rename(to: "Bad")
        let intArrayType = JNDataType.generate(from:intArray).rename(to: "Bad")
        let doubleArrayType = JNDataType.generate(from:doubleArray).rename(to: "Bad")
        let boolArrayType = JNDataType.generate(from:boolArray).rename(to: "Bad")
        let nullArrayType = JNDataType.generate(from:nullArray).rename(to: "Bad")
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(otherStringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[Any]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray).rename(to: "Bad")
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom")).rename(to: "Rename")
        XCTAssert(customArrayType.typeString == "[Rename]")
        
    }
    
    func testUpgrade() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string).upgrade(to: JNDataType.int)
        let intType = JNDataType.generate(from:int).upgrade(to: JNDataType.bool)
        let otherIntType = JNDataType.generate(from:int).upgrade(to: JNDataType.double)
        let doubleType = JNDataType.generate(from:double).upgrade(to: JNDataType.int)
        let boolType = JNDataType.generate(from:bool).upgrade(to: JNDataType.int)
        let nullType = JNDataType.generate(from:null).upgrade(to: JNDataType.string)
        
        XCTAssert(stringType.typeString == "String")
        XCTAssert(intType.typeString == "Int")
        XCTAssert(otherIntType.typeString == "Double")
        XCTAssert(doubleType.typeString == "Double")
        XCTAssert(boolType.typeString == "Bool")
        XCTAssert(nullType.typeString == "String")
        
        let customType = JNDataType.type(type: "Custom").upgrade(to: JNDataType.type(type: "Upgrade"))
        XCTAssert(customType.typeString == "Custom")
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray).upgrade(to: JNDataType.int)
        let intArrayType = JNDataType.generate(from:intArray).upgrade(to: JNDataType.bool)
        let otherArrayIntType = JNDataType.generate(from:intArray).upgrade(to: JNDataType.double)
        let doubleArrayType = JNDataType.generate(from:doubleArray).upgrade(to: JNDataType.int)
        let boolArrayType = JNDataType.generate(from:boolArray).upgrade(to: JNDataType.int)
        let nullArrayType = JNDataType.generate(from:nullArray).upgrade(to: JNDataType.string)
        
        XCTAssert(stringArrayType.typeString == "[String]")
        XCTAssert(intArrayType.typeString == "[Int]")
        XCTAssert(otherArrayIntType.typeString == "[Double]")
        XCTAssert(doubleArrayType.typeString == "[Double]")
        XCTAssert(boolArrayType.typeString == "[Bool]")
        XCTAssert(nullArrayType.typeString == "[String]")
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray).upgrade(to: JNDataType.type(type: "Int"))
        XCTAssert(nestedArrayType.typeString == "[[String]]")
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom")).upgrade(to: JNDataType.type(type: "Upgrade"))
        XCTAssert(customArrayType.typeString == "[Custom]")
        
    }
    
    func testEquality() {
        
        let string : AnyObject = "true"
        let int : AnyObject = 1
        let otherInt : AnyObject = -1
        let double : AnyObject = 1.1
        let bool : AnyObject = true
        let null : AnyObject = NSNull()
        
        let stringType = JNDataType.generate(from:string)
        let intType = JNDataType.generate(from:int)
        let otherIntType = JNDataType.generate(from:otherInt)
        let doubleType = JNDataType.generate(from:double)
        let boolType = JNDataType.generate(from:bool)
        let nullType = JNDataType.generate(from:null)
        
        XCTAssert(stringType != intType)
        XCTAssert(stringType != otherIntType)
        XCTAssert(intType == otherIntType)
        XCTAssert(stringType != doubleType)
        XCTAssert(stringType != boolType)
        XCTAssert(stringType != nullType)
        
        let customType = JNDataType.type(type: "Custom")
        XCTAssert(customType != nullType)
        
        
        let stringArray : AnyObject = ["true"]
        let intArray : AnyObject = [1]
        let doubleArray : AnyObject = [1.1]
        let boolArray : AnyObject = [true]
        let nullArray : AnyObject = [NSNull()]
        
        let stringArrayType = JNDataType.generate(from:stringArray)
        let intArrayType = JNDataType.generate(from:intArray)
        let otherArrayIntType = JNDataType.generate(from:intArray)
        let doubleArrayType = JNDataType.generate(from:doubleArray)
        let boolArrayType = JNDataType.generate(from:boolArray)
        let nullArrayType = JNDataType.generate(from:nullArray)
        
        XCTAssert(stringArrayType != stringType)
        XCTAssert(intArrayType != intType)
        XCTAssert(otherArrayIntType != otherIntType)
        XCTAssert(doubleArrayType != doubleType)
        XCTAssert(boolArrayType != boolType)
        XCTAssert(nullArrayType != nullType)
        
        let nestedArray : AnyObject = [["SomeString"]]
        let nestedArrayType = JNDataType.generate(from:nestedArray)
        XCTAssert(nestedArrayType != stringArrayType)
        
        let customArrayType = JNDataType.array(type: JNDataType.type(type: "Custom"))
        XCTAssert(customArrayType != customType)
        
    }
    
    func testDimensions() {
        
        let arrayTypeA = JNDataType.array(type: JNDataType.int)
        XCTAssert(arrayTypeA.dimensions == 1)
        
        let arrayTypeB = JNDataType.array(type: arrayTypeA)
        XCTAssert(arrayTypeB.dimensions == 2)
        
        let arrayTypeC = JNDataType.array(type: arrayTypeB)
        XCTAssert(arrayTypeC.dimensions == 3)
        
    }
    
    func testUnNestDimension() {
        
        let intType = JNDataType.int
        let arrayTypeA = JNDataType.array(type: intType)
        
        XCTAssert(intType == arrayTypeA.reduceDimensionOfArray)
        XCTAssert(arrayTypeA != arrayTypeA.reduceDimensionOfArray)
        XCTAssert(intType == intType.reduceDimensionOfArray)
        
    }
    
    func testIsMutliDimensional() {
        
        let arrayTypeA = JNDataType.array(type: JNDataType.array(type: JNDataType.int))
        let arrayTypeB = JNDataType.array(type: JNDataType.int)
        let intType = JNDataType.int
        
        XCTAssert(arrayTypeA.isMultiDimensionalArray == true)
        XCTAssert(arrayTypeB.isMultiDimensionalArray == false)
        XCTAssert(intType.isMultiDimensionalArray == false)
    }

}
