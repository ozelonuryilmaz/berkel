//
//  SellerDetailPaymentTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import Foundation

protocol ISellerDetailPaymentTableViewCellUIModel {

    var payment: SellerPaymentModel { get }
}

struct SellerDetailPaymentTableViewCellUIModel: ISellerDetailPaymentTableViewCellUIModel {

    let payment: SellerPaymentModel
}
