//
//  SellerCollectionModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.11.2023.
//

import Foundation

struct SellerCollectionModel: Codable {

    var id: String?
    let userId: String?

    var isCalc: Bool

    let date: String?
    let price: Double
    let kdv: Double
    let daraliKg: Int
    let dara: Int
    let palet: Int
    let kasa: Int
    let faturaNo: String
    let desc: String
}
