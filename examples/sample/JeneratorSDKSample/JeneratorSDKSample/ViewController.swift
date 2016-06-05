//
//  ViewController.swift
//  JeneratorSDKSample
//
//  Created by Romain Menke on 05/06/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Cocoa
import JeneratorSDK

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        longClearWay()
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func longClearWay() {
        
        // Test Url
        let apiQueryUrlString = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        
        // Create NSURL
        guard let apiQueryUrl = NSURL(string: apiQueryUrlString) else {
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
        guard let swiftCode = SwiftGenerator.generate(model: builderWithAliasses) else {
            print("no types contained in builder")
            return
        }
        
        // Print Swift Code to Debug Console
        print(swiftCode)
        
    }
    
    func shortWay() {
        
        guard let apiQueryUrl = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys") else {
            print("not a valid url")
            return
        }
        
        guard let builder = ModelBuilder.fromSource(apiQueryUrl, classPrefix: "YW")?.findAliasses() else {
            print("invalid JSON, or no data")
            return
        }
        
        print(SwiftGenerator.generate(model: builder))
    }

}

