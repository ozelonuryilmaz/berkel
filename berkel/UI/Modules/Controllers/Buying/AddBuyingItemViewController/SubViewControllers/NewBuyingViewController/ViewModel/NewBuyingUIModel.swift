//
//  NewBuyingUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewBuyingUIModel {

    var newBuyingData: NewBuyingModel { get }
    var firstPayment: NewBuyingPaymentModel { get }

    var sellerName: String { get }
    var sellerTCKN: String { get }

    var errorMessage: String? { get }

    var season: String { get }

    init(data: NewBuyingPassData)

    // Setter
    mutating func setProduct(_ product: String)
    mutating func setPrice(_ price: String)
    mutating func setPayment(_ payment: String)
    mutating func setDesc(_ desc: String)
}

struct NewBuyingUIModel: INewBuyingUIModel {

    // MARK: Definitions
    private let seller: AddBuyingItemResponseModel

    // MARK: Initialize
    init(data: NewBuyingPassData) {
        self.seller = data.seller
    }

    // MARK: Computed Props
    var sellerName: String {
        return seller.name
    }

    var sellerTCKN: String {
        return seller.tckn
    }

    var sellerId: String {
        return seller.id
    }

    private var product: String = ""
    private var price: Double = 0.0
    private var payment: Int = 0
    private var desc: String = ""
}

// MARK: Props
extension NewBuyingUIModel {

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var newBuyingData: NewBuyingModel {
        let date = Date().dateFormatterApiResponseType()
        return NewBuyingModel(
            userId: self.userId,
            date: date,
            sellerId: self.sellerId,
            sellerName: self.sellerName,
            productName: self.product,
            productKGPrice: self.price,
            desc: self.desc,
            isActive: true
        )
    }

    var firstPayment: NewBuyingPaymentModel {
        let date = Date().dateFormatterApiResponseType()
        return NewBuyingPaymentModel(id: nil, userId: userId, date: date, payment: self.payment, description: "Peşinat")
    }

    var errorMessage: String? {
        if product.count < 1 {
            return "Lütfen ürün adını giriniz"
        }

        if price == 0.0 {
            return "Lütfen ortalama kg fiyatını giriniz"
        }

        if desc.count < 10 {
            return "Lütfen açıklama yazınız"
        }

        return nil
    }
}

// MARK: Setter
internal extension NewBuyingUIModel {

    mutating func setProduct(_ product: String) {
        self.product = product
    }

    mutating func setPrice(_ price: String) {
        self.price = Double(price) ?? 0.0
    }

    mutating func setPayment(_ payment: String) {
        self.payment = Int(payment) ?? 0
    }

    mutating func setDesc(_ desc: String) {
        self.desc = desc
    }
}
