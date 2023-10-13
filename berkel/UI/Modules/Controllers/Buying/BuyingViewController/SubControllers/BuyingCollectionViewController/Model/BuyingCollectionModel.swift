//
//  BuyingCollectionModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import Foundation

struct BuyingCollectionModel: Codable {

    let id: String
    let userId: String
    let sellerId: String
    let collectionId: String
    
    let isCalc: Bool

    let date: String?
    let kgPrice: Double
    let kantarFisi: Int
    let palet: Int
    let redCase: Int
    let greenCase: Int
    let black22FoodCase: Int
    let bigBlackCase: Int
    let percentFire: Double
    let paletDari: Double
    let redDari: Double
    let greenDari: Double
    let black22FoodDari: Double
    let bigBlackDari: Double
}
