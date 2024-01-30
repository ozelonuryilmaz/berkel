//
//  OtherCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit

protocol IOtherCollectionUIModel {

    var otherId: String? { get }
    var otherSellerName: String { get }
    var categoryName: String { get }
    var season: String { get }

    init(data: OtherCollectionPassData)

    var errorMessage: String? { get }
    var data: OtherCollectionModel { get }
    var otherCollectionModel: OtherCollectionModel? { get }

    var viewedData: Bool { get }

    // Setter
    mutating func setDate(date: String?)
    mutating func setPrice(_ text: String)
    mutating func setDesc(_ text: String)
}

struct OtherCollectionUIModel: IOtherCollectionUIModel {

    // MARK: Definitions
    let otherId: String?
    let otherSellerId: String?
    let otherSellerName: String
    let categoryName: String

    var otherCollectionModel: OtherCollectionModel? = nil

    // MARK: Initialize
    init(data: OtherCollectionPassData) {
        self.otherId = data.otherModel.id
        self.otherSellerId = data.otherModel.otherSellerId
        self.otherSellerName = data.otherModel.otherSellerName
        self.categoryName = data.otherModel.otherSellerCategoryName

        self.otherCollectionModel = data.otherCollectionModel

        if let otherCollection = data.otherCollectionModel {
            self.price = otherCollection.price
            self.desc = otherCollection.desc
        }
    }

    // MARK: Computed Props

    var date: String? = Date().dateFormatterApiResponseType()
    var price: Double = 0
    var desc: String = ""

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var viewedData: Bool {
        return self.otherCollectionModel == nil
    }
}

// MARK: Props
extension OtherCollectionUIModel {

    var errorMessage: String? {

        if price <= 0 {
            return "Lütfen aldığınız hizmetin fiyatını giriniz"
        }

        if desc.isEmpty {
            return "Lütfen aldığınız hizmetin açıklamasını giriniz"
        }

        return nil
    }

    var data: OtherCollectionModel {
        return OtherCollectionModel(userId: userId,
                                    otherSellerId: otherSellerId,
                                    otherSellerName: otherSellerName,
                                    isCalc: false,
                                    date: date,
                                    desc: desc,
                                    price: price)
    }
}

// MARK: Props
extension OtherCollectionUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setPrice(_ text: String) {
        self.price = Double(text) ?? 0.0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
