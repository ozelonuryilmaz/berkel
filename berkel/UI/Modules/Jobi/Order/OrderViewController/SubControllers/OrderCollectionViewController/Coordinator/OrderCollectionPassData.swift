//
//  OrderCollectionPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

struct OrderCollectionPassData: ICoordinatorPassData {
    let orderModel: OrderModel
    var orderCollectionModel: OrderCollectionModel? = nil
}

