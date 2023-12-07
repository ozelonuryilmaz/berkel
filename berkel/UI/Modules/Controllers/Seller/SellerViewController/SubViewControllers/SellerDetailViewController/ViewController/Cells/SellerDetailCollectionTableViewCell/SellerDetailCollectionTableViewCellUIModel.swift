//
//  SellerDetailCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import Foundation

protocol ISellerDetailCollectionTableViewCellUIModel {

    var sellerModel: SellerModel { get }
    var sellerCollectionModel: SellerCollectionModel { get }
    
    var sellerId: String? { get }
    var collectionId: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }
    
    var date: String { get }
    var faturaNo: String { get }
    var totalKg: String { get }
    var totalPrice: String { get }
}

struct SellerDetailCollectionTableViewCellUIModel: ISellerDetailCollectionTableViewCellUIModel {

    let sellerModel: SellerModel
    let sellerCollectionModel: SellerCollectionModel
    
    let sellerId: String?
    let collectionId: String?
    var isCalc: Bool
    let isActive: Bool
    
    let date: String
    let faturaNo: String
    let totalKg: String
    let totalPrice: String

}
