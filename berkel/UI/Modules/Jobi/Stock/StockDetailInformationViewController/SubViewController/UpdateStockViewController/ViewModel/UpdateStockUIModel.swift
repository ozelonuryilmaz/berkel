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

    init(data: UpdateStockPassData)

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

    // MARK: Computed Props
    var navigationTitle: String {
        return stockModel.stockName
    }

    var navigationSubTitle: String {
        return subStockModel.subStockName
    }
}

// MARK: Props
extension UpdateStockUIModel {

}
