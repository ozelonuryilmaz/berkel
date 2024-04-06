//
//  StockDetailInformationUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IStockDetailInformationUIModel {
    
    var season: String { get }
    var stockId: String { get }
    var subStockId: String { get }

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(data: StockDetailInformationPassData)

}

struct StockDetailInformationUIModel: IStockDetailInformationUIModel {

    // MARK: Definitions
    let stockModel: StockModel
    let subStockModel: SubStockModel

    // MARK: Initialize
    init(data: StockDetailInformationPassData) {
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    // MARK: Computed Props

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
    
    var stockId: String {
        return stockModel.id ?? ""
    }
    
    var subStockId: String {
        return subStockModel.id ?? ""
    }

    var navigationTitle: String {
        return stockModel.stockName
    }

    var navigationSubTitle: String {
        return subStockModel.subStockName
    }
}

// MARK: Props
extension StockDetailInformationUIModel {

}
