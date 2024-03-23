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
}

// MARK: Props
extension MyStockListUIModel {

}
