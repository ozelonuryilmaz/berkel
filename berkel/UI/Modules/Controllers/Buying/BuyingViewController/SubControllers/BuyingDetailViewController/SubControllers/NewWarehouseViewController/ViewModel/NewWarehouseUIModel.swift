//
//  NewWarehouseUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewWarehouseUIModel {

    var buyingId: String? { get }
    var collectionId: String? { get }
    var date: String? { get }

    init(data: NewWarehousePassData)

}

struct NewWarehouseUIModel: INewWarehouseUIModel {

    // MARK: Definitions
    let buyingId: String?
    let collectionId: String?
    let date: String?

    // MARK: Initialize
    init(data: NewWarehousePassData) {
        self.buyingId = data.buyingId
        self.collectionId = data.collectionId
        self.date = data.date
    }

    // MARK: Computed Props
}

// MARK: Props
extension NewWarehouseUIModel {

}
