//
//  SellerPaymentUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

protocol ISellerPaymentUIModel {

    var sellerId: String { get }
    var season: String { get }
    var customerName: String { get }
    var productName: String { get }

    var payment: Int { get }
    var data: SellerPaymentModel { get }

    init(data: SellerPaymentPassData)

    mutating func setDate(date: String?)
    mutating func setPayment(_ text: String)
    mutating func setDesc(_ text: String)
}

struct SellerPaymentUIModel: ISellerPaymentUIModel {

    // MARK: Definitions
    let sellerId: String
    let customerName: String
    let productName: String

    // MARK: Initialize
    init(data: SellerPaymentPassData) {
        self.sellerId = data.sellerId
        self.customerName = data.customerName
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

    var data: SellerPaymentModel {
        return SellerPaymentModel(
            id: nil,
            userId: userId,
            date: date,
            payment: payment,
            description: desc
        )
    }
}

// MARK: Props
extension SellerPaymentUIModel {

}

// MARK: Props
extension SellerPaymentUIModel {

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
