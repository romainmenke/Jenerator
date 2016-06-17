//
//  SwiftifyFieldNames.swift
//  Jenerator
//
//  Created by Romain Menke on 14/06/2016.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation

extension String {

    var swiftifiedFieldName : String {
        let firstCharacterAllowedSet = NSMutableCharacterSet()
        firstCharacterAllowedSet.formUnion(with: VCharacterSet.lowercaseLetters)
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
        var temp = copy
        
        while let badRange = temp.first.rangeOfCharacter(from: firstCharacterAllowedSet.inverted) {
            temp.removeSubrange(badRange)
            
            // if the field name became empty -> revert
            if !temp.isEmpty {
                copy = temp
            }
        }
        
        while let badRange = copy.rangeOfCharacter(from: allowedSet.inverted) {
            copy.removeSubrange(badRange)
        }
        
        if copy.isEmpty {
            copy = "aField"
        }
        
        return copy
    }
    
    var swiftifiedStringLiteral : String {
        var copy = self
        copy = copy.replacingOccurrences(of: "\\", with: "\\\\")
        copy = copy.replacingOccurrences(of: "\"", with: "\\\"")
        copy = copy.replacingOccurrences(of: "\'", with: "\\\'")
        
        return copy
    }
}
