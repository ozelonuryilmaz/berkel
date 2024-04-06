//
//  MyStockListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IMyStockListUIModel {

    var isLastRequest: Bool { get }
    var season: String { get }

    init(data: MyStockListPassData)

    mutating func sortedStocks()
    mutating func resetValues()

    mutating func setStockIdx(idx: [String])
    mutating func setStock(stock: StockModel, subStock: [SubStockModel])

    func getStockModel(name: String) -> StockModel
    func getSubStockModel(name: String) -> SubStockModel
    
    func isHaveStock(name: String) -> Bool
    func isHaveSubStock(stockId: String, name: String) -> Bool

    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> MyStockListHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> MyStockListItemCellUIModel
}

struct MyStockListUIModel: IMyStockListUIModel {

    // MARK: Definitions
    private var stocks: [StockListModel] = []
    private var stockIdx: [String] = []

    // MARK: Initialize
    init(data: MyStockListPassData) { }

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var isLastRequest: Bool {
        return stocks.count == stockIdx.count
    }

    func isHaveStock(name: String) -> Bool {
        return stocks.contains(where: { s in s.stock.stockName.lowercased() == name.lowercased() })
    }

    func isHaveSubStock(stockId: String, name: String) -> Bool {
        let subStock = self.stocks.first(where: { $0.stock.id == stockId })?.subStocks ?? []
        return subStock.contains(where: { ss in ss.subStockName.lowercased() == name.lowercased() })
    }

    func getStockModel(name: String) -> StockModel {
        return StockModel(userId: userId,
                          stockName: name,
                          date: Date().dateFormatterApiResponseType())
    }

    func getSubStockModel(name: String) -> SubStockModel {
        return SubStockModel(userId: userId,
                             subStockName: name,
                             date: Date().dateFormatterApiResponseType(),
                             count: 0)
    }
}

// MARK: Props
extension MyStockListUIModel {

    mutating func setStock(stock: StockModel, subStock: [SubStockModel]) {
        let _subStocks = subStock.sorted(by: { $0.subStockName < $1.subStockName })
        self.stocks.append(StockListModel(stock: stock, subStocks: _subStocks))
    }

    mutating func setStockIdx(idx: [String]) {
        self.stockIdx = idx
    }

    mutating func sortedStocks() {
        self.stocks = self.stocks.sorted(by: { $0.stock.stockName < $1.stock.stockName })
    }

    mutating func resetValues() {
        self.stocks.removeAll()
        self.stockIdx.removeAll()
    }
}

internal extension MyStockListUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.stocks.count
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        return self.stocks[section].subStocks.count
    }

    func getSectionUIModel(section: Int) -> MyStockListHeaderCellUIModel {
        return MyStockListHeaderCellUIModel(stockModel: self.stocks[section].stock)
    }

    func getItemCellUIModel(indexPath: IndexPath) -> MyStockListItemCellUIModel {
        return MyStockListItemCellUIModel(subStock: self.stocks[indexPath.section].subStocks[indexPath.row])
    }
}
