//
//  CavusListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import Foundation

protocol ICavusListTableViewCellUIModel {

    var id: String? { get }
    var name: String { get }
    var desc: String? { get }
    var phoneNumber: String { get }
}

struct CavusListTableViewCellUIModel: ICavusListTableViewCellUIModel {

    let id: String?
    let name: String
    let desc: String?
    let phoneNumber: String
}
