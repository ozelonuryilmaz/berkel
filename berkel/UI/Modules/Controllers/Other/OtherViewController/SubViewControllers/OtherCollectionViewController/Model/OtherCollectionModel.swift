//
//  OtherCollectionModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import Foundation

struct OtherCollectionModel: Codable {

    var id: String?
    let userId: String?

    let otherSellerId: String?
    let otherSellerName: String?

    var isCalc: Bool

    let date: String?
    let desc: String
    let price: Double
}
