//
//  NewWarehousePassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import Foundation

struct NewWarehousePassData: ICoordinatorPassData {

    let buyingId: String?
    let collectionId: String?
    let date: String?
    let sellerName: String
    let productName: String
    let maxKg: Int
}

