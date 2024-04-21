//
//  StockHeaderCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.04.2024.
//

import Foundation

struct StockHeaderCellUIModel {

    let stockModel: StockModel
    let isUpdateButtonHideable: Bool
    
    var stockId: String {
        return stockModel.id ?? ""
    }
    
    var stockName: String {
        return stockModel.stockName
    }
    
    var date: String {
        return stockModel.date.dateTimeFormatFull() ?? ""
    }
}
