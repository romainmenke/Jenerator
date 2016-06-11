//
//  JSONQueryTests.swift
//  Jenerator
//
//  Created by Romain Menke on 10/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import XCTest
@testable import JeneratorSDK

class JSONQueryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        
        guard let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22BHP.AX%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="), let urlStart = url.absoluteString.components(separatedBy: "?").first else {
            XCTFail()
            return
        }
        
        let query = JSONQuery(source: url)
        
        var urlString = urlStart
        urlString += "?"
        
        #if swift(>=3.0)
            
            for (index,param) in query.params.enumerated() {
                guard let key = param.key.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed()), let value = param.value.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed()) else {
                    continue
                }
                
                if index != 0 {
                    urlString += "&"
                }
                
                urlString += key
                urlString += "="
                urlString += value
            }
            
            XCTAssert(urlString == url.absoluteString)
            
        #elseif swift(>=2.2)
            
            for (index,param) in query.params.enumerate() {
                guard let key = param.key.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()), let value = param.value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) else {
                    continue
                }
                
                if index != 0 {
                    urlString += "&"
                }
                
                urlString += key
                urlString += "="
                urlString += value
            }
            
            XCTAssert(urlString == url.absoluteString)
            
        #endif
        
        
    }



}
