//
//  BuyingTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 29.09.2023.
//


import UIKit

protocol IBuyingTableViewCellUIModel {

    var id: String { get }
}

struct BuyingTableViewCellUIModel: IBuyingTableViewCellUIModel {

    let id: String
}
