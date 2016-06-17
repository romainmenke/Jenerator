//
//  JSONFieldTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JNFieldTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONFieldEquality() {
        
        let fieldA = JNField(name: "Alpha", type: .int)
        let fieldB = JNField(name: "Alpha", type: .double)
        let fieldC = JNField(name: "Beta", type: .int)
        let fieldD = JNField(name: "alpha", type: .int)
        
        XCTAssert(fieldA == fieldA)
        XCTAssert(fieldA != fieldB)
        XCTAssert(fieldA != fieldC)
        XCTAssert(fieldA != fieldD)
    }
    
    func testHashValue() {
        
        let fieldA = JNField(name: "Alpha", type: JNDataType.int)
        let fieldB = JNField(name: "Alpha", type: JNDataType.double)
        let fieldC = JNField(name: "Beta", type: JNDataType.int)
        
        let fieldA2 = JNField(name: "Alpha", type: JNDataType.int)
        
        XCTAssert(fieldA.hashValue != fieldB.hashValue)
        XCTAssert(fieldA.hashValue != fieldC.hashValue)
        XCTAssert(fieldA.hashValue == fieldA2.hashValue)
        XCTAssert(fieldA.hashValue == fieldA.hashValue)
        
    }

}
