//
//  JSONModelBuilderTests.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

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
        let (result,content) = builder.buildMultiDimentionalArrayOfObject(withName: "name", array: object)
        
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
        
        let container = JSONCustomType(fields: [userField], name: "jenerator")
        
        let builder = ModelBuilder(rootName: "jenerator", classPrefix: "UT")
        
        let types = builder.buildModel(fromData: object, withSource:nil).types
        XCTAssert(types.count == 3)
        
        for type in types {
            if type.name == userType.name {
                XCTAssert(type == userType)
                XCTAssert(type.fields == userType.fields)
                continue
            }
            if type.name == statsType.name {
                XCTAssert(type == statsType)
                XCTAssert(type.fields == statsType.fields)
                continue
            }
            if type.name == container.name {
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
        
        let container = JSONCustomType(fields: [userField], name: "jenerator")
        
        let builder = ModelBuilder(rootName: "jenerator", classPrefix: "UT")
        
        let types = builder.buildModel(fromData: object, withSource:nil).types
        
        XCTAssert(types.count == 3)
        
        for type in types {
            if type.name == userType.name {
                XCTAssert(type == userType)
                XCTAssert(type.fields == userType.fields)
                continue
            }
            if type.name == statsType.name {
                XCTAssert(type == statsType)
                XCTAssert(type.fields == statsType.fields)
                continue
            }
            if type.name == container.name {
                XCTAssert(type == container)
                XCTAssert(type.fields == container.fields)
                continue
            }
            XCTFail()
        }
    }
    
    func testBuildTypesDelta() {
        
        let objectA : [String:AnyObject] = ["user":["name":"bob"]]
        let builderA = ModelBuilder(rootName: "jenerator", classPrefix: "UT").buildModel(fromData: objectA, withSource:nil)
        XCTAssert(builderA.types.count == 2)
        
        let objectB : [[String:AnyObject]] = [["user":["name":"bob"]]]
        let builderB = ModelBuilder(rootName: "jenerator", classPrefix: "UT").buildModel(fromData: objectB, withSource:nil)
        
        XCTAssert(builderB.types.count == 3)
        
    }
    
    func testBuildTypesWithAliasses() {
        
        let object : [String:AnyObject] = ["user":["stats":["level":1,"power":"invisibility"],"secondaryStats":["level":2,"power":"always hungry"]]]
        
        let builder = ModelBuilder(rootName: "jenerator", classPrefix: "UT").buildModel(fromData: object, withSource:nil).findAliasses()
        
        XCTAssert(builder.types.count == 3)
        XCTAssert(builder.typeAliasses.count == 1)
        
    }
    
    func testFromAPISourceExpectSuccess() {
        
        guard let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys") else {
            XCTFail()
            return
        }
        
        guard let builder = ModelBuilder.fromSource(url, classPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(fromModel: builder.findAliasses())
        NSLog(code ?? "")
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromSourceExpectSuccess() {
        
        guard let url = NSURL(string: "https://raw.githubusercontent.com/romainmenke/Jenerator/master/examples/sample/somejson.json") else {
            XCTFail()
            return
        }
        
        guard let builder = ModelBuilder.fromSource(url, classPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(fromModel: builder.findAliasses())
        
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromSourceArrayExpectSuccess() {
        
        guard let url = NSURL(string: "https://raw.githubusercontent.com/romainmenke/Jenerator/master/examples/sample/somejsonarray.json") else {
            XCTFail()
            return
        }
        
        guard let builder = ModelBuilder.fromSource(url, classPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(fromModel: builder.findAliasses())
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromSourceDifferenceInTypeExpectSuccess() {
        
        guard let url = NSURL(string: "https://raw.githubusercontent.com/romainmenke/Jenerator/master/examples/sample/sametypedifferentfields.json") else {
            XCTFail()
            return
        }
        
        guard let builder = ModelBuilder.fromSource(url, classPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(fromModel: builder.findAliasses())
        NSLog(code ?? "")
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromFileExpectSuccess() {
        
        guard let path = NSBundle(for: JSONModelBuilderTests.self).pathForResource("json-test-alpha", ofType: "json") else {
            XCTFail()
            return
        }
        
        
        guard let builder = ModelBuilder.fromFile(path, classPrefix: "UT") else {
            XCTFail()
            return
        }
        
        XCTAssert(SwiftGenerator.generate(fromModel: builder.findAliasses()) != nil)
        
    }
    
    func testFromSourceExpectFail() {
        
        guard let url = NSURL(string: "https://google.com") else {
            XCTFail()
            return
        }
        
        guard let _ = ModelBuilder.fromSource(url, classPrefix: "YF") else {
            return
        }
        
        XCTFail()
        
    }
    
    func testFromFileExpectFail() {
        
        guard let path = NSBundle(for: JSONModelBuilderTests.self).pathForResource("json-test-beta", ofType: "json") else {
            XCTFail()
            return
        }
        
        
        guard let _ = ModelBuilder.fromFile(path, classPrefix: "UT") else {
            return
        }
        
        XCTFail()
        
    }
    
    func testFromFileExpectFailBeta() {
        
        guard let path = NSBundle(for: JSONModelBuilderTests.self).pathForResource("json-test-beta", ofType: "json") else {
            XCTFail()
            return
        }
        
        
        guard let _ = ModelBuilder.fromFile(path + "blah", classPrefix: "UT") else {
            return
        }
        
        XCTFail()
        
    }
}
