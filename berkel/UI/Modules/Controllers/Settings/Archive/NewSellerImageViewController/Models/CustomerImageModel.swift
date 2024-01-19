//
//  CustomerImageModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.12.2023.
//

import Foundation

struct CustomerImageModel: Codable {

    var id: String?
    let customerId: String
    let userId: String?
    let sellerId: String
    let sellerProductName: String

    let date: String?
    let description: String?
    let imageUrl: String
}
