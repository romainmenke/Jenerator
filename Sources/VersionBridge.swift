//
//  Bridge.swift
//  Jenerator
//
//  Created by Romain Menke on 10/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


#if swift(>=3.0)
    
    extension String {
        var urlEncoding: String? {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        }
    }

    #elseif swift(>=2.2)
    extension String {
        
        func components(separatedBy separator: String) -> [String] {
            return self.componentsSeparatedByString(separator)
        }
        
        func uppercased() -> String {
            return self.uppercaseString
        }
        
        func lowercased() -> String {
            return self.lowercaseString
        }
        
        var removingPercentEncoding: String? {
            return self.stringByRemovingPercentEncoding
        }
        
        var urlEncoding: String? {
            return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
        
        func rangeOfCharacter(from set: NSCharacterSet) -> Range<Index>? {
            return rangeOfCharacterFromSet(set)
        }
        
        func replacingOccurrences(of target: String, with replacement: String) -> String {
            return stringByReplacingOccurrencesOfString(target, withString: replacement)
        }
        
        mutating func removeSubrange(_ range:Range<Index>) {
            self.removeRange(range)
        }
        
    }
#endif


#if swift(>=3.0)
    #elseif swift(>=2.2)
    extension CollectionType where Generator.Element : Equatable {
        
        func index(of element: Self.Generator.Element) -> Self.Index? {
            return self.indexOf(element)
        }
    }
    
    extension CollectionType {
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
    
    extension SequenceType {
        
        public func enumerated() -> EnumerateSequence<Self> {
            return enumerate()
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


#if swift(>=3.0)
    extension URL {
        /**
         Drop the last component from an NSURL
         
         - returns: the url without it's last component
         */
        func removeLast() -> URL? {
            return URL(string: (self.absoluteString?.replacingOccurrences(of: self.lastPathComponent ?? "", with: ""))!)
        }
    }
#elseif swift(>=2.2)
    extension NSURL {
        /**
         Drop the last component from an NSURL
         
         - returns: the url without it's last component
         */
        func removeLast() -> NSURL? {
            return NSURL(string: (self.absoluteString.replacingOccurrences(of: self.lastPathComponent ?? "", with: "")))
        }
    }
#endif

#if swift(>=3.0)
    typealias VURL = URL
    typealias VData = Data
    typealias VCharacterSet = CharacterSet
#elseif swift(>=2.2)
    typealias VURL = NSURL
    typealias VData = NSData
    typealias VCharacterSet = NSCharacterSet
    typealias JSONSerialization = NSJSONSerialization
#endif

#if swift(>=3.0)
#elseif swift(>=2.2)
    extension NSMutableCharacterSet {
        func formUnion(with otherSet:NSCharacterSet) {
            self.formUnionWithCharacterSet(otherSet)
        }
    }
    
    extension NSCharacterSet {
        static var uppercaseLetters : NSCharacterSet {
            get {
                return self.uppercaseLetterCharacterSet()
            }
        }
        
        static var lowercaseLetters : NSCharacterSet {
            get {
                return self.lowercaseLetterCharacterSet()
            }
        }
        
        static var alphanumerics : NSCharacterSet {
            get {
                return self.alphanumericCharacterSet()
            }
        }
        
        convenience init(charactersIn string: String) {
            self.init(charactersInString:string)
        }
        
        var inverted : NSCharacterSet {
            get {
                return self.invertedSet
            }
        }
    }
#endif


//#if swift(>=3.0)
//#elseif swift(>=2.2)
//#endif
