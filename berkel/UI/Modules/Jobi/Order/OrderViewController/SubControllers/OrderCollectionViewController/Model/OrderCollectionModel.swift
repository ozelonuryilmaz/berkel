//
//  OrderCollectionModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.04.2024.
//

import Foundation

struct OrderCollectionModel: Codable {

    var id: String?
    let orderId: String?
    let userId: String?
    let stockId: String?
    let subStockId: String?
    let customerId: String?

    let stockName: String
    let subStockName: String
    let customerName: String

    let count: Int
    let price: Double
    let kdv: Int
    let desc: String?
    let date: String?
    var isCalc: Bool
}
