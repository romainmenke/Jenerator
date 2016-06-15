//
//  SwiftifyFieldNames.swift
//  Jenerator
//
//  Created by Romain Menke on 14/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

extension String {
    
    func swiftify() -> String {
        let firstCharacterAllowedSet = NSMutableCharacterSet()
        firstCharacterAllowedSet.formUnion(with: VCharacterSet.uppercaseLetters)
        firstCharacterAllowedSet.formUnion(with: VCharacterSet.uppercaseLetters)
        firstCharacterAllowedSet.formUnion(with: VCharacterSet(charactersIn: "_"))
        let allowedSet = NSMutableCharacterSet()
        allowedSet.formUnion(with: VCharacterSet.alphanumerics)
        allowedSet.formUnion(with: firstCharacterAllowedSet as VCharacterSet)
        
        let reservedWords = ["associatedtype", "class", "deinit", "enum", "extension", "func", "import", "init", "inout", "internal", "let", "operator", "private", "protocol", "public", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch", "where", "while", "as", "catch", "dynamicType", "false", "is", "nil", "rethrows", "super", "self", "Self", "throw", "throws", "true", "try", "#column", "#file", "#function", "#line", "_,#available", "#column", "#else#elseif", "#endif", "#file", "#function", "#if", "#line", "#selector", "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "Type", "unowned", "weak", "willSet"]
        
        if reservedWords.contains(self) {
            return "`" + self + "`"
        }
        
        var copy = self
        
        while let badRange = copy.rangeOfCharacter(from: allowedSet.inverted) {
            copy.removeSubrange(badRange)
        }
        
        if first.rangeOfCharacter(from: firstCharacterAllowedSet.inverted) != nil {
            return "j" + copy // this needs work
        } else {
            return copy
        }
    }
}
