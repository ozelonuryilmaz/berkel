//
//  OrderTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.04.2024.
//

import Foundation

protocol IOrderTableViewCellUIModel {

    var orderModel: OrderModel { get }
    
    var orderId: String { get }
    var jbCustomerId: String { get }
    var jbCustomerName: String { get }
    var desc: String { get }
    var isActive: Bool { get }
}

struct OrderTableViewCellUIModel: IOrderTableViewCellUIModel {

    let orderModel: OrderModel

    init(orderModel: OrderModel) {
        self.orderModel = orderModel
    }

    var orderId: String {
        return orderModel.id ?? ""
    }

    var jbCustomerId: String {
        return orderModel.jbCustomerId ?? ""
    }

    var jbCustomerName: String {
        return orderModel.jbCustomerName
    }

    var desc: String {
        return orderModel.desc
    }

    var isActive: Bool {
        return orderModel.isActive
    }
}
