//
//  BuyingCollectionPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

struct BuyingCollectionPassData: ICoordinatorPassData {
    
    let buyingId: String
    
    let kgPrice: Double
    let sellerName: String
    let productName: String
    let model: BuyingCollectionModel?
}

