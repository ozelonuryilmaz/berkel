//
//  OtherDetailPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import Foundation

struct OtherDetailPassData: ICoordinatorPassData {

    let otherId: String
    let otherSellerName: String
    let otherSellerId: String
    var isActive: Bool
    
    let categoryName: String
    let categoryId: String
}
