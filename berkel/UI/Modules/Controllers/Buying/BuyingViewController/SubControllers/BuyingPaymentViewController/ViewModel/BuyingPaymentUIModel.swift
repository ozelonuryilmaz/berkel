//
//  BuyingPaymentUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingPaymentUIModel {

    var buyingId: String { get }
    var season: String { get }
    var sellerName: String { get }
    var productName: String { get }

    var payment: Int { get }

    var data: NewBuyingPaymentModel { get }

    init(data: BuyingPaymentPassData)

    mutating func setDate(date: String?)
    mutating func setPayment(_ text: String)
    mutating func setDesc(_ text: String)

}

struct BuyingPaymentUIModel: IBuyingPaymentUIModel {

    // MARK: Definitions
    let buyingId: String
    let sellerName: String
    let productName: String

    // MARK: Initialize
    init(data: BuyingPaymentPassData) {
        self.buyingId = data.buyingId
        self.sellerName = data.sellerName
        self.productName = data.productName
    }

    var date: String? = Date().dateFormatterApiResponseType()
    var payment: Int = 0
    var desc: String? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var data: NewBuyingPaymentModel {
        return NewBuyingPaymentModel(
            id: nil,
            userId: userId,
            date: date,
            payment: payment,
            description: desc
        )
    }

    // MARK: Computed Props
}

// MARK: Props
extension BuyingPaymentUIModel {

}

// MARK: Setter
extension BuyingPaymentUIModel {

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
