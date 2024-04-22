//
//  OrderImageModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import Foundation

struct OrderImageModel: Codable {

    var id: String?
    let jbCustomerId: String
    let userId: String?
    let orderId: String
    let orderName: String

    let date: String?
    let description: String?
    let imageUrl: String
}
