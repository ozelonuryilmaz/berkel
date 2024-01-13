//
//  SellerCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

protocol ISellerCollectionUIModel {

    var sellerId: String? { get }
    var customerName: String { get }
    var productName: String { get }
    var price: Double { get }
    var kdv: Double { get }
    var season: String { get }

    init(data: SellerCollectionPassData)

    var errorMessage: String? { get }
    var data: SellerCollectionModel { get }
    var sellerCollectionModel: SellerCollectionModel? { get }
    
    var viewedData: Bool { get }

    func getTotalKg() -> String
    func getTotalPrice() -> String

    // Setter
    mutating func setDate(date: String?)
    mutating func setDaraliKG(_ text: String)
    mutating func setDara(_ text: String)
    mutating func setPrice(_ text: String)
    mutating func setKDV(_ text: String)
    mutating func setFaturaNo(_ text: String)
    mutating func setPalet(_ text: String)
    mutating func setKasa(_ text: String)
    mutating func setDesc(_ text: String)
}

struct SellerCollectionUIModel: ISellerCollectionUIModel {

    // MARK: Definitions
    let sellerId: String?
    let customerName: String
    let customerId: String?
    let productName: String
    
    var sellerCollectionModel: SellerCollectionModel? = nil

    // MARK: Initialize
    init(data: SellerCollectionPassData) {
        self.sellerId = data.sellerModel.id
        self.customerName = data.sellerModel.customerName
        self.customerId = data.sellerModel.customerId
        self.productName = data.sellerModel.productName
        self.price = data.sellerModel.kgPrice
        self.kdv = data.sellerModel.kdv
        
        self.sellerCollectionModel = data.sellerCollectionModel
        
        if let sellerCollection = data.sellerCollectionModel {
            self.daraliKg = sellerCollection.daraliKg
            self.dara = sellerCollection.dara
            self.palet = sellerCollection.palet
            self.kasa = sellerCollection.kasa
            self.faturaNo = sellerCollection.faturaNo
            self.desc = sellerCollection.desc
        }
    }

    // MARK: Computed Props
    var date: String? = Date().dateFormatterApiResponseType()

    var price: Double = 0
    var kdv: Double = 0

    var daraliKg: Int = 0
    var dara: Int = 0
    var palet: Int = 0
    var kasa: Int = 0
    var faturaNo: String = ""
    var desc: String = ""

    func getTotalKg() -> String {
        let result = self.totalKg()
        return "\(result > 0 ? result : 0)"
    }

    func getTotalPrice() -> String {
        let result = Double(self.totalKg())
        let price = result * price
        let kdv = result > 0 ? (kdv > 0 ? price * (1 + (kdv / 100)) : price) : 0
        return kdv.decimalString()
    }

    private func totalKg() -> Int {
        return daraliKg - dara
    }

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
    
    var viewedData: Bool {
        return self.sellerCollectionModel == nil
    }
}

// MARK: Props
extension SellerCollectionUIModel {

    var errorMessage: String? {
        if self.totalKg() <= 0 {
            return "Daralı Kilo ve Dara bilgilerini kontrol ediniz."
        }

        if price <= 0 {
            return "Lütfen KG fiyatını giriniz"
        }

        if faturaNo.isEmpty {
            return "Fatura numarasını giriniz"
        }

        return nil
    }

    var data: SellerCollectionModel {
        return SellerCollectionModel(userId: userId,
                                     customerId: customerId,
                                     customerName: customerName,
                                     isCalc: false,
                                     date: date,
                                     price: price,
                                     kdv: kdv,
                                     daraliKg: daraliKg,
                                     dara: dara,
                                     palet: palet,
                                     kasa: kasa,
                                     faturaNo: faturaNo,
                                     desc: desc)
    }
}

// MARK: Setter
extension SellerCollectionUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setDaraliKG(_ text: String) {
        self.daraliKg = Int(text) ?? 0
    }

    mutating func setDara(_ text: String) {
        self.dara = Int(text) ?? 0
    }

    mutating func setPrice(_ text: String) {
        self.price = Double(text) ?? 0.0
    }

    mutating func setKDV(_ text: String) {
        self.kdv = Double(text) ?? 0.0
    }

    mutating func setFaturaNo(_ text: String) {
        self.faturaNo = text
    }

    mutating func setPalet(_ text: String) {
        self.palet = Int(text) ?? 0
    }

    mutating func setKasa(_ text: String) {
        self.kasa = Int(text) ?? 0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }

}
