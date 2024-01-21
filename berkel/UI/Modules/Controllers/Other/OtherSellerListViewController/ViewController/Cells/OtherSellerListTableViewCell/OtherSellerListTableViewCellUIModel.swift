//
//  OtherSellerListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import Foundation

protocol IOtherSellerListTableViewCellUIModel {

    var id: String? { get }
    var categoryId: String? { get }
    var categoryName: String? { get }
    var name: String { get }
    var desc: String? { get }
    var phoneNumber: String { get }
}

struct OtherSellerListTableViewCellUIModel: IOtherSellerListTableViewCellUIModel {

    let id: String?
    let categoryId: String?
    let categoryName: String?
    let name: String
    let desc: String?
    let phoneNumber: String
}
