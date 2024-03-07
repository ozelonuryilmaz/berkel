//
//  OtherPaymentModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import Foundation

struct OtherPaymentModel: Codable {

    var id: String?
    let userId: String?
    let otherSellerId: String?
    let otherSellerName: String?
    let date: String?
    let payment: Int
    let description: String?
}
