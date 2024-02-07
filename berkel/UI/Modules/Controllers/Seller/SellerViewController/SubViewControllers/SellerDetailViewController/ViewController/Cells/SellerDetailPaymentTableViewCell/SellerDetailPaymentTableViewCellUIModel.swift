//
//  SellerDetailPaymentTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import Foundation

protocol ISellerDetailPaymentTableViewCellUIModel {

    var payment: SellerPaymentModel { get }
    var isActive: Bool { get }
}

struct SellerDetailPaymentTableViewCellUIModel: ISellerDetailPaymentTableViewCellUIModel {

    let payment: SellerPaymentModel
    let isActive: Bool
}
