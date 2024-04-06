//
//  StockUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IStockUIModel {

    var isLastRequest: Bool { get }
    var season: String { get }

    init()

    mutating func resetValues()
    mutating func sortedStocks()
    mutating func setStockIdx(idx: [String])
    mutating func setStock(stock: StockModel, subStock: [SubStockModel])

    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel
}

struct StockUIModel: IStockUIModel {

    // MARK: Definitions
    private var stocks: [StockListModel] = []
    private var stockIdx: [String] = []

    // MARK: Initialize
    init() { }

    // MARK: Computed Props
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var isLastRequest: Bool {
        return stocks.count == stockIdx.count
    }
}

// MARK: Props
extension StockUIModel {

    mutating func setStock(stock: StockModel, subStock: [SubStockModel]) {
        let _subStocks = subStock.sorted(by: { $0.subStockName < $1.subStockName })
        self.stocks.append(StockListModel(stock: stock, subStocks: _subStocks))
    }

    mutating func setStockIdx(idx: [String]) {
        self.stockIdx = idx
    }

    mutating func sortedStocks() {
        self.stocks = self.stocks.filter( { !$0.subStocks.isEmpty } )
        self.stocks = self.stocks.sorted(by: { $0.stock.stockName < $1.stock.stockName })
    }

    mutating func resetValues() {
        self.stocks.removeAll()
        self.stockIdx.removeAll()
    }
}

internal extension StockUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.stocks.count
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        return self.stocks[section].subStocks.count
    }

    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel {
        return StockHeaderCellUIModel(stockModel: self.stocks[section].stock)
    }

    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel {
        return StockItemCellUIModel(subStock: self.stocks[indexPath.section].subStocks[indexPath.row])
    }
}
