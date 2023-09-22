//
//  AddBuyingItemTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol IAddBuyingItemTableViewCellUIModel {

    var name: String { get }
    var tc: String { get }
    var desc: String { get }
    var phoneNumber: String { get }
}

struct AddBuyingItemTableViewCellUIModel: IAddBuyingItemTableViewCellUIModel {

    let name: String
    let tc: String
    let desc: String
    let phoneNumber: String
}
