//
//  JSONModelBuilderTests.swift
//  Jenerator
//
//  Created by Romain Menke on 03/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JNModelTests: XCTestCase {

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
        let builder = JNModel()
        
        XCTAssert(builder.arrayContainsObjects(object) == true)
        XCTAssert(builder.arrayContainsObjects(data) == false)
        
    }
    
    func testBuildMultiArrayObject() {
        
        let object = [[[["some":"foo"]]]]
        
        let builder = JNModel()
        let (result,content) = builder.buildMultiDimentionalArrayOfObject(withName: "name", array: object)
        
        let testType = JNDataType.array(type: JNDataType.array(type: JNDataType.array(type: JNDataType.type(type: "name"))))
        
        XCTAssert(content as? [String:String] ?? [:] == ["some":"foo"])
        XCTAssert(result == testType)
        
    }
    
    func testBuildTypesAlpha() {
        
        let object : [String:AnyObject] = ["user":["stats":["level":1,"power":"invisibility"]]]
        
        let levelField = JNField(name: "level", type: .int)
        let powerField = JNField(name: "power", type: .string)
        let statsType = JNCustomType(fields: [levelField,powerField], name: "stats", classPrefix: "UT")
        
        let statsField = JNField(name: "stats", type: JNDataType.type(type: "stats"))
        let userType = JNCustomType(fields: [statsField], name: "user", classPrefix: "UT")
        
        let userField = JNField(name: "user", type: JNDataType.type(type: "user"))
        
        let container = JNCustomType(fields: [userField], name: "jenerator", classPrefix: "UT")
        
        let builder = JNModel()
        
        let types = builder.build(fromData: object, withRootName:"jenerator", source: nil, andClassPrefix: "UT").types
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
        
        let levelField = JNField(name: "level", type: .int)
        let powerField = JNField(name: "power", type: .string)
        let statsType = JNCustomType(fields: [levelField,powerField], name: "stats", classPrefix: "UT")
    
        let statsField = JNField(name: "stats", type: JNDataType.type(type: "stats"))
        let userType = JNCustomType(fields: [statsField], name: "users", classPrefix: "UT")
        
        let userField = JNField(name: "users", type: JNDataType.array(type: JNDataType.type(type: "users")))
        
        let container = JNCustomType(fields: [userField], name: "jenerator", classPrefix: "UT")
        
        let builder = JNModel()
        
        let types = builder.build(fromData: object, withRootName:"jenerator", source: nil, andClassPrefix: "UT").types
        
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
        let builderA = JNModel().build(fromData: objectA, withRootName: "jenerator", source: nil, andClassPrefix: "UT")
        XCTAssert(builderA.types.count == 2)
        
        let objectB : [[String:AnyObject]] = [["user":["name":"bob"]]]
        let builderB = JNModel().build(fromData: objectB, withRootName: "jenerator", source: nil, andClassPrefix: "UT")
        
        XCTAssert(builderB.types.count == 3)
        
    }
    
    func testBuildTypesWithAliasses() {
        
        let object : [String:AnyObject] = ["user":["stats":["level":1,"power":"invisibility"],"secondaryStats":["level":2,"power":"always hungry"]]]
        
        let builder = JNModel().build(fromData: object, withRootName: "jenerator", source: nil, andClassPrefix: "UT").findAliasses()
        
        XCTAssert(builder.types.count == 3)
        XCTAssert(builder.typeAliasses.count == 1)
        
    }
    
    func testFromAPISourceExpectSuccess() {
        
        guard let url = VURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys") else {
            XCTFail()
            return
        }
        
        guard let builder = JNModel.from(url: url, withPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(from: builder.findAliasses())
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromSourceExpectSuccess() {
        
        guard let url = VURL(string: "https://raw.githubusercontent.com/romainmenke/Jenerator/master/examples/sample/somejson.json") else {
            XCTFail()
            return
        }
        
        guard let builder = JNModel.from(url: url, withPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(from: builder.findAliasses())
        
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromSourceArrayExpectSuccess() {
        
        guard let url = VURL(string: "https://raw.githubusercontent.com/romainmenke/Jenerator/master/examples/sample/somejsonarray.json") else {
            XCTFail()
            return
        }
        
        guard let builder = JNModel.from(url: url, withPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(from: builder.findAliasses())
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    func testFromSourceDifferenceInTypeExpectSuccess() {
        
        guard let url = VURL(string: "https://raw.githubusercontent.com/romainmenke/Jenerator/master/examples/sample/sametypedifferentfields.json") else {
            XCTFail()
            return
        }
        
        guard let builder = JNModel.from(url: url, withPrefix: "SJ") else {
            XCTFail()
            return
        }
        
        let code = SwiftGenerator.generate(from: builder.findAliasses())
        NSLog(code ?? "")
        XCTAssert(code != nil)
        XCTAssert(builder.types.count != 0)
        
    }
    
    #if swift(>=3.0)
    func testFromFileExpectSuccess() {
        
        guard let path = Bundle(for: JNModelTests.self).pathForResource("json-test-alpha", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let builder = JNModel.from(file: path, withPrefix: "UT") else {
            XCTFail()
            return
        }
        
        XCTAssert(SwiftGenerator.generate(from: builder.findAliasses()) != nil)
        
    }
    #elseif swift(>=2.2)
    func testFromFileExpectSuccess() {
    
        guard let path = NSBundle(forClass:JNModelTests.self).pathForResource("json-test-alpha", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let builder = JNModel.from(file: path, withPrefix: "UT") else {
            XCTFail()
            return
        }
        
        XCTAssert(SwiftGenerator.generate(from: builder.findAliasses()) != nil)
    
    }
    #endif

    
    func testFromSourceExpectFail() {
        
        guard let url = VURL(string: "https://google.com") else {
            XCTFail()
            return
        }
        
        guard let _ = JNModel.from(url: url, withPrefix: "FT") else {
            return
        }
        
        XCTFail()
        
    }
    
    #if swift(>=3.0)
    func testFromFileExpectFail() {

        guard let path = Bundle(for: JNModelTests.self).pathForResource("json-test-beta", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let _ = JNModel.from(file: path, withPrefix: "UT") else {
            return
        }
        
        XCTFail()
        
    }
    #elseif swift(>=2.2)
    func testFromFileExpectFail() {
        
        guard let path = NSBundle(forClass:JNModelTests.self).pathForResource("json-test-beta", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let _ = JNModel.from(file: path, withPrefix: "UT") else {
            return
        }
        
        XCTFail()
    
    }
    #endif
    
    #if swift(>=3.0)
    func testFromFileExpectFailBeta() {
        
        guard let path = Bundle(for: JNModelTests.self).pathForResource("json-test-beta", ofType: "json") else {
            XCTFail()
            return
        }

        guard let _ = JNModel.from(file: path + "blah", withPrefix: "UT") else {
            return
        }
        
        XCTFail()
        
    }
    #elseif swift(>=2.2)
    func testFromFileExpectFailBeta() {
    
        guard let path = NSBundle(forClass:JNModelTests.self).pathForResource("json-test-beta", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let _ = JNModel.from(file: path + "blah", withPrefix: "UT") else {
            return
        }
        
        XCTFail()
        
    }
    #endif
}
