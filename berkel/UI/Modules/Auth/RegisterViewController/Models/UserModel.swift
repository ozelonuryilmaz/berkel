//
//  UserModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.01.2024.
//

import Foundation

struct UserModel: Codable {
    
    var id: String
    var isAdmin: Bool
    var isStockAdmin: Bool? = false
    var accessuuid: String? = nil
    let name: String
    let email: String
    let date: String
}
