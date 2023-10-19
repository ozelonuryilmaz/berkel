//
//  BuyingCollectionModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import Foundation

struct BuyingCollectionModel: Codable {

    var id: String?
    let userId: String?
    
    var isCalc: Bool

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
    
    // Depo çıkması bilgileri Toplama(collections) altında collection olarak saklanıyor
    // Her toplama(collections) için warehouses(depo çıktısı) çağırılıp UIModel'deki collection güncellenmeli
    var warehouses: [WarehouseModel]? = nil
}
