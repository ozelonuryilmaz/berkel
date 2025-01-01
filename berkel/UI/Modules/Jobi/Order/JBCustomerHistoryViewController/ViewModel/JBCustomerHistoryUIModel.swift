//
//  JBCustomerHistoryUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerHistoryUIModel {

    var season: String { get }
    var customerId: String { get }
    var customerName: String { get }

    init(data: JBCustomerHistoryPassData)

    func getCutomerOrderIdx(orders: [OrderModel]) -> [String]
    mutating func groupOrdersIntoStockListModels(orderDetails: [OrderCollectionModel])
    
    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel
}

struct JBCustomerHistoryUIModel: IJBCustomerHistoryUIModel {

    // MARK: Definitions
    private var stocks: [StockListModel] = []

    let season: String
    let customerModel: JBCustomerModel

    // MARK: Initialize
    init(data: JBCustomerHistoryPassData) {
        self.season = data.season
        self.customerModel = data.customerModel
    }

    // MARK: Computed Props
    
    var customerId: String {
        return customerModel.id ?? ""
    }

    var customerName: String {
        return customerModel.name
    }
}

// MARK: Props
extension JBCustomerHistoryUIModel {

    func getCutomerOrderIdx(orders: [OrderModel]) -> [String] {
        return orders.compactMap({ order in
            if order.jbCustomerId == self.customerModel.id {
                return order.id
            }
            return nil
        })
    }

    mutating func groupOrdersIntoStockListModels(orderDetails: [OrderCollectionModel]) {
        var stockDictionary: [String: StockListModel] = self.stocks.reduce(into: [:]) { dict, stockListModel in
            dict[stockListModel.stock.id ?? ""] = stockListModel
        }

        for order in orderDetails {
            guard let stockId = order.stockId, let subStockId = order.subStockId else { continue }

            // Anahtar oluştur (stockId bazlı)
            let stockKey = stockId

            // Geçici değişken oluştur
            var stockListModel = stockDictionary[stockKey] ?? {
                let stock = StockModel(
                    id: stockId,
                    userId: order.userId,
                    stockName: order.stockName,
                    date: order.date ?? ""
                )
                return StockListModel(stock: stock, subStocks: [])
            }()

            // SubStockModel oluştur ve ekle
            if let index = stockListModel.subStocks.firstIndex(where: { $0.id == subStockId }) {
                // Eğer subStock zaten varsa, counter değerini güncelle
                stockListModel.subStocks[index].counter = (stockListModel.subStocks[index].counter ?? 0) + order.count
            } else {
                let subStock = SubStockModel(
                    id: subStockId,
                    userId: order.userId,
                    subStockName: order.subStockName,
                    date: order.date ?? "",
                    counter: order.count
                )
                stockListModel.subStocks.append(subStock)
            }

            // Güncellenmiş modeli tekrar sözlüğe ekle
            stockDictionary[stockKey] = stockListModel
        }

        self.stocks = Array(stockDictionary.values)
    }

}

// TableView
internal extension JBCustomerHistoryUIModel {

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
