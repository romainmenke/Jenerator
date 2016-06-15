//
//  BasicUsage.swift
//  JeneratorSDKSample
//
//  Created by Romain Menke on 14/06/2016.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation
import JeneratorSDK


// Just a simple example
func longClearWay() {
    
    // Test Url
    let apiQueryUrlString = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
    
    // Create NSURL
    guard let apiQueryUrl = URL(string: apiQueryUrlString) else {
        print("not a valid url")
        return
    }
    
    // Build Model
    guard let builder = ModelBuilder.fromSource(apiQueryUrl, classPrefix: "YW") else {
        print("invalid JSON, or no data")
        return
    }
    
    // Build Aliasses
    let builderWithAliasses = builder.findAliasses()
    
    // Generate Swift Code
    guard let swiftCode = SwiftGenerator.generate(fromModel: builderWithAliasses) else {
        print("no types contained in builder")
        return
    }
    
    // Print Swift Code to Debug Console
    print(swiftCode)
    
}

// A more compact example
func shortWay() {
    
    guard let apiQueryUrl = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys") else {
        print("not a valid url")
        return
    }
    
    guard let builder = ModelBuilder.fromSource(apiQueryUrl, classPrefix: "YW")?.findAliasses() else {
        print("invalid JSON, or no data")
        return
    }
    
    print(SwiftGenerator.generate(fromModel: builder) ?? "")
}

// Another example with some tricky naming for fields
func shortWayTwo() {
    
    guard let apiQueryUrl = URL(string: "http://dev.markitondemand.com/MODApis/Api/v2/InteractiveChart/json?parameters=%7B%22Normalized%22%3Afalse%2C%22NumberOfDays%22%3A365%2C%22DataPeriod%22%3A%22Day%22%2C%22Elements%22%3A%5B%7B%22Symbol%22%3A%22AAPL%22%2C%22Type%22%3A%22price%22%2C%22Params%22%3A%5B%22c%22%5D%7D%5D%7D") else {
        print("not a valid url")
        return
    }
    
    guard let builder = ModelBuilder.fromSource(apiQueryUrl, classPrefix: "YW")?.findAliasses() else {
        print("invalid JSON, or no data")
        return
    }
    
    print(SwiftGenerator.generate(fromModel: builder) ?? "")
}
