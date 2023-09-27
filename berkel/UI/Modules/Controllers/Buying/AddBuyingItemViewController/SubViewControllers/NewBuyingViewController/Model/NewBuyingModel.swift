//
//  NewBuyingModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.09.2023.
//

import Foundation

struct NewBuyingModel: Codable {

    var id: String? = nil
    let date: String
    let sellerId: String
    let productName: String
    let productKGPrice: Float
    let desc: String
    let isActive: Bool
    let payment: [NewBuyingPaymentModel]
}

struct NewBuyingPaymentModel: Codable {

    let date: String
    let price: Int
}
