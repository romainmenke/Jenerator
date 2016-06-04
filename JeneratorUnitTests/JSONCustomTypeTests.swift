//
//  JSONCustomTypeTests.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest

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
        
        let fieldA = JSONField(name: "Alpha", type: JSONDataType.JSONInt)
        
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

}
