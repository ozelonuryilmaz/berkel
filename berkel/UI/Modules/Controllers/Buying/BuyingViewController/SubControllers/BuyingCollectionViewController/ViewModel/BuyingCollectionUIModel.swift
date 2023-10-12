//
//  BuyingCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingCollectionUIModel {

    var kgPrice: Double { get }
    var sellerName: String { get }
    var productName: String { get }

    init(data: BuyingCollectionPassData)

    mutating func setDate(date: String?)
    mutating func setKantarFisi(_ text: String)
    mutating func setPalet(_ text: String)
    mutating func setRedCase(_ text: String)
    mutating func setGreenCase(_ text: String)
    mutating func set22BlackFoodCase(_ text: String)
    mutating func setBigBlackCase(_ text: String)
    mutating func setPercentFire(_ text: String)
    mutating func setKgPrice(_ text: String)
    mutating func setPaletDari(_ text: String)
    mutating func setRedDari(_ text: String)
    mutating func setGreenDari(_ text: String)
    mutating func set22BlackDari(_ text: String)
    mutating func setBigBlackDari(_ text: String)

}

struct BuyingCollectionUIModel: IBuyingCollectionUIModel {

    // MARK: Definitions
    let sellerName: String
    let productName: String
    let let_kgPrice: Double
    let let_percentFire: Double = 5.0
    let let_paletDari: Double = 22.0
    let let_redDari: Double = 2.0
    let let_greenDari: Double = 1.5
    let let_black22FoodDari: Double = 0.5
    let let_bigBlackDari: Double = 1.0

    // MARK: Initialize
    init(data: BuyingCollectionPassData) {
        self.kgPrice = data.kgPrice
        self.let_kgPrice = data.kgPrice
        self.sellerName = data.sellerName
        self.productName = data.productName
    }

    var date: String? = Date().dateFormatterApiResponseType()
    var kgPrice: Double = 0.0

    var kantarFisi: Int = 0
    var palet: Int = 0
    var redCase: Int = 0
    var greenCase: Int = 0
    var black22FoodCase: Int = 0
    var bigBlackCase: Int = 0

    var percentFire: Double = 5.0
    var paletDari: Double = 22.0
    var redDari: Double = 2.0
    var greenDari: Double = 1.5
    var black22FoodDari: Double = 0.5
    var bigBlackDari: Double = 1.0

    // MARK: Computed Props
}

// MARK: Setter
extension BuyingCollectionUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setKantarFisi(_ text: String) {
        self.kantarFisi = Int(text) ?? 0
    }

    mutating func setPalet(_ text: String) {
        self.palet = Int(text) ?? 0
    }

    mutating func setRedCase(_ text: String) {
        self.redCase = Int(text) ?? 0
    }

    mutating func setGreenCase(_ text: String) {
        self.greenCase = Int(text) ?? 0
    }

    mutating func set22BlackFoodCase(_ text: String) {
        self.black22FoodCase = Int(text) ?? 0
    }

    mutating func setBigBlackCase(_ text: String) {
        self.bigBlackCase = Int(text) ?? 0
    }

    mutating func setPercentFire(_ text: String) {
        self.percentFire = text.isEmpty ? self.let_percentFire : Double(text) ?? self.let_percentFire
    }

    mutating func setKgPrice(_ text: String) {
        self.kgPrice = text.isEmpty ? self.let_kgPrice : Double(text) ?? self.let_kgPrice
    }

    mutating func setPaletDari(_ text: String) {
        self.paletDari = text.isEmpty ? self.let_paletDari : Double(text) ?? self.let_paletDari
    }

    mutating func setRedDari(_ text: String) {
        self.redDari = text.isEmpty ? self.let_redDari : Double(text) ?? self.let_redDari
    }

    mutating func setGreenDari(_ text: String) {
        self.greenDari = text.isEmpty ? self.let_greenDari : Double(text) ?? self.let_greenDari
    }

    mutating func set22BlackDari(_ text: String) {
        self.black22FoodDari = text.isEmpty ? self.let_black22FoodDari : Double(text) ?? self.let_black22FoodDari
    }

    mutating func setBigBlackDari(_ text: String) {
        self.bigBlackDari = text.isEmpty ? self.let_bigBlackDari : Double(text) ?? self.let_bigBlackDari
    }
}
