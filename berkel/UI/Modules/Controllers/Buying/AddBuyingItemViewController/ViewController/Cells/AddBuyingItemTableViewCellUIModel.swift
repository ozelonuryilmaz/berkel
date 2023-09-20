//
//  AddBuyingItemTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol IAddBuyingItemTableViewCellUIModel {

    var name: String { get }
}

struct AddBuyingItemTableViewCellUIModel: IAddBuyingItemTableViewCellUIModel {

    let name: String
}
