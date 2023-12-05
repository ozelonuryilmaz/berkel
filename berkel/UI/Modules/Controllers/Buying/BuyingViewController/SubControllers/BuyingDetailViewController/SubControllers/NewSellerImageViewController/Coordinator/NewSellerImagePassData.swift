//
//  NewSellerImagePassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import Foundation

enum ImagePageType {
    case buying(sellerId: String, buyingId: String, buyingProductName: String)
    case seller(customerId: String, sellerId: String, sellerProductName: String)
}

struct NewSellerImagePassData: ICoordinatorPassData {

    let imagePageType: ImagePageType
    let imagePathType: ImagePathType
}

