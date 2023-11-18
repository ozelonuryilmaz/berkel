//
//  ProductListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import UIKit

protocol IProductListUIModel {

    init(data: ProductListPassData)

    

    mutating func setResponse(_ response: [ProductListModel])
    mutating func addProduct(_ product: ProductListModel)

    func getProduct(index: Int) -> ProductListModel

    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> ProductListTableViewCellUIModel
}

struct ProductListUIModel: IProductListUIModel {

    // MARK: Definitions
    private var items: [ProductListModel] = []

    // MARK: Initialize
    init(data: ProductListPassData) {

    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [ProductListModel]) {
        self.items = response
    }

    mutating func addProduct(_ product: ProductListModel) {
        self.items.insert(product, at: 0)
    }
    
    func getProduct(index: Int) -> ProductListModel {
        return items[index]
    }

    func getNumberOfRowsInSection() -> Int {
        return self.items.count
    }

    func getItemCellUIModel(index: Int) -> ProductListTableViewCellUIModel {
        return ProductListTableViewCellUIModel(product: items[index])
    }
}

// MARK: Props
extension ProductListUIModel {

}
