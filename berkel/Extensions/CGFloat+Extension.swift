//
//  CGFloat+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

extension CGFloat {

    func adjustWidthRespectToDesignRate() -> CGFloat {
        let designRate = 375 / self
        let value = UIScreen.width / designRate
        return value
    }

    func adjustHeightRespectToDesignRate() -> CGFloat {
        let designRate = 667 / self
        let value = UIScreen.height / designRate
        return value
    }

    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = CGFloat(pow(10.0, Double(places)))
        let valueRounded = (self * divisor).rounded() / divisor
        return valueRounded
    }

}

extension CGFloat {

    /// Absolute of CGFloat value.
    var abs: CGFloat {
        return Swift.abs(self)
    }

    /// Ceil of CGFloat value.
    var ceil: CGFloat {
        return Foundation.ceil(self)
    }

    /// Radian value of degree input.
    var degreesToRadians: CGFloat {
        return .pi * self / 180.0
    }

    /// Floor of CGFloat value.
    var floor: CGFloat {
        return Foundation.floor(self)
    }

    /// Check if CGFloat is positive.
    var isPositive: Bool {
        return self > 0
    }

    /// Check if CGFloat is negative.
    var isNegative: Bool {
        return self < 0
    }

    /// SwifterSwift: Int.
    var int: Int {
        return Int(self)
    }

    /// SwifterSwift: Float.
    var float: Float {
        return Float(self)
    }

    /// SwifterSwift: Double.
    var double: Double {
        return Double(self)
    }

    /// SwifterSwift: Degree value of radian input.
    var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
}
