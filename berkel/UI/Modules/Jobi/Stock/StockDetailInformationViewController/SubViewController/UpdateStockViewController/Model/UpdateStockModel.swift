//
//  UpdateStockModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import Foundation

struct UpdateStockModel: Codable {

    var id: String? = nil
    var stockId: String?
    var subStockId: String?
    let userId: String?
    let count: Int
    var date: String
    var desc: String?
    let type: String
}
