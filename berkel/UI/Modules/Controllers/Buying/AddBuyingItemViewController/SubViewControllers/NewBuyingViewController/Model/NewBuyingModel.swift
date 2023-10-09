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
    let sellerName: String
    let productName: String
    let productKGPrice: Double
    let desc: String
    let isActive: Bool
    let payment: [NewBuyingPaymentModel]
    var collection: [NewBuyingCollectionModel]?
}

struct NewBuyingPaymentModel: Codable {

    let date: String
    let price: Int
}

struct NewBuyingCollectionModel: Codable {

    let date: String
}
