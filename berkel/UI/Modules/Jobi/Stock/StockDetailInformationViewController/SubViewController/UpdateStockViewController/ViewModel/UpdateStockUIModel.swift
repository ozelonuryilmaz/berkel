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

    var data: UpdateStockModel { get }
    var season: String { get }
    var stockId: String { get }
    var subStockId: String { get }

    init(data: UpdateStockPassData)

    mutating func setDate(date: String?)
    mutating func setCount(_ text: String)
    mutating func setDesc(_ text: String)

    func getCount() -> Int
}

struct UpdateStockUIModel: IUpdateStockUIModel {

    // MARK: Definitions
    private let type: UpdateStockType
    private let stockModel: StockModel
    private let subStockModel: SubStockModel

    private var date: String? = Date().dateFormatterApiResponseType()
    private var count: Int = 0
    private var desc: String? = nil

    // MARK: Initialize
    init(data: UpdateStockPassData) {
        self.type = data.type
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    // MARK: Computed Props
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

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

    var stockId: String {
        return stockModel.id ?? ""
    }

    var subStockId: String {
        return subStockModel.id ?? ""
    }

    var data: UpdateStockModel {
        return UpdateStockModel(stockId: stockId,
                                subStockId: subStockId,
                                userId: userId,
                                count: getCount(),
                                date: date ?? Date().dateFormatterApiResponseType(),
                                desc: desc,
                                type: type.rawValue)
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

    func getCount() -> Int {
        switch self.type {
        case .add:
            return self.count
        case .remove:
            return self.count * (-1)
        }
    }
}
