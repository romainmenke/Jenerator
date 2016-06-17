//
//  JSONAliasTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JNAliasTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONAliasEquality() {
        
        let typeA = JNCustomType(fields: [], name: "Original", classPrefix: "UT")
        let typeB = JNCustomType(fields: [], name: "AliasA", classPrefix: "UT")
        let typeC = JNCustomType(fields: [], name: "AliasB", classPrefix: "UT")
        
        let aliasA = JNTypeAlias(original: typeA, alias: typeB)
        let aliasB = JNTypeAlias(original: typeA, alias: typeC)
        let aliasC = JNTypeAlias(original: typeA, alias: typeB)
        
        XCTAssert(aliasA == aliasC)
        XCTAssert(aliasA != aliasB)
    }
        
}
