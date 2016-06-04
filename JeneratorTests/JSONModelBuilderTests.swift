//
//  JSONModelBuilderTests.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import Jenerator

class JSONModelBuilderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testArrayContainsObject() {
        
        let object = [[[["some":"foo"]]]]
        let data = [[[["some"]]]]
        let builder = ModelBuilder(rootName: "Root", classPrefix: "UT")
        
        XCTAssert(builder.arrayContainsObjects(object) == true)
        XCTAssert(builder.arrayContainsObjects(data) == false)
        
    }
    
    func testBuildMultiArrayObject() {
        
        let object = [[[["some":"foo"]]]]
        
        let builder = ModelBuilder(rootName: "Root", classPrefix: "UT")
        let (result,content) = builder.buildMultiDimentionalArrayOfObject("name", array: object)
        
        let testType = JSONDataType.JSONArray(type: JSONDataType.JSONArray(type: JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "name"))))
        
        XCTAssert(content as? [String:String] ?? [:] == ["some":"foo"])
        XCTAssert(result == testType)
        
    }
    
    func testBuildTypesAlpha() {
        
        let object : [String:AnyObject] = ["user":["stats":["level":1,"power":"invisibility"]]]
        
        let levelField = JSONField(name: "level", type: .JSONInt)
        let powerField = JSONField(name: "power", type: .JSONString)
        let statsType = JSONCustomType(fields: [levelField,powerField], name: "stats")
        
        let statsField = JSONField(name: "stats", type: JSONDataType.JSONType(type: "stats"))
        let userType = JSONCustomType(fields: [statsField], name: "user")
        
        let userField = JSONField(name: "user", type: JSONDataType.JSONType(type: "user"))
        
        let container = JSONCustomType(fields: [userField], name: "container")
        
        let builder = ModelBuilder(rootName: "container", classPrefix: "UT")
        
        let types = builder.buildModel(object).types
        XCTAssert(types.count == 3)
        
        for type in types {
            if type.name == userType.name {
                NSLog(type.description)
                NSLog(userType.description)
                XCTAssert(type == userType)
                XCTAssert(type.fields == userType.fields)
                continue
            }
            if type.name == statsType.name {
                NSLog(type.description)
                NSLog(statsType.description)
                XCTAssert(type == statsType)
                XCTAssert(type.fields == statsType.fields)
                continue
            }
            if type.name == container.name {
                NSLog(type.description)
                NSLog(container.description)
                XCTAssert(type == container)
                XCTAssert(type.fields == container.fields)
                continue
            }
            XCTFail()
        }
    }
    
    func testBuildTypesBeta() {
        
        let object : [String:AnyObject] = ["users":[["stats":["level":1,"power":"invisibility"]]]]
        
        let levelField = JSONField(name: "level", type: .JSONInt)
        let powerField = JSONField(name: "power", type: .JSONString)
        let statsType = JSONCustomType(fields: [levelField,powerField], name: "stats")
        
        let statsField = JSONField(name: "stats", type: JSONDataType.JSONType(type: "stats"))
        let userType = JSONCustomType(fields: [statsField], name: "users")
        
        let userField = JSONField(name: "users", type: JSONDataType.JSONArray(type: JSONDataType.JSONType(type: "users")))
        
        let container = JSONCustomType(fields: [userField], name: "container")
        
        let builder = ModelBuilder(rootName: "container", classPrefix: "UT")
        
        let types = builder.buildModel(object).types
        
        XCTAssert(types.count == 3)
        
        for type in types {
            if type.name == userType.name {
                NSLog(type.description)
                NSLog(userType.description)
                XCTAssert(type == userType)
                XCTAssert(type.fields == userType.fields)
                continue
            }
            if type.name == statsType.name {
                NSLog(type.description)
                NSLog(statsType.description)
                XCTAssert(type == statsType)
                XCTAssert(type.fields == statsType.fields)
                continue
            }
            if type.name == container.name {
                NSLog(type.description)
                NSLog(container.description)
                XCTAssert(type == container)
                XCTAssert(type.fields == container.fields)
                continue
            }
            XCTFail()
        }
    }
    
    func testBuildTypesDelta() {
        
        let objectA : [String:AnyObject] = ["user":["name":"bob"]]
        let builderA = ModelBuilder(rootName: "container", classPrefix: "UT").buildModel(objectA)
        XCTAssert(builderA.types.count == 2)
        
        let objectB : [[String:AnyObject]] = [["user":["name":"bob"]]]
        let builderB = ModelBuilder(rootName: "container", classPrefix: "UT").buildModel(objectB)
        
        NSLog((builderB.types.filter { $0.name == "container" }.first!).description)
        NSLog((builderB.types.filter { $0.name == "element" }.first!).description)
        NSLog((builderB.types.filter { $0.name == "user" }.first!).description)
        XCTAssert(builderB.types.count == 3)
        
    }
    
    func testBuildTypesWithAliasses() {
        
        let object : [String:AnyObject] = ["user":["stats":["level":1,"power":"invisibility"],"secondaryStats":["level":2,"power":"always hungry"]]]
        
        let builder = ModelBuilder(rootName: "container", classPrefix: "UT").buildModel(object).findAliasses()
        
        XCTAssert(builder.types.count == 3)
        XCTAssert(builder.typeAliasses.count == 1)
        
    }
}
