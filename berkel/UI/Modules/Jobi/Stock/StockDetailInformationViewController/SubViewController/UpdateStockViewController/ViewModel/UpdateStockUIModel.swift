//
//  UpdateStockUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IUpdateStockUIModel {

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }
    var buttonTitle: String { get }

    init(data: UpdateStockPassData)

    mutating func setDate(date: String?)
    mutating func setCount(_ text: String)
    mutating func setDesc(_ text: String)
}

struct UpdateStockUIModel: IUpdateStockUIModel {

    // MARK: Definitions
    let type: UpdateStockType
    let stockModel: StockModel
    let subStockModel: SubStockModel

    // MARK: Initialize
    init(data: UpdateStockPassData) {
        self.type = data.type
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    var date: String? = Date().dateFormatterApiResponseType()
    var count: Int = 0
    var desc: String? = nil

    // MARK: Computed Props
    var userId: String? {
        return UserManager.shared.userId
    }

    var navigationTitle: String {
        return stockModel.stockName
    }

    var navigationSubTitle: String {
        return subStockModel.subStockName
    }

    var buttonTitle: String {
        switch type {
        case .add:
            return "Stok Ekle"
        case .remove:
            return "Stok Çıkar"
        }
    }
}

// MARK: Props
extension UpdateStockUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setCount(_ text: String) {
        self.count = Int(text) ?? 0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
