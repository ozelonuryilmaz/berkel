//
//  JBCPriceUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCPriceUIModel {

    var newJBCPricePassData: NewJBCPricePassData { get }
    var navTitle: String { get }

    var isPriceSelectable: Bool { get }
    var customerId: String { get }
    var stockId: String { get }
    var subStockId: String { get }

    var season: String { get }

    init(data: JBCPricePassData)
    
    mutating func setPrices(_ prices: [JBCPriceModel])
    
    // TableView
    func getNumberOfItemsInRow() -> Int
    func getItemCellUIModel(indexPath: IndexPath) -> JBCPriceItemCellUIModel
    
    mutating func appendFirstItem(data: JBCPriceModel)
}

struct JBCPriceUIModel: IJBCPriceUIModel {

    // MARK: Definitions
    private var prices: [JBCPriceModel] = []
    
    let isPriceSelectable: Bool
    private let customerModel: JBCustomerModel
    private let stockModel: StockModel
    private let subStockModel: SubStockModel

    // MARK: Initialize
    init(data: JBCPricePassData) {
        self.isPriceSelectable = data.isPriceSelectable
        self.customerModel = data.customerModel
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    // MARK: Computed Props
    var newJBCPricePassData: NewJBCPricePassData {
        return NewJBCPricePassData(customerModel: customerModel,
                                   stockModel: stockModel,
                                   subStockModel: subStockModel)
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var navTitle: String {
        return "\(stockModel.stockName) - \(subStockModel.subStockName)"
    }

    var customerId: String {
        return customerModel.id ?? ""
    }

    var stockId: String {
        return stockModel.id ?? ""
    }

    var subStockId: String {
        return subStockModel.id ?? ""
    }
}

// MARK: Props
extension JBCPriceUIModel {

    mutating func setPrices(_ prices: [JBCPriceModel]) {
        self.prices = prices
    }

    mutating func appendFirstItem(data: JBCPriceModel) {
        self.prices.insert(data, at: 0)
    }
}

internal extension JBCPriceUIModel {

    func getNumberOfItemsInRow() -> Int {
        return self.prices.count
    }

    func getItemCellUIModel(indexPath: IndexPath) -> JBCPriceItemCellUIModel {
        return JBCPriceItemCellUIModel(priceModel: self.prices[indexPath.row])
    }
}
