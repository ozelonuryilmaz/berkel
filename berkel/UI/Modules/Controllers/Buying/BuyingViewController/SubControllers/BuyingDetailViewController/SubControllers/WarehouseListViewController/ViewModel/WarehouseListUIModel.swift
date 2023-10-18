//
//  WarehouseListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IWarehouseListUIModel {

    var buyingId: String? { get }
    var collectionId: String? { get }
    var date: String? { get }
    var sellerName: String { get }
    var productName: String { get }

    var season: String { get }

    init(data: WarehouseListPassData)

}

struct WarehouseListUIModel: IWarehouseListUIModel {

    // MARK: Definitions
    let warehouses: [WarehouseModel]

    let buyingId: String?
    let collectionId: String?
    let date: String?
    let sellerName: String
    let productName: String

    // MARK: Initialize
    init(data: WarehouseListPassData) {
        self.warehouses = data.warehouses

        self.buyingId = data.buyingId
        self.collectionId = data.collectionId
        self.date = data.date
        self.sellerName = data.sellerName
        self.productName = data.productName
        
        print("** \(warehouses)")
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    // MARK: Computed Props
}

// MARK: Props
extension WarehouseListUIModel {

}
