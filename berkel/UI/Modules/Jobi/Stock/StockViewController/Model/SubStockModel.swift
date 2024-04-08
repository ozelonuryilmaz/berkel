//
//  SubStockModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.03.2024.
//

import Foundation

struct SubStockModel: Codable {
    
    var id: String? = nil
    let userId: String?
    let subStockName: String
    var date: String
    var counter: Int?
}
