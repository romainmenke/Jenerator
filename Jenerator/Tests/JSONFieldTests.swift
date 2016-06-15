//
//  JSONFieldTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JSONFieldTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONFieldEquality() {
        let typeInt = JSONDataType.jsonInt
        let typeDouble = JSONDataType.jsonDouble
        
        let fieldA = JSONField(name: "Alpha", type: typeInt)
        let fieldB = JSONField(name: "Alpha", type: typeDouble)
        let fieldC = JSONField(name: "Beta", type: typeInt)
        let fieldD = JSONField(name: "alpha", type: typeInt)
        
        XCTAssert(fieldA == fieldA)
        XCTAssert(fieldA != fieldB)
        XCTAssert(fieldA != fieldC)
        XCTAssert(fieldA != fieldD)
    }
    
    func testHashValue() {
        
        let fieldA = JSONField(name: "Alpha", type: JSONDataType.jsonInt)
        let fieldB = JSONField(name: "Alpha", type: JSONDataType.jsonDouble)
        let fieldC = JSONField(name: "Beta", type: JSONDataType.jsonInt)
        
        let fieldA2 = JSONField(name: "Alpha", type: JSONDataType.jsonInt)
        
        XCTAssert(fieldA.hashValue != fieldB.hashValue)
        XCTAssert(fieldA.hashValue != fieldC.hashValue)
        XCTAssert(fieldA.hashValue == fieldA2.hashValue)
        XCTAssert(fieldA.hashValue == fieldA.hashValue)
        
    }

}
