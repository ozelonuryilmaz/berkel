//
//  NewWarehouseUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewWarehouseUIModel {

    var buyingId: String? { get }
    var collectionId: String? { get }
    var date: String? { get }
    var sellerName: String { get }
    var productName: String { get }
    var season: String { get }
    var isHaveAnyResults: Bool { get }

    init(data: NewWarehousePassData)

    // Setter
    mutating func setDate(date: String?)
    mutating func setKg(_ text: String)
    mutating func setPrice(_ text: String)
    mutating func setDesc(_ text: String)

    var data: WarehouseModel { get }
}

struct NewWarehouseUIModel: INewWarehouseUIModel {

    // MARK: Definitions
    let buyingId: String?
    let collectionId: String?
    let date: String?
    let sellerName: String
    let productName: String
    let maxKg: Int

    // MARK: Initialize
    init(data: NewWarehousePassData) {
        self.buyingId = data.buyingId
        self.collectionId = data.collectionId
        self.date = data.date
        self.sellerName = data.sellerName
        self.productName = data.productName
        self.maxKg = data.maxKg
    }

    var isHaveAnyResults: Bool {
        return kg > 0 && price > 0 && kg <= maxKg
    }

    var warehouseDate: String? = Date().dateFormatterApiResponseType()
    var kg: Int = 0
    var price: Double = 0
    var desc: String? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var data: WarehouseModel {
        return WarehouseModel(
            id: nil,
            userId: self.userId,
            date: self.warehouseDate,
            wavehouseKg: self.kg,
            wavehousePrice: self.price,
            description: self.desc
        )
    }

    // MARK: Computed Props
}

// MARK: Props
extension NewWarehouseUIModel {

}

// MARK: Setter
extension NewWarehouseUIModel {

    mutating func setDate(date: String?) {
        self.warehouseDate = date
    }

    mutating func setKg(_ text: String) {
        self.kg = Int(text) ?? 0
    }

    mutating func setPrice(_ text: String) {
        self.price = Double(text) ?? 0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }

}
