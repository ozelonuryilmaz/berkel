//
//  UserModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.01.2024.
//

import Foundation

struct UserModel: Codable {
    
    var id: String
    let isAdmin: Bool
    let name: String
    let email: String
}
