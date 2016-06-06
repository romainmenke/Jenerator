//
//  JSONCoderTests.swift
//  Jenerator
//
//  Created by Romain Menke on 04/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JSONCoderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEncode() {
        let object : [String:AnyObject] = ["user":["name":"bob"]]
        let badObject : AnyObject = 5
        let array : AnyObject = [1,2]
        
        XCTAssert(JSONCoder.encode(object) != nil)
        XCTAssert(JSONCoder.encode(badObject) == nil)
        XCTAssert(JSONCoder.encode(array) != nil)
    }
    
    func testDecode() {
        let object : [String:AnyObject] = ["user":["name":"bob"]]
        let array : AnyObject = [1,2]
        let empty : AnyObject = [:]
        
        if let json = JSONCoder.encode(object), decodedObject = JSONCoder.decode(json) as? [String:AnyObject], let user = decodedObject["user"] as? [String:String] {
            XCTAssert(user == ["name":"bob"])
        } else {
            XCTFail()
        }
        
        if let json = JSONCoder.encode(array), decodedArray = JSONCoder.decode(json) as? [NSNumber], original = array as? [NSNumber] {
            XCTAssert(decodedArray == original)
        } else {
            XCTFail()
        }
        
        if let json = JSONCoder.encode(empty) {
            XCTAssert((JSONCoder.decode(json) as? NSDictionary) != nil)
        } else {
            XCTFail()
        }
    }

}
