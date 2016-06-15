//
//  JSONCustomTypeTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JSONCustomTypeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testJSONCustomTypeEquality() {
        
        let fieldA = JSONField(name: "Alpha", type: JSONDataType.jsonInt)
        
        // different name same fields
        let typeA = JSONCustomType(fields: [], name: "Alpha")
        let typeB = JSONCustomType(fields: [], name: "Beta")
        
        // same name different fields
        let typeC = JSONCustomType(fields: [fieldA], name: "Alpha")
        
        XCTAssert(typeA == typeA)
        XCTAssert(typeA == typeC)
        XCTAssert(typeA != typeB)
        XCTAssert(typeB != typeC)
    }
    
    func testJSONCustomTypeCompatibility() {
        
        let fieldA = JSONField(name: "Alpha", type: JSONDataType.jsonInt)
        let fieldB = JSONField(name: "Beta", type: JSONDataType.jsonString)
        let fieldC = JSONField(name: "Delta", type: JSONDataType.jsonBool)
        
        // different name same fields
        let typeA = JSONCustomType(fields: [fieldA,fieldB], name: "Alpha")
        let typeB = JSONCustomType(fields: [fieldA,fieldB,fieldC], name: "Alpha")
        let typeC = JSONCustomType(fields: [fieldA,fieldC], name: "Alpha")
        let typeD = JSONCustomType(fields: [fieldA,fieldB], name: "Beta")
        
        XCTAssert(typeA.isCompatible(withType: typeA) == true)
        XCTAssert(typeA.isCompatible(withType: typeB) == true)
        XCTAssert(typeA.isCompatible(withType: typeC) == false)
        XCTAssert(typeA.isCompatible(withType: typeD) == false)
        
        XCTAssert(typeB.isCompatible(withType: typeA) == false)
        XCTAssert(typeB.isCompatible(withType: typeB) == true)
        XCTAssert(typeB.isCompatible(withType: typeC) == false)
        XCTAssert(typeB.isCompatible(withType: typeD) == false)
        
        XCTAssert(typeC.isCompatible(withType: typeA) == false)
        XCTAssert(typeC.isCompatible(withType: typeB) == true)
        XCTAssert(typeC.isCompatible(withType: typeC) == true)
        XCTAssert(typeC.isCompatible(withType: typeD) == false)
        
        XCTAssert(typeD.isCompatible(withType: typeA) == false)
        XCTAssert(typeD.isCompatible(withType: typeB) == false)
        XCTAssert(typeD.isCompatible(withType: typeC) == false)
        XCTAssert(typeD.isCompatible(withType: typeD) == true)

    }

}
