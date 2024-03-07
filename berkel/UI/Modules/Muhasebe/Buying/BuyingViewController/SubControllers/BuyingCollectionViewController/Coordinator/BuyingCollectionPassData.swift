//
//  BuyingCollectionPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import Foundation

struct BuyingCollectionPassData: ICoordinatorPassData {
    
    let buyingId: String
    
    let kgPrice: Double
    let sellerId: String?
    let sellerName: String
    let productName: String
    let model: BuyingCollectionModel?
}

