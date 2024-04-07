//
//  StockDetailInfoTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import Foundation

protocol IStockDetailInfoTableViewCellUIModel {

    var count: Int { get }
    var date: String { get }
    var desc: String { get }
    var type: String { get }
}

struct StockDetailInfoTableViewCellUIModel: IStockDetailInfoTableViewCellUIModel {

    let updateStockModel: UpdateStockModel
    
    var count: Int {
        return updateStockModel.count
    }
    
    var date: String {
        return updateStockModel.date.dateTimeFormatFull() ?? ""
    }
    
    var desc: String {
        return updateStockModel.desc ?? ""
    }
    
    var type: String {
        return updateStockModel.type
    }
}
