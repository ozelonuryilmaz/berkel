//
//  JBCustomerListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import Foundation

protocol IJBCustomerListTableViewCellUIModel {

    var id: String? { get }
    var name: String { get }
    var desc: String? { get }
    var phoneNumber: String { get }
}

struct JBCustomerListTableViewCellUIModel: IJBCustomerListTableViewCellUIModel {

    let id: String?
    let name: String
    let desc: String?
    let phoneNumber: String
}
