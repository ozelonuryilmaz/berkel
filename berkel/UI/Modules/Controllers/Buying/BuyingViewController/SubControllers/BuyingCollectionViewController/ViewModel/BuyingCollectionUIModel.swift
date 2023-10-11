//
//  BuyingCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingCollectionUIModel {

    var navTitle: String { get }

    init(data: BuyingCollectionPassData)

}

struct BuyingCollectionUIModel: IBuyingCollectionUIModel {

    // MARK: Definitions
    let sellerName: String
    let productName: String

    var navTitle: String {
        return "\(sellerName) - \(productName)"
    }

    // MARK: Initialize
    init(data: BuyingCollectionPassData) {
        self.sellerName = data.sellerName
        self.productName = data.productName
    }

    // MARK: Computed Props
}

// MARK: Props
extension BuyingCollectionUIModel {

}
