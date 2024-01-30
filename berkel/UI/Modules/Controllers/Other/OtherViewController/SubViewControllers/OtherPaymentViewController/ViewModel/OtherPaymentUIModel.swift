//
//  OtherPaymentUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

protocol IOtherPaymentUIModel {

    var otherId: String { get }
    var categoryName: String { get }
    var otherSellerName: String { get }

    var season: String { get }

    var payment: Int { get }
    var data: OtherPaymentModel { get }

    init(data: OtherPaymentPassData)

    mutating func setDate(date: String?)
    mutating func setPayment(_ text: String)
    mutating func setDesc(_ text: String)
}

struct OtherPaymentUIModel: IOtherPaymentUIModel {

    // MARK: Definitions
    let otherId: String
    let categoryName: String
    let otherSellerId: String?
    let otherSellerName: String

    // MARK: Initialize
    init(data: OtherPaymentPassData) {
        self.otherId = data.otherId
        self.categoryName = data.categoryName
        self.otherSellerId = data.otherSellerId
        self.otherSellerName = data.otherSellerName
    }

    // MARK: Computed Props
    var date: String? = Date().dateFormatterApiResponseType()
    var payment: Int = 0
    var desc: String? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var data: OtherPaymentModel {
        return OtherPaymentModel(
            id: nil,
            userId: userId,
            otherSellerId: otherSellerId,
            otherSellerName: otherSellerName,
            date: date,
            payment: payment,
            description: desc
        )
    }
}

// MARK: Props
extension OtherPaymentUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setPayment(_ text: String) {
        self.payment = Int(text) ?? 0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
