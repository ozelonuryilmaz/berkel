//
//  NewBuyingUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
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
    mutating func setProduct(id: String, name: String)
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

    private var productId: String? = nil
    private var productName: String = ""
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
            productId: self.productId,
            productName: self.productName,
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
        if productName.isEmpty || productId == nil {
            return "Lütfen ürün seçiniz"
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

    mutating func setProduct(id: String, name: String) {
        self.productId = id
        self.productName = name
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
