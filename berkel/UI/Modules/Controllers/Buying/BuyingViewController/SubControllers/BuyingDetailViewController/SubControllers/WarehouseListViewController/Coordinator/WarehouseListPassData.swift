//
//  WarehouseListPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

struct WarehouseListPassData: ICoordinatorPassData {

    let buyingId: String?
    let isActive: Bool
    let collectionId: String?
    let date: String?
    let sellerName: String
    let productName: String
    
    let maxKg: Int // Girilebilecek max depo çıktısı. Toplam KG büyük olamaz
    let warehouses: [WarehouseModel]
}

