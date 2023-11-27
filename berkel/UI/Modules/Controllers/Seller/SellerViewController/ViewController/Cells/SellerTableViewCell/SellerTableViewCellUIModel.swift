//
//  SellerTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.11.2023.
//

import Foundation

protocol ISellerTableViewCellUIModel {

    var sellerModel: SellerModel { get }
    var sellerId: String { get }
    var customerName: String { get }
    var customerId: String { get }
    var desc: String { get }
    var productName: String { get }
    var isActive: Bool { get }
}

struct SellerTableViewCellUIModel: ISellerTableViewCellUIModel {

    let sellerModel: SellerModel

    init(sellerModel: SellerModel) {
        self.sellerModel = sellerModel
    }
    
    var sellerId: String {
        return sellerModel.id ?? ""
    }
    
    var customerId: String {
        return sellerModel.customerId ?? ""
    }

    var customerName: String {
        return sellerModel.customerName
    }

    var desc: String {
        return sellerModel.desc
    }
    
    var productName: String {
        return sellerModel.productName
    }
    
    var isActive: Bool {
        return sellerModel.isActive
    }
}
