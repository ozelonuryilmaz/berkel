//
//  SellerModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import Foundation

struct SellerModel: Codable {

    var id: String? = nil
    let userId: String?
    let customerId: String?
    let customerName: String
    let productId: String?
    let productName: String
    var isActive: Bool
    let date: String
    let kdv: Double
    let kgPrice: Double
    let desc: String
}
