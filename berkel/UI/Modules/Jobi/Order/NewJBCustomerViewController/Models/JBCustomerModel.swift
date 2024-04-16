//
//  JBCustomerModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//

import Foundation

struct JBCustomerModel: Codable {

    var id: String?
    let name: String
    let phoneNumber: String
    let description: String?
    let date: String?
}
