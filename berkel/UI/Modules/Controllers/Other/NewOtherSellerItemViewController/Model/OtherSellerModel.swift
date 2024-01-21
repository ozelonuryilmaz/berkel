//
//  OtherSellerModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Foundation

struct OtherSellerModel: Codable {

    var id: String?
    var categoryId: String?
    var categoryName: String
    let name: String
    let phoneNumber: String
    let description: String?
    let date: String?
}
