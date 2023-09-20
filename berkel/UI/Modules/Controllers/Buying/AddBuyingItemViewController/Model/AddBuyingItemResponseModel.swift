//
//  AddBuyingItemResponse.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import Foundation

struct AddBuyingItemResponseModel: Codable {

    let id: String
    let name: String
    let tckn: String
    let phoneNumber: String
    let description: String?
    let date: String
}
