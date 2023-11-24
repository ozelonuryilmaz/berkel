//
//  SellerDetailPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Foundation

struct SellerDetailPassData: ICoordinatorPassData {

    let sellerId: String
    let customerName: String
    let customerId: String
    var isActive: Bool
}
