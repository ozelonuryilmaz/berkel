//
//  OrderModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import Foundation

struct OrderModel: Codable {

    var id: String?
    let userId: String?
    let jbCustomerName: String
    let jbCustomerId: String?
    let desc: String
    var isActive: Bool
    let date: String
}
