//
//  SwiftifyTests.swift
//  Jenerator
//
//  Created by Romain Menke on 17/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class SwiftifyTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFieldNames() {
        // first char        
        XCTAssert("-".swiftifiedFieldName == "aField")
        
        XCTAssert("_foo".swiftifiedFieldName == "_foo")
        XCTAssert("-foo".swiftifiedFieldName == "foo")
        XCTAssert("_-foo".swiftifiedFieldName == "_foo")
        XCTAssert("-_foo".swiftifiedFieldName == "_foo")
        
        // middle char
        XCTAssert("foo-Fooz".swiftifiedFieldName == "fooFooz")
        
        // reserved words
        XCTAssert("class".swiftifiedFieldName == "`class`")
    }
    
    func testStringLiteral() {
        
        XCTAssert("\\n".swiftifiedStringLiteral == "\\\\n")
        XCTAssert("\'foo\'".swiftifiedStringLiteral == "\\\'foo\\\'")
        XCTAssert("\"foo\"".swiftifiedStringLiteral == "\\\"foo\\\"")
        
        XCTAssert("\'foo\\n\'".swiftifiedStringLiteral == "\\\'foo\\\\n\\\'")
        
    }
}
