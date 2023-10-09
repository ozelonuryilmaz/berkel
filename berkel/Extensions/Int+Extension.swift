//
//  Int+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.10.2023.
//

import Foundation

extension Int {

    func priceString() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal // Noktalı biçim
        formatter.minimumFractionDigits = 0 // En az sıfır basamaklı kesir
        formatter.maximumFractionDigits = 0 // En çok iki basamaklı kesir
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
