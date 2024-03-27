//
//  MyStockListHeaderCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.03.2024.
//

import Foundation

struct MyStockListHeaderCellUIModel {

    let stockModel: StockModel
    
    var stockId: String {
        return stockModel.id ?? ""
    }
    
    var stockName: String {
        return stockModel.stockName
    }
}
