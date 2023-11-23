//
//  CustomerListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import Foundation

protocol ICustomerListTableViewCellUIModel {

    var id: String? { get }
    var name: String { get }
    var desc: String? { get }
    var phoneNumber: String { get }
}

struct CustomerListTableViewCellUIModel: ICustomerListTableViewCellUIModel {

    let id: String?
    let name: String
    let desc: String?
    let phoneNumber: String
}
