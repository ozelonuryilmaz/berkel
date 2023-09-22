//
//  String+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.09.2023.
//

import Foundation

extension String {

    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
        case phone_long_regex = "(([+]?\\d{2})|\\d?)[ \\t-]*[(]?[ \\t-]*[0-9]{3,4}[ \\t-]*[)]?[ \\t-]*[0-9]{3}[ \\t-]*[0-9]{2}[ \\t-]*[0-9]{2}|([ \\t-]*[0-9]{3}[ \\t-]*[0-9]{2}[ \\t-]*[0-9]{2})"
    }

    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }

    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }


}
