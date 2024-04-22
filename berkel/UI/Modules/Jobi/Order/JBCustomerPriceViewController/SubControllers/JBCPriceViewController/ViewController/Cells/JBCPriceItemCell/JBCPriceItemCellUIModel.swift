//
//  JBCPriceItemCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import Foundation

struct JBCPriceItemCellUIModel {

    let priceModel: JBCPriceModel

    var price: String {
        return priceModel.price.decimalString()
    }

    var date: String {
        return priceModel.date?.dateFormatToAppDisplayType() ?? ""
    }
    
    var desc: String {
        return priceModel.desc
    }
}
