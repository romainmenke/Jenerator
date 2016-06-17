//
//  JNCustomTypeTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JNCustomTypeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testJNCustomTypeEquality() {
        
        let fieldA = JNField(name: "Alpha", type: JNDataType.int)
        
        // different name same fields
        let typeA = JNCustomType(fields: [], name: "Alpha", classPrefix: "UT")
        let typeB = JNCustomType(fields: [], name: "Beta", classPrefix: "UT")
        
        // same name different fields
        let typeC = JNCustomType(fields: [fieldA], name: "Alpha", classPrefix: "UT")
        
        XCTAssert(typeA == typeA)
        XCTAssert(typeA == typeC)
        XCTAssert(typeA != typeB)
        XCTAssert(typeB != typeC)
    }
    
    func testJNCustomTypeCompatibility() {
        
        let fieldA = JNField(name: "Alpha", type: JNDataType.int)
        let fieldB = JNField(name: "Beta", type: JNDataType.string)
        let fieldC = JNField(name: "Delta", type: JNDataType.bool)
        
        // different name same fields
        let typeA = JNCustomType(fields: [fieldA,fieldB], name: "Alpha", classPrefix: "UT")
        let typeB = JNCustomType(fields: [fieldA,fieldB,fieldC], name: "Alpha", classPrefix: "UT")
        let typeC = JNCustomType(fields: [fieldA,fieldC], name: "Alpha", classPrefix: "UT")
        let typeD = JNCustomType(fields: [fieldA,fieldB], name: "Beta", classPrefix: "UT")
        
        XCTAssert(typeA.isCompatible(with: typeA) == true)
        XCTAssert(typeA.isCompatible(with: typeB) == true)
        XCTAssert(typeA.isCompatible(with: typeC) == false)
        XCTAssert(typeA.isCompatible(with: typeD) == false)
        
        XCTAssert(typeB.isCompatible(with: typeA) == false)
        XCTAssert(typeB.isCompatible(with: typeB) == true)
        XCTAssert(typeB.isCompatible(with: typeC) == false)
        XCTAssert(typeB.isCompatible(with: typeD) == false)
        
        XCTAssert(typeC.isCompatible(with: typeA) == false)
        XCTAssert(typeC.isCompatible(with: typeB) == true)
        XCTAssert(typeC.isCompatible(with: typeC) == true)
        XCTAssert(typeC.isCompatible(with: typeD) == false)
        
        XCTAssert(typeD.isCompatible(with: typeA) == false)
        XCTAssert(typeD.isCompatible(with: typeB) == false)
        XCTAssert(typeD.isCompatible(with: typeC) == false)
        XCTAssert(typeD.isCompatible(with: typeD) == true)

    }

}
