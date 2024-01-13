//
//  Double+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.10.2023.
//

import Foundation

extension Double {

    func decimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "tr_TR")
        numberFormatter.numberStyle = .decimal // Noktalı biçim

        // 1000'den büyük veya tam bir sayıysa kesiratı gösterme
        if Double(Int(self)) == self || self > 1000 {
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.minimumFractionDigits = 0
        } else {
            numberFormatter.minimumFractionDigits = 2 // En az sıfır basamaklı kesir
            numberFormatter.maximumFractionDigits = 2 // En çok iki basamaklı kesir
        }

        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
