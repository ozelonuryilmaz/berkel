//
//  JBCustomerPriceUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerPriceUIModel {

    var isLastRequest: Bool { get }
    var customerName: String { get }

    var season: String { get }

    init(data: JBCustomerPricePassData)

    mutating func resetValues()
    mutating func sortedStocks()
    mutating func setStockIdx(idx: [String])
    mutating func setStock(stock: StockModel, subStock: [SubStockModel])

    func getStockModel(subStockId: String?) -> StockModel?
    
    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel
}

struct JBCustomerPriceUIModel: IJBCustomerPriceUIModel {

    // MARK: Definitions
    private var stocks: [StockListModel] = []
    private var stockIdx: [String] = []
    let customerName: String


    // MARK: Initialize
    init(data: JBCustomerPricePassData) {
        self.customerName = data.customerName
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var isLastRequest: Bool {
        return stocks.count == stockIdx.count
    }

    // MARK: Computed Props
}

// MARK: Props
extension JBCustomerPriceUIModel {

    mutating func setStock(stock: StockModel, subStock: [SubStockModel]) {
        let _subStocks = subStock.sorted(by: { $0.subStockName < $1.subStockName })
        self.stocks.append(StockListModel(stock: stock, subStocks: _subStocks))
    }

    mutating func setStockIdx(idx: [String]) {
        self.stockIdx = idx
    }

    mutating func sortedStocks() {
        self.stocks = self.stocks.filter({ !$0.subStocks.isEmpty })
        self.stocks = self.stocks.sorted(by: { $0.stock.stockName < $1.stock.stockName })
    }

    mutating func resetValues() {
        self.stocks.removeAll()
        self.stockIdx.removeAll()
    }

    // SubStock detayına gidilirken stock bilgisi de gönderilecek
    func getStockModel(subStockId: String?) -> StockModel? {
        var stockModel: StockModel? = nil
        self.stocks.forEach { stock in
            if stock.subStocks.contains(where: { $0.id == subStockId }) {
                stockModel = stock.stock
            }
        }
        return stockModel
    }
}

internal extension JBCustomerPriceUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.stocks.count
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        return self.stocks[section].subStocks.count
    }

    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel {
        return StockHeaderCellUIModel(stockModel: self.stocks[section].stock,
                                      isUpdateButtonHideable: true)
    }

    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel {
        return StockItemCellUIModel(subStock: self.stocks[indexPath.section].subStocks[indexPath.row])
    }
}
