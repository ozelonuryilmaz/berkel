//
//  BuyingCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import UIKit

protocol IBuyingCollectionUIModel {

    var buyingId: String { get }
    var season: String { get }
    var kgPrice: Double { get }
    var sellerName: String { get }
    var productName: String { get }

    var data: BuyingCollectionModel { get }
    var viewedData: BuyingCollectionModel? { get }
    var isViewedPage: Bool { get }

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

    func getTotalKg() -> String
    func getTotalPrice() -> String
}

struct BuyingCollectionUIModel: IBuyingCollectionUIModel {

    // MARK: Definitions
    let viewedData: BuyingCollectionModel?

    let buyingId: String
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
        self.buyingId = data.buyingId
        self.sellerName = data.sellerName
        self.productName = data.productName
        self.viewedData = data.model

        self.mappedToTextFields(model: data.model)
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

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var data: BuyingCollectionModel {
        return BuyingCollectionModel(
            id: nil,
            userId: userId,
            isCalc: false,
            date: date,
            kgPrice: kgPrice,
            kantarFisi: kantarFisi,
            palet: palet,
            redCase: redCase,
            greenCase: greenCase,
            black22FoodCase: black22FoodCase,
            bigBlackCase: bigBlackCase,
            percentFire: percentFire,
            paletDari: paletDari,
            redDari: redDari,
            greenDari: greenDari,
            black22FoodDari: black22FoodDari,
            bigBlackDari: bigBlackDari
        )
    }

    // MARK: Computed Props

    // Sadece  veri mi gösterilecek
    var isViewedPage: Bool {
        return self.viewedData != nil
    }


    private var isHaveAnyCase: Bool {
        return redCase > 0 || greenCase > 0 || black22FoodCase > 0 || bigBlackCase > 0
    }

    private func totalKg() -> Double {
        let kg: Double = Double(kantarFisi) - Double(((Double(palet) * paletDari) + (Double(redCase) * redDari) + (Double(greenCase) * greenDari) + (Double(black22FoodCase) * black22FoodDari) + (Double(bigBlackCase) * bigBlackDari)))

        return percentFire > 0 ? kg - (kg * percentFire / 100): kg
    }

    func getTotalKg() -> String {
        let kg = totalKg()
        return isHaveAnyCase && Double(kantarFisi) > kg && kg > 0 ? "\(kg.decimalString())" : "0"
    }

    func getTotalPrice() -> String {
        let kg = totalKg()
        let price = kg * kgPrice
        return isHaveAnyCase && Double(kantarFisi) > kg && price > 0 ? "\(price.decimalString())" : "0"
    }
}

// MARK: Viewed Page
extension BuyingCollectionUIModel {

    mutating func mappedToTextFields(model: BuyingCollectionModel?) {
        guard let model = model else { return }
        self.setDate(date: model.date)
        self.setKantarFisi(String(model.kantarFisi))
        self.setPalet(String(model.palet))
        self.setRedCase(String(model.redCase))
        self.setGreenCase(String(model.greenCase))
        self.set22BlackFoodCase(String(model.black22FoodCase))
        self.setBigBlackCase(String(model.bigBlackCase))
        self.setPercentFire(String(model.percentFire))
        self.setKgPrice(String(model.kgPrice))
        self.setPaletDari(String(model.paletDari))
        self.setRedDari(String(model.redDari))
        self.setGreenDari(String(model.greenDari))
        self.set22BlackDari(String(model.black22FoodDari))
        self.setBigBlackDari(String(model.bigBlackDari))
    }
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
        self.percentFire = text.isEmpty ? self.let_percentFire: Double(text) ?? self.let_percentFire
    }

    mutating func setKgPrice(_ text: String) {
        self.kgPrice = text.isEmpty ? self.let_kgPrice: Double(text) ?? self.let_kgPrice
    }

    mutating func setPaletDari(_ text: String) {
        self.paletDari = text.isEmpty ? self.let_paletDari: Double(text) ?? self.let_paletDari
    }

    mutating func setRedDari(_ text: String) {
        self.redDari = text.isEmpty ? self.let_redDari: Double(text) ?? self.let_redDari
    }

    mutating func setGreenDari(_ text: String) {
        self.greenDari = text.isEmpty ? self.let_greenDari: Double(text) ?? self.let_greenDari
    }

    mutating func set22BlackDari(_ text: String) {
        self.black22FoodDari = text.isEmpty ? self.let_black22FoodDari: Double(text) ?? self.let_black22FoodDari
    }

    mutating func setBigBlackDari(_ text: String) {
        self.bigBlackDari = text.isEmpty ? self.let_bigBlackDari: Double(text) ?? self.let_bigBlackDari
    }
}
