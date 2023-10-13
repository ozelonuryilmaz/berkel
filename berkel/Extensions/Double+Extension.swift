//
//  Double+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.10.2023.
//

import Foundation

extension Double {
    
    func format() -> String {
        if Double(Int(self)) == self {
            return String(Int(self))
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.minimumFractionDigits = 2
            guard let s = numberFormatter.string(for: self) else {
                fatalError("Couldn't format number")
            }
            return s
        }
    }
    
    func decimalString() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal // Noktalı biçim
        formatter.minimumFractionDigits = 0 // En az sıfır basamaklı kesir
        formatter.maximumFractionDigits = 0 // En çok iki basamaklı kesir
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
