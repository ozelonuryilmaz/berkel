//
//  StockModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Foundation

struct StockModel: Codable {
    
    var id: String? = nil
    let userId: String?
    let stockName: String
    var date: String
}
