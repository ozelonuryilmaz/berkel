//
//  OtherSellerImageModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import Foundation

struct OtherSellerImageModel: Codable {

    var id: String?
    let otherSellerId: String
    let userId: String?
    let otherId: String
    let otherProductName: String

    let date: String?
    let description: String?
    let imageUrl: String
}
