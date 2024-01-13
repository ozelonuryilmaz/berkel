//
//  NewSellerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

protocol INewSellerUIModel {

    var customerName: String { get }

    var newSellerData: SellerModel { get }
    var errorMessage: String? { get }

    var season: String { get }

    init(data: NewSellerPassData)

    // Setter
    mutating func setProduct(id: String, name: String)
    mutating func setKGPrice(_ value: String)
    mutating func setKDV(_ value: String)
    mutating func setDesc(_ value: String)
}

struct NewSellerUIModel: INewSellerUIModel {

    // MARK: Definitions
    let customerId: String
    let customerName: String

    // MARK: Initialize
    init(data: NewSellerPassData) {
        self.customerName = data.customerName
        self.customerId = data.customerId
    }

    // MARK: Computed Props

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    private var productId: String? = nil
    private var productName: String = ""
    private var kdv: Double = 0
    private var desc: String = ""
    private var kgPrice: Double = 0

    var newSellerData: SellerModel {
        let date = Date().dateFormatterApiResponseType()
        return SellerModel(userId: userId,
                           customerId: customerId,
                           customerName: customerName,
                           productId: productId,
                           productName: productName,
                           isActive: true,
                           date: date,
                           kdv: kdv,
                           kgPrice: kgPrice,
                           desc: desc)
    }
}

// MARK: Props
extension NewSellerUIModel {

    var errorMessage: String? {
        if productId == nil {
            return "Lütfen satış yaptığınız ürünü seçiniz"
        }

        if kgPrice <= 0.0 {
            return "Lütfen KG fiyatını giriniz"
        }

        if desc.isEmpty {
            return "Lütfen satın alım açıklaması giriniz"
        }

        return nil
    }
}

// MARK: Setter
extension NewSellerUIModel {

    mutating func setProduct(id: String, name: String) {
        self.productId = id
        self.productName = name
    }

    mutating func setKGPrice(_ value: String) {
        self.kgPrice = Double(value) ?? 0
    }

    mutating func setKDV(_ value: String) {
        self.kdv = Double(value) ?? 0
    }

    mutating func setDesc(_ value: String) {
        self.desc = value
    }
}
