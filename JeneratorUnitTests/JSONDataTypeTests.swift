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
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
