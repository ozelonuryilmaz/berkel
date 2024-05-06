//
//  OrderDetailPaymentTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import Foundation

protocol IOrderDetailPaymentTableViewCellUIModel {

    var payment: OrderPaymentModel { get }
    var isActive: Bool { get }
}

struct OrderDetailPaymentTableViewCellUIModel: IOrderDetailPaymentTableViewCellUIModel {

    let payment: OrderPaymentModel
    let isActive: Bool
}
