//
//  StockItemCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.04.2024.
//

import Foundation

struct StockItemCellUIModel {

    let subStock: SubStockModel

    var subStockName: String {
        return subStock.subStockName
    }
    
    var subStockCount: String {
        return "\(subStock.count) Adet"
    }
}
