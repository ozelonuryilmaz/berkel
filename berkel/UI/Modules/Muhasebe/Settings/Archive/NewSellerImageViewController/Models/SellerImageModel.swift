//
//  SellerImageModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import Foundation

struct SellerImageModel: Codable {

    var id: String?
    let sellerId: String
    let userId: String?
    let buyingId: String
    let buyingProductName: String

    let date: String?
    let description: String?
    let imageUrl: String
}
