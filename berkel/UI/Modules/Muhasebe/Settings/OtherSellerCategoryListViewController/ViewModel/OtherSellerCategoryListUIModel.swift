//
//  OtherSellerCategoryListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

protocol IOtherSellerCategoryListUIModel {

	 init(data: OtherSellerCategoryListPassData)

    mutating func setResponse(_ response: [OtherSellerCategoryListModel])
    mutating func addOtherSellerCategory(_ otherSellerCategory: OtherSellerCategoryListModel)

    func getOtherSellerCategory(index: Int) -> OtherSellerCategoryListModel

    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> OtherSellerCategoryListTableViewCellUIModel
} 

struct OtherSellerCategoryListUIModel: IOtherSellerCategoryListUIModel {

	// MARK: Definitions
    private var items: [OtherSellerCategoryListModel] = []

	// MARK: Initialize
    init(data: OtherSellerCategoryListPassData) {

    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [OtherSellerCategoryListModel]) {
        self.items = response
    }

    mutating func addOtherSellerCategory(_ otherSellerCategory: OtherSellerCategoryListModel) {
        self.items.insert(otherSellerCategory, at: 0)
    }
    
    func getOtherSellerCategory(index: Int) -> OtherSellerCategoryListModel {
        return items[index]
    }

    func getNumberOfRowsInSection() -> Int {
        return self.items.count
    }

    func getItemCellUIModel(index: Int) -> OtherSellerCategoryListTableViewCellUIModel {
        return OtherSellerCategoryListTableViewCellUIModel(otherSellerCategory: items[index])
    }
}

// MARK: Props
extension OtherSellerCategoryListUIModel {

}
