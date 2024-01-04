//
//  SellerPaymentModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.11.2023.
//

import Foundation

struct SellerPaymentModel: Codable {

    var id: String?
    let userId: String?
    let customerId: String?
    let customerName: String?
    let date: String?
    let payment: Int
    let description: String?
}
