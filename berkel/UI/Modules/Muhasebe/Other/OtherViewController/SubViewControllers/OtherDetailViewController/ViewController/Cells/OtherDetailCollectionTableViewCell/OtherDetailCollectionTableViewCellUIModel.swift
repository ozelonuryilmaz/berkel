//
//  OtherDetailCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.02.2024.
//

import Foundation

protocol IOtherDetailCollectionTableViewCellUIModel {

    var otherModel: OtherModel? { get }
    var otherCollectionModel: OtherCollectionModel? { get }
    
    var otherId: String? { get }
    var collectionId: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }
    
    var date: String { get }
    var price: String { get }
    var desc: String { get }
    
    var isVisibleButtons: Bool { get }
}

struct OtherDetailCollectionTableViewCellUIModel: IOtherDetailCollectionTableViewCellUIModel {

    let otherModel: OtherModel?
    let otherCollectionModel: OtherCollectionModel?
    
    let otherId: String?
    let collectionId: String?
    let isCalc: Bool
    let isActive: Bool
    
    let date: String
    var price: String
    var desc: String

    // Seller Charts için eklendi
    let isVisibleButtons: Bool
}
