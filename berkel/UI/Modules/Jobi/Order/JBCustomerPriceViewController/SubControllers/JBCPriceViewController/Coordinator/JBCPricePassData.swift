//
//  JBCPricePassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

struct JBCPricePassData: ICoordinatorPassData {
    
    let isPriceSelectable: Bool // Müşteri listesinden fiyat seçimi yapılamayacak

    let customerModel: JBCustomerModel
    let stockModel: StockModel
    let subStockModel: SubStockModel
}

