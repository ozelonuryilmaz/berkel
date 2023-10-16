//
//  BuyingCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.10.2023.
//

import Foundation

protocol IBuyingCollectionTableViewCellUIModel {
    
    var id: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }
    
    var date: String { get }
    var totalKg: String { get }
    var warehouseKg: String { get }
}

struct BuyingCollectionTableViewCellUIModel: IBuyingCollectionTableViewCellUIModel {
    
    let id: String?
    var isCalc: Bool
    let isActive: Bool
    let date: String
    let totalKg: String
    let warehouseKg: String
}
