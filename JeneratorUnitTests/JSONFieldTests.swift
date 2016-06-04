//
//  JSONFieldTests.swift
//  Jenerator
//
//  Created by XcodeBuildServer on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest

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
        let typeInt = JSONDataType.JSONInt
        let typeDouble = JSONDataType.JSONDouble
        
        let fieldA = JSONField(name: "Alpha", type: typeInt)
        let fieldB = JSONField(name: "Alpha", type: typeDouble)
        let fieldC = JSONField(name: "Beta", type: typeInt)
        let fieldD = JSONField(name: "alpha", type: typeInt)
        
        XCTAssert(fieldA == fieldA)
        XCTAssert(fieldA != fieldB)
        XCTAssert(fieldA != fieldC)
        XCTAssert(fieldA != fieldD)
    }

}
