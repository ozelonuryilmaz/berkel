//
//  BuyingCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.10.2023.
//

import Foundation

protocol IBuyingCollectionTableViewCellUIModel {
    
    var buyingId: String? { get }
    var collectionId: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }
    
    var date: String { get }
    var totalKg: String { get }
    var warehouseKg: String { get }
}

struct BuyingCollectionTableViewCellUIModel: IBuyingCollectionTableViewCellUIModel {
    
    let buyingId: String?
    let collectionId: String?
    var isCalc: Bool
    let isActive: Bool
    let date: String
    let totalKg: String
    let warehouseKg: String
}
