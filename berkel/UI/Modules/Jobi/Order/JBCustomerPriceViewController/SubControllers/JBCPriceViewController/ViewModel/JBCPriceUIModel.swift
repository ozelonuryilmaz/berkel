//
//  JBCPriceUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCPriceUIModel {
    
    var newJBCPricePassData: NewJBCPricePassData { get }
    var navTitle: String { get }

	 init(data: JBCPricePassData)

} 

struct JBCPriceUIModel: IJBCPriceUIModel {

	// MARK: Definitions
    private let customerModel: JBCustomerModel
    private let stockModel: StockModel
    private let subStockModel: SubStockModel

	// MARK: Initialize
    init(data: JBCPricePassData) {
        self.customerModel = data.customerModel
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    // MARK: Computed Props
    var newJBCPricePassData: NewJBCPricePassData {
        return NewJBCPricePassData(customerModel: customerModel,
                                   stockModel: stockModel,
                                   subStockModel: subStockModel)
    }
    
    var navTitle: String {
        return "\(stockModel.stockName) - \(subStockModel.subStockName)"
    }
}

// MARK: Props
extension JBCPriceUIModel {

}
