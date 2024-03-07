//
//  CustomerModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import Foundation

struct CustomerModel: Codable {
    
    var id: String?
    let name: String
    let phoneNumber: String
    let description: String?
    let date: String?
}
