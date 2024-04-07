//
//  UpdateStockPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

struct UpdateStockPassData: ICoordinatorPassData {

    let type: UpdateStockType
    let stockModel: StockModel
    let subStockModel: SubStockModel
}

enum UpdateStockType {
    case add
    case remove
}
