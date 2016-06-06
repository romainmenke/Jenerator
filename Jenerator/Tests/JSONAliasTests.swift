//
//  JSONAliasTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JSONAliasTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONAliasEquality() {
        
        let typeA = JSONCustomType(fields: [], name: "Original")
        let typeB = JSONCustomType(fields: [], name: "AliasA")
        let typeC = JSONCustomType(fields: [], name: "AliasB")
        
        let aliasA = JSONTypeAlias(original: typeA, alias: typeB)
        let aliasB = JSONTypeAlias(original: typeA, alias: typeC)
        let aliasC = JSONTypeAlias(original: typeA, alias: typeB)
        
        XCTAssert(aliasA == aliasC)
        XCTAssert(aliasA != aliasB)
    }
        
}