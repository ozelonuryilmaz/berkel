//
//  MyStockListItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.03.2024.
//

import Foundation

struct MyStockListItemCellUIModel {

    let subStock: SubStockModel
    
    var subStockName: String {
        return subStock.subStockName
    }
}
