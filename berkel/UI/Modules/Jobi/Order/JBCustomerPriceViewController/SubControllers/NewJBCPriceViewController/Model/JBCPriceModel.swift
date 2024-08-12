//
//  JBCPriceModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import Foundation

struct JBCPriceModel: Codable {
    
    var id: String?
    let userId: String?
    
    let stockId: String?
    let stockName: String?
    let subStockId: String?
    let subStockName: String?
    let customerId: String?
    let customerName: String?
    let isActive: Bool?

    let date: String?
    let price: Double
    let desc: String
}
