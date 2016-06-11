//
//  JSONQuery.swift
//  Jenerator
//
//  Created by Romain Menke on 10/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


/**
 *  A JSONQuery
 */
struct JSONQuery {
    
    var params : [(key:String,value:String)]
    var source : NSURL
    
    init(source:NSURL) {
        
        self.source = source
        self.params = []
        
        guard let query = source.query else {
            return
        }
        
        for pair in query.components(separatedBy: "&") {
            let keyValue = pair.components(separatedBy: "=")
            guard var key = keyValue.first, var value = keyValue.last where keyValue.count == 2 else {
                continue
            }
            key = key.removingPercentEncoding ?? key
            value = value.removingPercentEncoding ?? value
            params.append((key:key,value:value))
        }
    }
}