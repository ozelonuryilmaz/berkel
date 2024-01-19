//
//  WarehouseListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.10.2023.
//

import Foundation


protocol IWarehouseListTableViewCellUIModelUIModel {

    var warehouses: WarehouseModel { get }
    var result: Double { get }
}

struct WarehouseListTableViewCellUIModelUIModel: IWarehouseListTableViewCellUIModelUIModel {
    
    let warehouses: WarehouseModel
    let result: Double
}
