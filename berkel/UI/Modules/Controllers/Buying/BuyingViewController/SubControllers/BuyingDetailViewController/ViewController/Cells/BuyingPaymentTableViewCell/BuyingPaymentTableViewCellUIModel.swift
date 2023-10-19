//
//  BuyingPaymentTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.10.2023.
//

import Foundation

protocol IBuyingPaymentTableViewCellUIModel {

    var payment: NewBuyingPaymentModel { get }
}

struct BuyingPaymentTableViewCellUIModel: IBuyingPaymentTableViewCellUIModel {
    
    let payment: NewBuyingPaymentModel
}
