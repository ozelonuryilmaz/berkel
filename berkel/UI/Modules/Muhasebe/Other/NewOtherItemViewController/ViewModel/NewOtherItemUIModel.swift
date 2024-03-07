//
//  NewOtherItemUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol INewOtherItemUIModel {

    var otherSellerName: String { get }
    var otherSellerCategoryName: String { get }

    var newOtherData: OtherModel { get }
    var errorMessage: String? { get }

    var season: String { get }

    init(data: NewOtherItemPassData)

    // Setter
    mutating func setDesc(_ value: String)
}

struct NewOtherItemUIModel: INewOtherItemUIModel {

    // MARK: Definitions
    let otherSellerId: String?
    let otherSellerName: String
    let otherSellerCategoryId: String?
    let otherSellerCategoryName: String

    // MARK: Initialize
    init(data: NewOtherItemPassData) {
        self.otherSellerId = data.otherSellerId
        self.otherSellerName = data.otherSellerName
        self.otherSellerCategoryId = data.otherSellerCategoryId
        self.otherSellerCategoryName = data.otherSellerCategoryName
    }

    // MARK: Computed Props
    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    private var desc: String = ""

    var newOtherData: OtherModel {
        let date = Date().dateFormatterApiResponseType()
        return OtherModel(userId: userId,
                          otherSellerId: otherSellerId,
                          otherSellerName: otherSellerName,
                          otherSellerCategoryId: otherSellerCategoryId,
                          otherSellerCategoryName: otherSellerCategoryName,
                          isActive: true,
                          date: Date().dateFormatterApiResponseType(),
                          desc: desc
        )
    }
}

// MARK: Props
extension NewOtherItemUIModel {

    var errorMessage: String? {

        if desc.isEmpty {
            return "Lütfen hizmet açıklaması giriniz"
        }

        return nil
    }
}

// MARK: Setter
extension NewOtherItemUIModel {

    mutating func setDesc(_ value: String) {
        self.desc = value
    }
}
