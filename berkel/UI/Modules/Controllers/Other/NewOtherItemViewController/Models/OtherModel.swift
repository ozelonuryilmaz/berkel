//
//  OtherModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Foundation

struct OtherModel: Codable {

    var id: String? = nil
    let userId: String?
    let otherSellerId: String?
    let otherSellerName: String
    let otherSellerCategoryId: String?
    let otherSellerCategoryName: String

    var isActive: Bool
    let date: String
    let desc: String
}
