//
//  MyStockListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IMyStockListUIModel {

    var season: String { get }

    init(data: MyStockListPassData)

    func getStockModel(name: String) -> StockModel
    func getSubStockModel(name: String) -> SubStockModel
    
    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> MyStockListHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> MyStockListItemCellUIModel
}

struct MyStockListUIModel: IMyStockListUIModel {

    // MARK: Definitions

    // MARK: Initialize
    init(data: MyStockListPassData) {

    }

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
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

}

internal extension MyStockListUIModel {
    
    func getNumberOfItemsInSection() -> Int {
        return 2
    }
    
    func getNumberOfItemsInRow(section: Int) -> Int {
        return 3
    }
    
    func getSectionUIModel(section: Int) -> MyStockListHeaderCellUIModel {
        return MyStockListHeaderCellUIModel(stockId: "ctNeZdN6fZJxpHgkBVu8", stockName: "Limon")
    }
    
    func getItemCellUIModel(indexPath: IndexPath) -> MyStockListItemCellUIModel {
        return MyStockListItemCellUIModel(subStockName: "0.33lt")
    }
}
