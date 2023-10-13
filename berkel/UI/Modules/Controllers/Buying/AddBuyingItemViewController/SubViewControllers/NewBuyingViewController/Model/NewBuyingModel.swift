//
//  NewBuyingModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.09.2023.
//

import Foundation

struct NewBuyingModel: Codable {

    var id: String? = nil
    let userId: String?
    let date: String
    let sellerId: String
    let sellerName: String
    let productName: String
    let productKGPrice: Double
    let desc: String
    let isActive: Bool
}

struct NewBuyingPaymentModel: Codable {

    var id: String?
    let userId: String?
    let date: String
    let payment: Int
}
