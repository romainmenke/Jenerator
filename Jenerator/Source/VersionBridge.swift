//
//  Bridge.swift
//  Jenerator
//
//  Created by Romain Menke on 10/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


#if swift(>=3.0)
#elseif swift(>=2.2)
    extension String {
        
        func components(separatedBy separator: String) -> [String] {
            return self.componentsSeparatedByString(separator)
        }
        
        func uppercased() -> String {
            return self.uppercaseString
        }
        
        var removingPercentEncoding: String? {
            return self.stringByRemovingPercentEncoding
        }
        
    }
#endif


#if swift(>=3.0)
#elseif swift(>=2.2)
    extension CollectionType where Generator.Element : Equatable {
        
        func index(of element: Self.Generator.Element) -> Self.Index? {
            return self.indexOf(element)
        }
        
        func index(of predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Index? {
            if let index = try? self.indexOf(predicate) {
                return index
            } else {
                return nil
            }
        }
        
    }
    
    extension Array {
        
        mutating func remove(at index: Int) -> Element {
            return self.removeAtIndex(index)
        }
        
    }
#endif

#if swift(>=3.0)
#elseif swift(>=2.2)
    extension String {
        
        func replacingOccurrences(of target: String, with replacement: String) -> String {
            return stringByReplacingOccurrencesOfString(target, withString: replacement)
        }
        
    }
    
#endif

#if swift(>=3.0)
#elseif swift(>=2.2)
    extension NSData {
        
        convenience init?(contentsOf url: NSURL) {
            self.init(contentsOfURL:url)
        }
        
    }
    
#endif


#if swift(>=3.0)
#elseif swift(>=2.2)
    extension NSBundle {
        
        convenience init(for aClass: Swift.AnyClass) {
            self.init(forClass: aClass)
        }
        
    }
#endif

//#if swift(>=3.0)
//#elseif swift(>=2.2)
//#endif


