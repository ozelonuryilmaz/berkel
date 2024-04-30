//
//  OrderPaymentModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.04.2024.
//

import Foundation

struct OrderPaymentModel: Codable {

    var id: String?
    let orderId: String?
    let userId: String?
    let customerId: String?

    let customerName: String

    let date: String?
    let payment: Int
    let description: String?
}
