//
//  AddBuyingItemTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol IAddBuyingItemTableViewCellUIModel {

    var id: String { get }
    var name: String { get }
    var tc: String { get }
    var desc: String { get }
    var date: String { get }
    var phoneNumber: String { get }
}

struct AddBuyingItemTableViewCellUIModel: IAddBuyingItemTableViewCellUIModel {

    let id: String
    let name: String
    let tc: String
    let desc: String
    let date: String
    let phoneNumber: String
}
