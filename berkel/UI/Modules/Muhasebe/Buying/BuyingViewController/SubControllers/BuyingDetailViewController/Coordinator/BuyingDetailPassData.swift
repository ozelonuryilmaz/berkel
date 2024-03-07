//
//  BuyingDetailPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//

import Foundation

struct BuyingDetailPassData: ICoordinatorPassData {

    let buyingId: String
    let sellerId: String
    let sellerName: String
    let productName: String
    let isActive: Bool
}

