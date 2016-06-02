//
//  MagicTests.swift
//  Jenerator
//
//  Created by Romain Menke on 02/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest

class MagicTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAppendUnique() {
        var array : [String] = ["foo1","foo2"]
        array.appendUnique("foo2")
        array.appendUnique("foo3")
        
        XCTAssert(array == ["foo1","foo2","foo3"])
    }

    func testUpperCaseFirst() {
        
        let stringAlpha = "foo"
        let stringBeta = "1foo"
        let stringDelta = "Foo"
        
        XCTAssert(stringAlpha.first == "f")
        XCTAssert(stringAlpha.last == "o")
        
        XCTAssert(stringAlpha.uppercaseFirst == "Foo")
        XCTAssert(stringBeta.uppercaseFirst == "1foo")
        XCTAssert(stringDelta.uppercaseFirst == "Foo")
    }
    
    func testIsBool() {
        
        func anyAsNumber(any:AnyObject) -> NSNumber {
            if let number = any as? NSNumber {
                return number
            } else {
                XCTFail()
                return 0
            }
        }
        
        let number1Any : AnyObject = 1
        let number0Any : AnyObject = 0
        let numberAny : AnyObject = 1.1
        
        let boolTrueAny : AnyObject = true
        let boolFalseAny : AnyObject = false
        
        XCTAssert(anyAsNumber(numberAny).isBool() == false)
        XCTAssert(anyAsNumber(number1Any).isBool() == false)
        XCTAssert(anyAsNumber(number0Any).isBool() == false)
        XCTAssert(anyAsNumber(boolTrueAny).isBool() == true)
        XCTAssert(anyAsNumber(boolFalseAny).isBool() == true)
        
    }
    
    func testIsBoolElaborate() {
        
        func anyAsNumber(any:AnyObject) -> NSNumber {
            if let number = any as? NSNumber {
                return number
            } else {
                XCTFail()
                return 0
            }
        }
        
        for i in 0...1000 {
            let numberAny : AnyObject = i
            XCTAssert(anyAsNumber(numberAny).isBool() == false)
        }
        
        let boolTrueAny : AnyObject = true
        let boolFalseAny : AnyObject = false
        
        XCTAssert(anyAsNumber(boolTrueAny).isBool() == true)
        XCTAssert(anyAsNumber(boolFalseAny).isBool() == true)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
