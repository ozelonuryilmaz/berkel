//
//  OtherTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import Foundation

protocol IOtherTableViewCellUIModel {

    var otherModel: OtherModel { get }
    var otherId: String { get }
    var otherSellerName: String { get }
    var otherSellerId: String { get }
    var desc: String { get }
    var categoryId: String { get }
    var categoryName: String { get }
    var isActive: Bool { get }
}

struct OtherTableViewCellUIModel: IOtherTableViewCellUIModel {

    let otherModel: OtherModel

    init(otherModel: OtherModel) {
        self.otherModel = otherModel
    }

    var otherId: String {
        return otherModel.id ?? ""
    }

    var otherSellerId: String {
        return otherModel.otherSellerId ?? ""
    }

    var otherSellerName: String {
        return otherModel.otherSellerName
    }

    var desc: String {
        return otherModel.desc
    }

    var categoryId: String {
        return otherModel.otherSellerCategoryId ?? ""
    }

    var categoryName: String {
        return otherModel.otherSellerCategoryName
    }

    var isActive: Bool {
        return otherModel.isActive
    }
}
