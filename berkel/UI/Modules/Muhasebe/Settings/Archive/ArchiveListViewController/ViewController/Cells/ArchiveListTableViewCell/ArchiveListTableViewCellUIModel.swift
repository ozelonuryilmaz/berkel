//
//  ArchiveListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import Foundation

protocol IArchiveListTableViewCellUIModel {

    var imageUrl: String { get }
    var date: String { get }
    var productName: String { get }
    var desc: String { get }
}

struct ArchiveListTableViewCellUIModel: IArchiveListTableViewCellUIModel {

    let imageUrl: String
    let date: String
    let productName: String
    let desc: String
}
